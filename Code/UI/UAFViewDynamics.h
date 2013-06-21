//
//  UAFViewDynamics.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <UIKit/UIKit.h>

#import "UAFViewOptions.h"

typedef NS_ENUM(NSUInteger, UAFPopDirection) {
  UAFPopDirectionIn,
  UAFPopDirectionOut,
  UAFPopDirectionStatic,
};

typedef NS_OPTIONS(NSUInteger, UAFPopOption) {
  UAFPopOptionNone        = 0,
  UAFPopOptionOvershoot   = 1 << 0,
  UAFPopOptionUndershoot  = 1 << 1,
  UAFPopOptionSilent      = 1 << 2,
};

/**
 Lower-level basis for <UAFToggledView>. This is more of a formal than a
 functional separation.
 */
@protocol UAFAnimatedView <NSObject>

@optional

/**
 Is view in the process of animating.
 
 A useful lock to prevent redundant animation.
 */
@property (nonatomic) BOOL isAnimating;

@end

/**
 Expectations for view that can be toggled on and off.
 
 Views using animation macros in <UIView(UAFAdditions_Effects)> should at least
 implement this protocol.
 
 Optional properties allow additional functionality from the animation macros,
 which may be useful in integrating the macros with the rest of the class. 
 */
@protocol UAFToggledView <UAFAnimatedView>

/**
 The only requirement for the animation macros is the duration, since default is
 not provided.
 */
@property (nonatomic) NSTimeInterval toggleTransitionDuration;

@optional

/**
 Is view toggled.
 */
@property (nonatomic) BOOL isToggled;

///------------------------
/// @name Sound Integration
///------------------------

/**
 Name of single sound for both toggling on and off.
 */
@property (strong, nonatomic) NSString *toggleSoundName;
/**
 Only for toggling on.
 */
@property (strong, nonatomic) NSString *toggleOnSoundName;
/**
 Only for toggling off.
 */
@property (strong, nonatomic) NSString *toggleOffSoundName;
/**
 Whether to turn off all sound integration.
 */
@property (nonatomic) BOOL shouldToggleSilently;
/**
 Is there any chance the view is in the process of playing an
 animation-accompanying sound.
 
 A useful lock to prevent redundant sounds.
 */
@property (nonatomic) BOOL isPlayingSound;

///------------------------------------
/// @name Popping Animation Integration
///------------------------------------

/**
 The scale delta for the popping overshoot / undershoot. `0.05f` is 5%.
 
 See `UAFPopOptionOvershoot` and `UAFPopOptionUndershoot`.
 */
@property (nonatomic) CGFloat bounceRatio;
/**
 The smallest scale to animate the view. Default should usually be `0.0f`.
 */
@property (nonatomic) CGFloat minScale;
/**
 The largest scale to animate the view. Default should usually be `1.0f`.
 */
@property (nonatomic) CGFloat maxScale;

@end

/**
 Full-screen view.
 */
@protocol UAFModalView <UAFToggledView>

/**
 Direction the modal should transition _in_.
 */
@property (nonatomic) UAFDirection toggleTransitionDirection;

@end