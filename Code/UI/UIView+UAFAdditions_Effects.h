//
//  UIView+UAFAdditions_Effects.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "UAFViewDynamics.h"
#import "UIView+UAFAdditions.h"

#import "UAFDebugUtilities.h"
#import "UAFDispatchUtilities.h"
#import "UAFDrawingUtilities.h"

/**
 Shared UIView aspects for animated effects. This category is based on the
 philosophy of mixins over inheritance. Since Objective-C categories are limited
 and properties are banned, views must implement protocols and their properties
 as needed. Also, the methods added are follow the convention that app-specific
 behaviors such as custom styles and transitions show be added as static members
 of the related core class, in this case, `UIView`.
 
 See:
 
 - <UAFToggledView>
 - <UAFModalView>
 
 @note Most of the animation macros current don't take completion blocks. Partly
 this is to prevent overnesting callbacks. To synchronize with the animations,
 just dispatch your own blocks with the respective <[UAFToggledView
 toggleTransitionDuration]>.
 
 @note Notification of unfinished animations is not handled.
 */
@interface UIView (UAFAdditions_Effects)

/**
 Slides in or out the view based on the set direction by animating the frame.
 
 Supports:
 
 - <[UAFToggledView isToggled]>
 - <[UAFAnimatedView isAnimating]>
 - <[UAFModalView toggleTransitionDirection]> - If not set, the default
 direction is `UAFDirectionUp`.
 @param view View that implements <UAFModalView>.
 @param visible Visible.
 @param animated Animated. `NO` makes transition immediate.
 @see UAFModalView
 @note Actually modifies `hidden`.
 */
+ (void)toggleModalView:(UIView<UAFModalView> *)view toVisible:(BOOL)visible
               animated:(BOOL)animated;
/**
 Horizontally reveals a view by animating a `CAGradientLayer` mask.
 
 Creates the mask layer if it doesn't exist. This method can be enhanced as
 needed to support all directions. Animations are done via `CATransaction`.
 Supports:
 
 - <[UAFToggledView isToggled]>
 - <[UAFAnimatedView isAnimating]>
 @param view The view. Does not have to implement <UAFToggledView>; this allows
 some flexibility in what view can be masked (i.e. a subview).
 @param superview The containing view, if `view` implements <UAFToggledView>,
 then this param is optional, otherwise, this param must implement
 <UAFToggledView>.
 @param revealed Revealed.
 @param animated Animated. `NO` makes transition immediate.
 */
+ (void)toggleMaskedView:(UIView *)view withSuperview:(UIView *)superview
              toRevealed:(BOOL)revealed animated:(BOOL)animated;

/**
 Flexible macro for 'popping' animations. It is designed to be to definitive
 macro for any popping-related animation.
 
 Supports:
 
 - <[UAFAnimatedView isAnimating]>
 - <[UAFToggledView isPlayingSound]>
 - <[UAFToggledView toggleSoundName]> and co - use `UAFPopOptionSilent` to block
 sounds. This is useful if the sounds are meant for another macro.
 
 @note The scale effects of overshoot and undershoot depends on direction. For
 popping-out (expanding), overshoot means adding to the end scale, whereas for
 popping-in, it means subtracting from the end scale.
 
 @note This method doesn't check for all possible cases of input, so it's your
 responsibility to provide the correct input or it will fail. No exceptions are
 provided.
 
 @note Currently <[UAFToggledView maxScale]> isn't supported.
 
 @param view Either appropriately conforms to <UAFToggledView> or is
 supplemented by options provided in `config`.
 @param direction Supports `UAFPopDirectionIn`, `UAFPopDirectionOut`,
 `UAFPopDirectionStatic`. When direction is static, `UAFPopOptionOvershoot`
 and/or `UAFPopOptionUndershoot` are expected. `UAFPopDirectionStatic` means
 just the 'reverb' gets animated and there's no popping in or out.
 @param options Supports `UAFPopOptionOvershoot` and/or
 `UAFPopOptionUndershoot`.
 @param completion Since this method is designed to simplify the caller's logic,
 callback support is provided.
 @param config Dictionary of data that would otherwise from implementing
 <UAFToggledView>, with the exception of some method-specific config, making
 this somewhat of an 'options bag'. This is mostly for non-custom views.
 Property names:
 
 - `Bounce-Ratio`
 - `Sound-Name`
 - `Duration`
 - `Delay` - Option. Default is none.
 */
+ (void)toggleView:(UIView *)view toPopInDirection:(UAFPopDirection)direction
       withOptions:(UAFPopOption)options completion:(void (^)(void))completion
  andConfiguration:(NSDictionary *)config;

///------------------------
/// @name Sound Integration
///------------------------

/**
 Gets name for UI sound; the animation macro decides how to play the sound. If
 <[UAFToggledView toggleSoundName]> doesn't exist, both <[UAFToggledView
 toggleOnSoundName]> and <[UAFToggledView toggleOffSoundName]> must exist for
 sound to be played.
 @param view View that implements <UAFToggledView>.
 @param toggled Toggled.
 @return Sound name if any exist, or nil depending on <[UAFToggledView
 shouldToggleSilently]>.
 */
+ (NSString *)soundNameForToggledView:(UIView<UAFToggledView> *)view andState:(BOOL)toggled;

@end
