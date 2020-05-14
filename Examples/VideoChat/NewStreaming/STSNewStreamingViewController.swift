//
//  STSNewStreamingViewController.swift
//  VideoChat
//
//  Created by Allen on 2020/5/14.
//  Copyright © 2020 StraaS.io. All rights reserved.
//

import AVFoundation
import HaishinKit_Straas
import Photos
import UIKit
import VideoToolbox
import StraaSStreamingSDK

final class STSNewStreamingViewController: UIViewController {
    private static let kUserDefaultsKeyStreamKey = "kUserDefaultsKeyStreamKey"

    @IBOutlet private weak var titleField: UITextField!
    @IBOutlet private weak var streamKeyField: UITextField!
    @IBOutlet private weak var streamKeyScanButton: UIButton!
    @IBOutlet private weak var streamWayControl: UISegmentedControl!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var flipOutputButton: UIButton!
    @IBOutlet private weak var audioButton: UIButton!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var bitrateLabel: UILabel!
    @IBOutlet private weak var fpsLabel: UILabel!
    @IBOutlet private weak var previewView: GLHKView?
    @IBOutlet private weak var settingView: UIView!
    @IBOutlet private weak var streamKeySettingView: UIView!
    @IBOutlet private weak var previewViewWidthConstraint: NSLayoutConstraint!
//    var filterType: STSStreamingFilterType!
    var shouldPrepareAgain: Bool!

    enum StreamWay: Int {
        case streamKey
        case title
    }

    private var streamingManager: StreamingManager!

//    + (instancetype)viewControllerFromStoryboard {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        STSStreamingViewController * vc =
//        [storyboard instantiateViewControllerWithIdentifier:@"STSStreamingViewController"];
//        return vc;
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []

        func hideNavigationControllerIfNecessary() {
            guard UIDevice.current.userInterfaceIdiom == .phone else {
                return
            }

            let isLandscape = UIDevice.current.orientation.isLandscape
            navigationController?.isNavigationBarHidden = isLandscape
        }

        hideNavigationControllerIfNecessary()

        settingView.isHidden = true
        shouldPrepareAgain = false
        updateMirrorButton()

        STSApplication.configureApplication { [weak self] (success, error) in
            guard let self = self else {
                return
            }

            guard error == nil, success == true else {
                self.title = self.title?.appending(" (failed configure app)")
                print("\n CONFIGURE APPLICATION ERROR: \n \(error!.localizedDescription) \n")
                return
            }

            self.prepare()
        }

        let cachedStreamKey = UserDefaults.standard.string(forKey: type(of: self).kUserDefaultsKeyStreamKey)
        streamKeyField.text = cachedStreamKey
    }

    func prepare() {

        func setupStreamingManager() {

            func memberJWT() -> String {
                return kStraaSProdMemberJWT;
            }

            self.streamingManager = StreamingManager.getInstance(with: memberJWT())

            guard let streamingManager = self.streamingManager else {
                return
            }

            streamingManager.addObserver(self, forKeyPath: "currentFPS", options: .new, context: nil)

            streamingManager.delegate = self
            //        self.streamingManager.captureDevicePosition = AVCaptureDevicePositionBack;
            //        self.streamingManager.flipFrontCameraOutputHorizontally = YES;
            updateFlipOutputButtonVisibility()
//                self.filterType = STSStreamingFilterTypeNone;
//                [self updateFilter:self.filterType];
        }

        setupStreamingManager()

        guard let streamingManager = self.streamingManager else {
            return
        }

        let config = STSStreamingPrepareConfig()
        config.outputImageOrientation = UIApplication.shared.statusBarOrientation
        config.maxResolution = .resolution720p
        config.fitAllCamera = false

        streamingManager.prepare(previewView: self.previewView!, configuration: config, success: { [weak self] (outputSize) in
            self?.startButton.isEnabled = true
            self?.settingView.isHidden = false
            print("prepare success with output size: \(NSCoder.string(for: outputSize))")
        }, failure: { [weak self] (error) in
            self?.startButton.isEnabled = false
            self?.settingView.isHidden = true

            let errorMessage = "prepare failed with error: \(error.localizedDescription)"
            self?.onError(with: "error", errorMessage: errorMessage)
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldPrepareAgain {
            shouldPrepareAgain = false
            prepare()
        }

        streamingManager?.addObserver(self, forKeyPath: "currentFPS", options: .new, context: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        streamingManager?.removeObserver(self, forKeyPath: "currentFPS")
//        rtmpStream.close()
//        rtmpStream.dispose()
    }

    func shouldAutorotate() -> Bool {
        if streamingManager?.state == .connecting
            || streamingManager?.state == .streaming
            || streamingManager?.state == .disconnecting {
            return false
        }

        return true
    }

    //MARK: IBActions

    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        guard let streamingManager = self.streamingManager else {
            return
        }

        streamingManager.captureDevicePosition = (streamingManager.captureDevicePosition == .back) ? .front : .back

        updateFlipOutputButtonVisibility()
        updateMirrorButton()
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        guard let streamingManager = streamingManager else {
            return
        }

        if streamingManager.state == .prepared {
            statusLabel.text = "connecting"
            enableAllInputs(false)
            if streamWayControl.selectedSegmentIndex == StreamWay.streamKey.rawValue {
                guard let streamKey = streamKeyField.text else {
                    return
                }

                startStreamingWithStreamKey(streamKey)
            } else if streamWayControl.selectedSegmentIndex == StreamWay.title.rawValue {
                guard let title = titleField.text else {
                    return
                }

                startStreamingWithTitle(title)

                //for testing startStreamingWithConfiguration
//                let configuration = STSStreamingLiveEventConfig(title: "test title", listed: true)
//                startStreamingWithConfiguration(configuration)
            }
        } else if streamingManager.state == .streaming {
            statusLabel.text = "disconnecting"
            startButton.isEnabled = false
            stopStreaming()
        }
    }

    @IBAction func flipOutputButtonPressed(_ sender: UIButton) {
        guard self.streamingManager.captureDevicePosition == .front else {
            return
        }

        //FIXME:
        self.streamingManager.isFlipFrontCameraOutputHorizontal = !self.streamingManager.isFlipFrontCameraOutputHorizontal
        updateMirrorButton()
    }

    private func updateMirrorButton() {
        guard let streamingManager = self.streamingManager else {
            flipOutputButton.setTitleColor(UIColor.systemBlue, for: .normal)
            return
        }

        //FIXME:
        if streamingManager.isFlipFrontCameraOutputHorizontal {
            flipOutputButton.setTitleColor(UIColor.systemBlue, for: .normal)
        } else {
            flipOutputButton.setTitleColor(UIColor.white, for: .normal)
        }
    }

    @IBAction private func streamWayControlValueChanged(_ segment: UISegmentedControl) {
        titleField.isHidden = !(streamWayControl.selectedSegmentIndex == StreamWay.title.rawValue)
        streamKeySettingView.isHidden = !(streamWayControl.selectedSegmentIndex == StreamWay.streamKey.rawValue)
        view.endEditing(true)
    }

    @IBAction private func streamKeyScanButtonPressed(_ sender: UIButton) {
        let vc = STSQRCodeScannerViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    @IBAction func audioButtonPressed(_ sender: UIButton) {
        guard let streamingManager = streamingManager else {
            return
        }

        streamingManager.audioEnabled = !streamingManager.audioEnabled

        if !streamingManager.audioEnabled {
            audioButton.setTitleColor(UIColor(red: 0.0, green: 100.0/255.0, blue: 255.0/255.0, alpha: 1.0), for: .normal)
        } else {
            audioButton.setTitleColor(.white, for: .normal)
        }
    }

    //MARK: private methods

    func startStreamingWithTitle(_ title: String) {
        let trimmedTitle = title.trimmingCharacters(in: CharacterSet.whitespaces)
        if trimmedTitle.count == 0 {
            onError(with: "Error", errorMessage: "The title should not be empty.")
            return
        }

        let configuration = STSStreamingLiveEventConfig(title: trimmedTitle, listed: true)

        guard let streamingManager = streamingManager else {
            return
        }

        streamingManager.createLiveEvent(with: configuration, success: { [weak self] (liveId) in
            self?.startStreamingWithLiveId(liveId)
        }) { [weak self] (error, liveId) in
            if error.domain == STSStreamingErrorDomain && error.code == STSStreamingErrorCode.errorCodeLiveCountLimit.rawValue {
                print("Current member has an unended live event, try to start streaming by reusing that event. liveId = \(liveId)")
                guard let liveId = liveId else {
                    assert(false)
                    return
                }
                self?.startStreamingWithLiveId(liveId)
                return
            }

            let errorTitle = "STSStreamingManager failed to create a new live event."
            let errorMessage = "Error: \(error.localizedDescription) \nLive id = \(String(describing: liveId))"
            self?.onError(with: errorTitle, errorMessage: errorMessage)
        }
    }

    func startStreamingWithConfiguration(_ configuration: STSStreamingLiveEventConfig) {
        guard let streamingManager = streamingManager else {
            return
        }

        streamingManager.startStreamingWithConfguration(configuration, success: { (liveId) in
            print("startStreamingWithConfguration success")
        }) { (error, liveId) in
            print("startStreamingWithConfguration failed")

            if error.domain == STSStreamingErrorDomain && error.code == NSError.stsStreamingLiveCountLimitError().code {
                guard let liveId = liveId else {
                    assert(false)
                    return
                }

                print("Current member has an unended live event, try to start streaming by reusing that event. liveId=\(liveId)")
                self.startStreamingWithLiveId(liveId)
                return
            }
            let errorTitle = "STSStreamingManager failed to create a new live event."
            let errorMessage = "Error: \(error.localizedDescription) \nLive id=\(String(describing: liveId))"
            self.onError(with: errorTitle, errorMessage: errorMessage)
        }
    }

    func startStreamingWithLiveId(_ liveId: String) {
        guard let streamingManager = self.streamingManager else {
            return
        }

        streamingManager.startStreamingWithLiveID(liveId, success: { [weak self] in
            print("Did start streaming: liveId = \(liveId)")
            self?.didStartStreaming()
        }) { [weak self] (error) in
            guard let self = self else { return }
            if error.domain == STSStreamingErrorDomain && error.code == STSStreamingErrorCode.errorCodeEventExpired.rawValue {
                print("The live event expired, try to end it and restart streaming. liveId = \(liveId)")
                self.endLiveEvent(liveId: liveId, success: { [weak self] in
                    guard let self = self else { return }
                    if let title = self.titleField.text {
                        self.startStreamingWithTitle(title)
                    }
                }, failure: { (error) in
                    let errorTitle = "There is an unended live event(liveId = \(liveId), but STSStreamingManager failed to end it."
                    let errorMessage = "Error: \(error.localizedDescription)"
                    self.onError(with: errorTitle, errorMessage: errorMessage)
                })
                return
            }

            let errorTitle = "STSStreamingManager failed to start streaming."
            let errorMessage = "Error: \(error.localizedDescription) \nLive id = \(String(describing: liveId))"
            self.onError(with: errorTitle, errorMessage: errorMessage)
        }
    }

    func endLiveEvent(liveId: String, success:@escaping () -> Void, failure:@escaping (_ error: NSError) -> Void) {
        guard let streamingManager = self.streamingManager else {
            return
        }

        streamingManager.endLiveEvent(with: liveId, success: { (liveId) in
            success()
        }) { (error) in
            failure(error)
        }
    }

    func startStreamingWithStreamKey(_ streamKey: String) {
        guard let streamingManager = streamingManager else {
            return
        }

        guard streamKey.count > 0 else {
            onError(with: "Error", errorMessage: "The stream key should not be empty.")
            return
        }

        streamingManager.startStreamingWithStreamKey(streamKey, success: { [weak self] in
            print("Did start streaming with given stream key.")
            self?.didStartStreaming()
        }, failure: { [weak self] (error) in
            let errorTitle = "STSStreamingManager failed to start streaming with given stream key."
            let errorMessage = "Error: \(error.localizedDescription)"
            self?.onError(with: errorTitle, errorMessage: errorMessage)
        })
    }

    func didStartStreaming() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.statusLabel.text = "start"
            self.startButton.isEnabled = true
            self.startButton.setTitle("Stop", for: .normal)

            self.updateUIWithBitrate(bitrate: 0)
            self.updateUIWithFPS(fps: 0)
        }
    }

    func stopStreaming() {
        self.streamingManager.stopStreaming(with: { [weak self] (liveId) in
            guard let self = self else { return }
            self.statusLabel.text = "stop"
            self.enableAllInputs(true)
            self.startButton.setTitle("Start", for: .normal)

            self.updateUIWithBitrate(bitrate: 0)
            self.updateUIWithFPS(fps: 0)
        }) { [weak self] (error, liveId) in
            let errorMessage = "Failed to stop streaming with error: \(error), live id=\(String(describing: liveId))"
            self?.onError(with: "Error", errorMessage: errorMessage)
        }
    }

    func updateUIWithBitrate(bitrate: UInt) {
        self.bitrateLabel.text = "\(bitrate/1000) Kbps"
    }

    func updateUIWithFPS(fps: CGFloat) {
        self.fpsLabel.text = "\(fps) fps"
    }

    func updateFlipOutputButtonVisibility() {
        flipOutputButton.isHidden = streamingManager?.captureDevicePosition == .back
    }

    @IBAction private func onFPSValueChanged(_ segment: UISegmentedControl) {
    }

    @IBAction private func onEffectValueChanged(_ segment: UISegmentedControl) {
    }

    @objc
    private func on(_ notification: Notification) {
        guard let orientation = DeviceUtil.videoOrientation(by: UIApplication.shared.statusBarOrientation) else {
            return
        }
//        rtmpStream.orientation = orientation
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if Thread.isMainThread {
            fpsLabel?.text = "\(streamingManager.currentFPS) fps"
        }
    }

    func onError(with title: String, errorMessage: String) {

        func showAlert(with title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "確定", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }

        if !Thread.isMainThread {
            DispatchQueue.main.async {
                showAlert(with: title, message: errorMessage)

                self.statusLabel.text = "error"
                self.enableAllInputs(true)
                self.startButton.setTitle("Start", for: .normal)
            }
        }
    }

    private func enableAllInputs(_ enabled: Bool) {
        startButton.isEnabled = enabled
        streamKeyField.isEnabled = enabled
        streamKeyScanButton.isEnabled = enabled
        titleField.isEnabled = enabled
        streamWayControl.isEnabled = enabled
    }
}

//MARK: UIViewController interface rotation methods

//- (void)hideNavigationControllerIfNecessary {
//    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
//        return;
//    }
//    BOOL isLandscape =
//    UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
//    self.navigationController.navigationBarHidden = isLandscape;
//}
//
//- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
//    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        if (self.isViewLoaded && self.view.window) {
//            [self prepare];
//        } else {
//            self.shouldPrepareAgain = YES;
//        }
//        if (newCollection.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
//            return;
//        }
//        [self hideNavigationControllerIfNecessary];
//    }];
//}

extension STSNewStreamingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleField || textField == streamKeyField {
            view.endEditing(true)
        }

        return false
    }
}

extension STSNewStreamingViewController: STSStreamingManagerDelegate {
    func streamingManager(_: StreamingManager, onError: NSError, liveId: String) {
        let errorTitle = "STSStreamingManager encounters an error."
        let errorMessage = "Error: \(onError.localizedDescription).\nLive id = \(liveId)"
        self.onError(with: errorTitle, errorMessage: errorMessage)
    }

//    - (void)streamingManager:(STSStreamingManager *)streamingManager didUpdateStreamingStatsReport:(STSStreamingStatsReport *)statsReport {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self updateUIWithBitrate:statsReport.currentBitrate];
//            [self updateUIWithFPS:statsReport.currentFPS];
//        });
//    }
}

extension STSNewStreamingViewController: STSQRCodeScannerViewControllerDelegate {
    func scanner(_ scanner: STSQRCodeScannerViewController, didGetQRCode qrCode: String) {
        streamKeyField.text = qrCode
        UserDefaults.standard.set(qrCode, forKey: type(of: self).kUserDefaultsKeyStreamKey)
        self.streamKeyField.text = qrCode;
        dismiss(animated: true, completion: nil)
    }
}

extension STSNewStreamingViewController {
    @objc
    class func viewControllerFromStoryboard() -> STSNewStreamingViewController {
        let storyboard = UIStoryboard(name: "Main",
        bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "STSNewStreamingViewController") as! STSNewStreamingViewController
        return vc
    }
}
