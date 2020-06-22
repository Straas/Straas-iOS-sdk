//
//  STSNewStreamingViewController.swift
//  StraaS
//
//  Created by allen.lin on 2020/3/18.
//  Copyright © 2020年 StraaS.io. All rights reserved.
//

import AVFoundation
import HaishinKit_Straas
import Photos
import UIKit
import VideoToolbox
import StraaSStreamingSDK

final class STSNewStreamingViewController: UIViewController {

    // MARK: - Constants
    private static let kUserDefaultsKeyStreamKey = "kUserDefaultsKeyStreamKey"

    // MARK: - Outlets
    @IBOutlet private weak var titleField: UITextField!
    @IBOutlet private weak var streamKeyField: UITextField!
    @IBOutlet private weak var streamKeyScanButton: UIButton!
    @IBOutlet private weak var streamWaySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var flipOutputButton: UIButton!
    @IBOutlet private weak var audioButton: UIButton!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var bitrateLabel: UILabel!
    @IBOutlet private weak var fpsLabel: UILabel!
    @IBOutlet private weak var previewView: MTHKView?
    @IBOutlet private weak var settingView: UIView!
    @IBOutlet private weak var streamKeySettingView: UIView!

    // MARK: - Private
//    var filterType: STSStreamingFilterType!

    enum StreamWay: Int {
        case streamKey
        case title
    }

    @objc private var streamingManager: StreamingManager!

    private var memberJWT: String {
        return kStraaSProdMemberJWT;
    }

    deinit {
        observeration = nil
    }
    // MARK: - View Controller Life Cycle

    //REVIEWED
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //CODING
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        rtmpStream.close()
//        rtmpStream.dispose()
    }

    // REVIEWED
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []

        settingView.isHidden = true
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

        do { // cache streamKey so it does not need to be entered the next time
            let cachedStreamKey = UserDefaults.standard.string(forKey: type(of: self).kUserDefaultsKeyStreamKey)
            streamKeyField.text = cachedStreamKey
        }
    }

    //REVIEWED
    private var observeration: NSKeyValueObservation?

    //REVIEWED
    private func prepare() {

        do { //setupStreamingManager()
            self.streamingManager = StreamingManager.getInstance(with: self.memberJWT)
            self.observeration = streamingManager.observe(\.state, options:  [.new, .old], changeHandler: { (player, change) in
                DispatchQueue.main.async {
                    switch self.streamingManager.state {
                        case .streaming:
                            UIApplication.shared.isIdleTimerDisabled = true
                        case .prepared:
                            UIApplication.shared.isIdleTimerDisabled = false
                        default:
                            break
                    }
                }
            })

            streamingManager.delegate = self
            updateFlipOutputButtonVisibility()
            //TODO: filter
//                self.filterType = STSStreamingFilterTypeNone;
//                [self updateFilter:self.filterType];
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

    //REVIEWED
    func shouldAutorotate() -> Bool {
        if streamingManager?.state == .connecting
            || streamingManager?.state == .streaming
            || streamingManager?.state == .disconnecting {
            return false
        }

        return true
    }

    //MARK: - IBActions
    //REVIEWED
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        guard let streamingManager = self.streamingManager else {
            return
        }

        streamingManager.captureDevicePosition = (streamingManager.captureDevicePosition == .back) ? .front : .back

        updateFlipOutputButtonVisibility()
        updateMirrorButton()
    }

    //REVIEWED
    @IBAction func startButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        guard let streamingManager = streamingManager else {
            return
        }

        if streamingManager.state == .prepared {
            statusLabel.text = "connecting"
            enableAllInputs(false)
            if streamWaySegmentedControl.selectedSegmentIndex == StreamWay.streamKey.rawValue,
                let streamKey = streamKeyField.text {
                startStreamingWithStreamKey(streamKey)
            } else if streamWaySegmentedControl.selectedSegmentIndex == StreamWay.title.rawValue,
                let title = titleField.text {
                startStreamingWithTitle(title)
            }
        } else if streamingManager.state == .streaming {
            statusLabel.text = "disconnecting"
            startButton.isEnabled = false
            stopStreaming()
        }
    }

    //REVIEWED
    @IBAction func flipOutputButtonPressed(_ sender: UIButton) {
        guard self.streamingManager.captureDevicePosition == .front else {
            return
        }

        self.streamingManager.isFlipFrontCameraOutputHorizontal = !self.streamingManager.isFlipFrontCameraOutputHorizontal
        updateMirrorButton()
    }

    //REVIEWED
    private func updateMirrorButton() {
        guard let streamingManager = self.streamingManager else {
            flipOutputButton.setTitleColor(UIColor.systemBlue, for: .normal)
            return
        }

        if streamingManager.isFlipFrontCameraOutputHorizontal {
            flipOutputButton.setTitleColor(UIColor.systemBlue, for: .normal)
        } else {
            flipOutputButton.setTitleColor(UIColor.white, for: .normal)
        }
    }

    //REVIEWED
    @IBAction private func streamWaySegmentedControlValueChanged(_ segment: UISegmentedControl) {
        titleField.isHidden = !(streamWaySegmentedControl.selectedSegmentIndex == StreamWay.title.rawValue)
        streamKeySettingView.isHidden = !(streamWaySegmentedControl.selectedSegmentIndex == StreamWay.streamKey.rawValue)
        view.endEditing(true)
    }

    //REVIEWED
    @IBAction private func streamKeyScanButtonPressed(_ sender: UIButton) {
        let vc = STSQRCodeScannerViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    //REVIEWED
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

    //MARK: - private methods
    //REVIEWED
    private func startStreamingWithTitle(_ title: String) {
        let trimmedTitle = title.trimmingCharacters(in: CharacterSet.whitespaces)
        if trimmedTitle.count == 0 {
            onError(with: "Error", errorMessage: "The title should not be empty.")
            return
        }

        guard let streamingManager = streamingManager else {
            return
        }

        let configuration = STSStreamingLiveEventConfig(title: trimmedTitle, listed: true)
        streamingManager.createLiveEvent(with: configuration, success: { [weak self] (liveId) in
            self?.startStreamingWithLiveId(liveId)
        }) { [weak self] (error, liveId) in
            if error.domain == STSStreamingErrorDomain && error.code == STSStreamingErrorCode.errorCodeLiveCountLimit.rawValue {
                print("Current member has an unended live event, try to start streaming by reusing that event. liveId = \(String(describing: liveId))")
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

    //REVIEWED
    private func startStreamingWithLiveId(_ liveId: String) {
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

    //REVIEWED
    private func endLiveEvent(liveId: String, success:@escaping () -> Void, failure:@escaping (_ error: NSError) -> Void) {
        guard let streamingManager = self.streamingManager else {
            return
        }

        streamingManager.endLiveEvent(with: liveId, success: { (liveId) in
            success()
        }) { (error) in
            failure(error)
        }
    }

    //REVIEWED
    private func startStreamingWithStreamKey(_ streamKey: String) {
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
            let errorMessage = "Error: \(error)"
            self?.onError(with: errorTitle, errorMessage: errorMessage)
        })
    }

    //REVIEWED
    private func didStartStreaming() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.statusLabel.text = "start"
            self.startButton.isEnabled = true
            self.startButton.setTitle("Stop", for: .normal)

            self.updateUIWithBitrate(bitrate: 0)
            self.updateUIWithFPS(fps: 0)
        }
    }

    //REVIEWED
    private func stopStreaming() {
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

    //REVIEWED
    private func updateUIWithBitrate(bitrate: UInt) {
        self.bitrateLabel.text = "\(bitrate/1000) Kbps"
    }

    //REVIEWED
    private func updateUIWithFPS(fps: CGFloat) {
        self.fpsLabel.text = "\(fps) fps"
    }

    //REVIEWED
    private func updateFlipOutputButtonVisibility() {
        flipOutputButton.isHidden = streamingManager?.captureDevicePosition == .back
    }

    //REVIEWED
    private func onError(with title: String, errorMessage: String) {

        func showAlert(with title: String, message: String) {
            self.statusLabel.text = "error"
            self.enableAllInputs(true)
            self.startButton.setTitle("Start", for: .normal)

            self.updateUIWithBitrate(bitrate: 0)
            self.updateUIWithFPS(fps: 0.0)

            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "確定", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }

        DispatchQueue.main.async {
            showAlert(with: title, message: errorMessage)
        }
    }

    //REVIEWED
    private func enableAllInputs(_ enabled: Bool) {
        startButton.isEnabled = enabled
        streamKeyField.isEnabled = enabled
        streamKeyScanButton.isEnabled = enabled
        titleField.isEnabled = enabled
        streamWaySegmentedControl.isEnabled = enabled
    }
}

//MARK: - UITextFieldDelegate
//REVIEWED
extension STSNewStreamingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleField || textField == streamKeyField {
            view.endEditing(true)
        }

        return false
    }
}

//MARK: - STSStreamingManagerDelegate
//REVIEWED
extension STSNewStreamingViewController: STSStreamingManagerDelegate {
    func streamingManager(_: StreamingManager, onError: NSError, liveId: String) {
        let errorTitle = "STSStreamingManager encounters an error."
        let errorMessage = "Error: \(onError.localizedDescription).\nLive id = \(liveId)"
        self.onError(with: errorTitle, errorMessage: errorMessage)
    }

    func streamingManager(_: StreamingManager, didUpdate statsReport: STSStreamingStatsReport) {
        DispatchQueue.main.async {
            self.updateUIWithBitrate(bitrate: statsReport.currentBitrate)
            self.updateUIWithFPS(fps: statsReport.currentFPS)
        }
    }
}

//MARK: - STSQRCodeScannerViewControllerDelegate
//REVIEWED
extension STSNewStreamingViewController: STSQRCodeScannerViewControllerDelegate {
    func scanner(_ scanner: STSQRCodeScannerViewController, didGetQRCode qrCode: String) {
        streamKeyField.text = qrCode
        UserDefaults.standard.set(qrCode, forKey: type(of: self).kUserDefaultsKeyStreamKey)
        self.streamKeyField.text = qrCode;
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - viewControllerFromStoryboard
//REVIEWED
extension STSNewStreamingViewController {
    @objc
    class func viewControllerFromStoryboard() -> STSNewStreamingViewController {
        let storyboard = UIStoryboard(name: "Main",
        bundle: nil)
        let vc =  storyboard.instantiateViewController(withIdentifier: "STSNewStreamingViewController") as! STSNewStreamingViewController
        return vc
    }
}
