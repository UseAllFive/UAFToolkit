//
//  UAFUISoundController.m
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import "UAFUISoundController.h"

#import "UAFDebugUtilities.h"

NSString *const kUAFDidPlayUISoundNotification = @"Played UI Sound";

typedef void (^SoundLoadedBlock)(void);

static void *observationContext = &observationContext;

static NSArray *keyPathsToObserve;

static UAFUISoundController *controller;

@interface UAFUISoundController ()

/**
 Sound file-objects (individuals or series) indexed by file-name constants. For
 internal use only.
 
 File-objects can be of type `@( SystemSoundID )` and `AVPlayerItem`.
 @note This collection is not homogeneous, use <soundFileObjectForFileName:>
 instead to getting a sound file-object.
 */
@property (strong, nonatomic) NSDictionary *sounds;
/**
 Track the current sound file. Used maybe for debugging for now.
 */
@property (strong, nonatomic) NSString *currentSoundFileName;
/**
 The internal player instance for the AVPlayer approach. Initialized only as
 needed.
 @note We're not just creating a bunch of AVPlayer instances since memory
 shouldn't keep all audio at once. Plus, there's a limit on the number of
 instances.
 */
@property (strong, nonatomic) AVPlayer *player;
/**
 Callback for when current sound has loaded.
 */
@property (copy, nonatomic) SoundLoadedBlock loadCompletion;
/**
 Tracks controller state to prevent interrupting.
 */
@property (nonatomic) BOOL isPlaying;
/**
 Internal hook for logic after playing starts.
 */
- (void)didPlaySound;
/**
 Internal
 @param fileName Sound file-name constant.
 */
- (id)soundFileObjectForFileName:(NSString *)fileName;
/**
 Factory for sound file-objects.
 
 For the `AVPlayer` approach, additional integration is done with <volumeFactor>
 and observing the `status` changes on the `AVPlayerItem` file-object.
 @param fileName Sound file-name constant.
 */
- (id)newSoundFileObjectForFileName:(NSString *)fileName;
/**
 Populates <sounds>.
 */
- (void)setupSounds;
/**
 Frees up <sounds>.
 */
- (void)teardownSounds;
/**
 Factory sub-routine for system-sound file-objects.
 @param fileName Sound file-name constant.
 */
+ (id)newSystemSoundFileObjectForFileName:(NSString *)fileName;

@end

@implementation UAFUISoundController

@synthesize shouldDebug;

- (id)init
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
    keyPathsToObserve = @[ @"fileNames" ];
  });
  self.shouldDebug = YES;
  self = [super init];
  if (self) {
    if (!self.shouldPlayAsSystemSounds) {
      self.player = [AVPlayer new];
      self.volumeFactor = 0.1f;
    }
    for (NSString *keyPath in keyPathsToObserve) {
      [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
  }
  return self;
}
- (id)initWithFileNames:(NSArray *)fileNames
{
  self = [self init];
  if (self) {
    self.fileNames = fileNames;
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kUAFVolumeChangeNotification object:nil];
  [self teardownSounds];
  for (NSString *keyPath in keyPathsToObserve) {
    [self removeObserver:self forKeyPath:keyPath];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  id value = change[NSKeyValueChangeNewKey];
  id previousValue = change[NSKeyValueChangeOldKey];
  if ([object isKindOfClass:[AVPlayerItem class]] && context == observationContext) {
    if ([keyPath isEqualToString:@"status"]) {
      if ([value unsignedIntegerValue] != AVPlayerItemStatusReadyToPlay) {
        return nil;
      }
      if (self.loadCompletion) {
        dispatch_async(dispatch_get_main_queue(), self.loadCompletion);
      }
      [self.player play];
      [self didPlaySound];
      self.isPlaying = NO;
    }
  } else if (object == self) {
    if ([keyPath isEqualToString:@"fileNames"] && ![value isEqual:previousValue]) {
      [self setupSounds];
    }
  }
}

#pragma mark - Singleton

+ (void)initialize
{
  static BOOL initialized = NO;
  if (!initialized) {
    initialized = YES;
    controller = [UAFUISoundController new];
  }
}

+ (UAFUISoundController *)sharedController
{
  return controller;
}

#pragma mark - Public

- (BOOL)playSound:(NSString *)name withLoadCompletion:(void (^)(void))completion
{
  id soundFileObject = [self soundFileObjectForFileName:name];
  if (!soundFileObject && self.isPlaying) {
    if (self.shouldDebug) DLog(@"Guarded.");
    return NO;
  }
  self.currentSoundFileName = name;
  if (self.shouldPlayAsSystemSounds) {
    if (completion) {
      dispatch_async(dispatch_get_main_queue(), completion);
    }
    AudioServicesPlaySystemSound((SystemSoundID)[soundFileObject integerValue]);
    [self didPlaySound];
  } else {
    //-- Setup and cleanup.
    self.loadCompletion = completion;
    if (self.player.currentItem) {
      [self.player.currentItem seekToTime:kCMTimeZero]; //-- Restore current sound.
    }
    //-- Play, but load as needed.
    if (self.player.currentItem == soundFileObject) {
      if (completion) {
        dispatch_async(dispatch_get_main_queue(), completion);
      }
      [self.player play];
      [self didPlaySound];
    } else {
      self.isPlaying = YES;
      [self.player replaceCurrentItemWithPlayerItem:soundFileObject];
    }
  }
  return YES;
}
- (BOOL)playSound:(NSString *)name
{
  return [self playSound:name withLoadCompletion:nil];
}

#pragma mark - Private

- (void)didPlaySound
{
  if (self.shouldDebug) DLog(@"Playing: %@", self.currentSoundFileName);
  [[NSNotificationCenter defaultCenter] postNotificationName:kUAFDidPlayUISoundNotification object:self];
}

- (id)soundFileObjectForFileName:(NSString *)fileName
{
  id soundFileObject = self.sounds[fileName]; //-- File name.
  //-- Handle sound series.
  if ([soundFileObject isKindOfClass:[NSArray class]]) {
    NSArray *soundFileObjects = (NSArray *)soundFileObject;
    NSInteger randomIndex = arc4random() % soundFileObjects.count;
    soundFileObject = soundFileObjects[randomIndex];
  }
  return soundFileObject;
}

- (id)newSoundFileObjectForFileName:(NSString *)fileName
{
  id soundFileObject = nil;
  if (self.shouldPlayAsSystemSounds) {
    soundFileObject = [self.class newSystemSoundFileObjectForFileName:fileName];
  } else {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    if (self.shouldDebug) DLog(@"File path: %@", path);
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];
    [item setVolume:self.volumeFactor];
    [item addObserver:self
           forKeyPath:@"status"
              options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
              context:observationContext];
    soundFileObject = item;
  }
  return soundFileObject;
}

- (void)setupSounds
{
  if (self.sounds) {
    [self teardownSounds];
  }
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  for (NSString *fileNameString in self.fileNames) {
    NSArray *possibleFileNames = [fileNameString componentsSeparatedByString:@","];
    if (possibleFileNames.count > 1) {
      //-- Handle sound series.
      NSMutableArray *soundFileObjects = [NSMutableArray array];
      for (NSString *fileName in possibleFileNames) {
        [soundFileObjects addObject:[self newSoundFileObjectForFileName:fileName]];
      }
      dict[fileNameString] = soundFileObjects;
    } else {
      dict[fileNameString] = [self newSoundFileObjectForFileName:fileNameString];
    }
  }
  self.sounds = dict;  
}

- (void)teardownSounds
{
  if (!self.shouldPlayAsSystemSounds) {
    [self.sounds enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
      [obj removeObserver:self forKeyPath:@"status" context:observationContext];
    }];
  }
  self.sounds = nil;
}

+ (id)newSystemSoundFileObjectForFileName:(NSString *)fileName
{
  CFURLRef soundFileURLRef =
  CFBundleCopyResourceURL(CFBundleGetMainBundle(),
                          (__bridge CFStringRef)fileName.stringByDeletingPathExtension,
                          (__bridge CFStringRef)fileName.pathExtension,
                          NULL);
  SystemSoundID soundFileObject;
  AudioServicesCreateSystemSoundID(soundFileURLRef, &soundFileObject);
  id obj = (id)@( soundFileObject );
  CFRelease(soundFileURLRef);
  return obj;
}

@end
