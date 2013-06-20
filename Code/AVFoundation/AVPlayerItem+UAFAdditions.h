//
//  AVPlayerItem+UAFAdditions.h
//  UAFToolkit
//
//  Created by Peng Wang on 2/21/13.
//  Copyright (c) 2013 UseAllFive. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

extern NSString *const kUAFVolumeChangeNotification;
extern NSString *const kUAFVolumeNotificationParameter;

/**
 Provides extensions to `AVPlayerItem` for various common tasks.
 */
@interface AVPlayerItem (UAFAdditions)

/**
 Shorthand for `self.asset.URL` if `asset` is of `AVURLAsset`.
 @return URL or nil.
 */
- (NSURL *)url;
/**
 Abstracts away procedure for changing volume on the player item through
 `audioMix` and setting volume on each track in `asset` through
 `AudioMixInputParameters`.
 @param volume From `0.0f` to `1.0f`.
 */
- (void)setVolume:(CGFloat)volume;

@end
