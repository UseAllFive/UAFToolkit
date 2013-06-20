//
//  AVPlayerItem+UAFAdditions.m
//  UAFToolkit
//
//  Created by Peng Wang on 2/21/13.
//  Copyright (c) 2013 UseAllFive. All rights reserved.
//

#import "AVPlayerItem+UAFAdditions.h"

NSString *const kUAFVolumeChangeNotification = @"AVSystemController_SystemVolumeDidChangeNotification";
NSString *const kUAFVolumeNotificationParameter = @"AVSystemController_AudioVolumeNotificationParameter";

@implementation AVPlayerItem (UAFAdditions)

- (NSURL *)url
{
  return [self.asset isKindOfClass:[AVURLAsset class]]
  ? ((AVURLAsset *)self.asset).URL
  : nil;
}

- (void)setVolume:(CGFloat)volume
{
  NSMutableArray *audioParams = [NSMutableArray array];
  for (AVAssetTrack *track in [self.asset tracksWithMediaType:AVMediaTypeAudio]) {
    AVMutableAudioMixInputParameters *inputParams = [AVMutableAudioMixInputParameters audioMixInputParameters];
    [inputParams setVolume:volume atTime:kCMTimeZero];
    inputParams.trackID = track.trackID;
    [audioParams addObject:inputParams];
  }
  AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
  audioMix.inputParameters = audioParams;
  self.audioMix = audioMix;
}

@end
