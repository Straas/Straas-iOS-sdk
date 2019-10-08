//
//  STSAudioConfiguration.h
//  StraaS
//
//  Created by Harry on 17/07/2017.
//  Copyright © 2017 StraaS.io. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Indicates ReplayKit's microphone audio channel.
 */
extern NSString * const kSTSReplayKitAudioChannelMic;

/**
 * Indicates ReplayKit's application audio channel.
 */
extern NSString * const kSTSReplayKitAudioChannelApp;

/**
 * Constants specifying the audio sample rate.
 */
typedef NS_ENUM(NSInteger, STSAudioSampleRate) {
    
    /**
     * Indicates the sample rate of 16000 Hz.
     */
    STSAudioSampleRate_16000Hz = 16000,
    
    /**
     * Indicates the sample rate of 44100 Hz.
     */
    STSAudioSampleRate_44100Hz = 44100,
    
    /**
     * Indicates the sample rate of 48000 Hz.
     */
    STSAudioSampleRate_48000Hz = 48000
};

/**
 * A STSAudioConfiguration object defines the audio configuration of a STSLiveStreamer object.
 */
@interface STSAudioConfiguration : NSObject

/**
 * The output audio sample rate. Defaults to STSAudioSampleRate_44100Hz. See STSAudioSampleRate for details.
 */
@property (nonatomic) STSAudioSampleRate sampleRate;

/**
 * The number of output channels. Defaults to 1. Set the value to 1 for mono and 2 for stereo.
 */
@property (nonatomic) NSUInteger numOfChannels;

/**
 * The input ReplayKit audio channels. Defaults to nil.
 */
@property (nonatomic, copy) NSArray<NSString *> * replayKitAudioChannels;

/**
 * The volume of kSTSReplayKitAudioChannelMic channel. The property will be used only when the elements of replayKitAudioChannels contain both kSTSReplayKitAudioChannelMic and kSTSReplayKitAudioChannelApp. The value must be between 0.0 and 1.0. By default, the value is set to 0.8.
 */
@property (nonatomic) float replayKitMicChannelVolume;

/**
 * The volume of kSTSReplayKitAudioChannelApp channel. The property will be used only when the elements of replayKitAudioChannels contain both kSTSReplayKitAudioChannelMic and kSTSReplayKitAudioChannelApp. The value must be between 0.0 and 1.0. By default, the value is set to 0.8.
 */
@property (nonatomic) float replayKitAppChannelVolume;

@end
