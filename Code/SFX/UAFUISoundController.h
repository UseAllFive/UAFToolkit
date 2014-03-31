//
//  UAFUISoundController.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

#import "AVPlayerItem+UAFAdditions.h"
#import "UAFObject.h"

extern NSString *const kUAFDidPlayUISoundNotification;

/**
 Simple singleton responsible for loading and playing UI sounds. Acts as an
 abstraction layer for different methods of playing sounds stored in the app's
 bundle. Currently supported approaches:
 
 1. Play through the system-sound layer (`AudioServices`).
 2. Play `AVPlayerItem`s with an `AVPlayer`.
 
 @note Refer to Apple's documentation about advantages and drawbacks for each
 approach.
 @note File-names can also be comma-separated lists for series of sounds, in which
 playing such a name will play a random selection from the list.
 */
@interface UAFUISoundController : NSObject

<UAFObject>
/**
 If system-sound approach should be used.
 */
@property (nonatomic) BOOL shouldPlayAsSystemSounds;
/**
 Ratio of all sounds' volume to the application volume. From `0.0f` to `1.0f`.
 Default is `0.1f`.
 @note This doesn't apply to the system-sound approach.
 */
@property (nonatomic) CGFloat volumeFactor;
/**
 Once file names are set, the sounds go through setup again.
 */
@property (strong, nonatomic, setter = setFileNames:) NSArray *fileNames;
/**
 Convenient constructor.
 @param fileNames File names.
 @return Instance.
 */
- (id)initWithFileNames:(NSArray *)fileNames;
/**
 Shorthand for <playSound:withLoadCompletion:> without a completion.
 @param name Sound file-name constant.
 @return If sound was played.
 */
- (BOOL)playSound:(NSString *)name;
/**
 Plays sound if it exists and isn't not already playing. Will load the sound as
 needed.
 @param name Sound file-name constant.
 @param completion Callback for when sound loads, if applicable.
 @return If sound was played.
 */
- (BOOL)playSound:(NSString *)name withLoadCompletion:(void (^)(void))completion;
/**
 Preload sound if possible. Will not automatically play sound upon loading.
 @param name Sound file-name constant.
 @return If sound was loaded.
 */
- (BOOL)loadSound:(NSString *)name;
/**
 Stop current sound if possible and stops the player from fulfilling subsequent
 play requests.
 */
- (void)stopCurrentSound;

/**
 The singleton.
 */
+ (UAFUISoundController *)sharedController;

@end
