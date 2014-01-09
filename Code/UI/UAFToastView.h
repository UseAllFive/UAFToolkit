//
//  UAFToastView.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/21/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "UAFView.h"
#import "UAFViewDynamics.h"
#import "UIView+UAFAdditions_Effects.h"

#import "UAFDebugUtilities.h"
#import "UAFDrawingUtilities.h"

/**
 Custom alert view. Designed as a singleton for performance from reuse.
 
 Example:
 
 UAFToastView *toast = [UAFToastView sharedView];
 toast.titleText = NSLocalizedString(@"Operation failed! Please go back and retry.", nil);
 toast.positionDirection = UAFDirectionUp;
 toast.titleLabel.textColor = [UIColor whiteColor]; //-- Update each time, since toast is shared.
 [toast toggleToVisible:YES relativeToView:self.view];
 
 @note As a singleton that's shared across views and view-controllers, the toast
 needs to be reconfigured for each toggle.
 @note Toggles using <[UIView(UAFAdditions_Effects)
 toggleView:toPopInDirection:withOptions:completion:andConfiguration:]>. By
 default has `minScale` at `0.9f`.
 */
@interface UAFToastView : UAFView

<UAFToggledView>

/// --------------------------
/// @name Common Configuration
/// --------------------------

/**
 A proxy to the <titleLabel>'s `text`. Setting this will re-layout the label.
 @see shouldLockTextWhenVisible
 @note Key-value observed.
 */
@property (strong, nonatomic, setter = setTitleText:) NSString *titleText;
/**
 The direction the toast should be snapping to, while taking <edgeOffset> into
 account. Default is `UAFDirectionDown`.
 */
@property (nonatomic) UAFDirection positionDirection;

/// --------------------------
/// @name Other Configuration
/// --------------------------

/**
 The delay in seconds before auto-dismissal, if applicable. Default is `1.0f`.
 */
@property (nonatomic) NSTimeInterval autoDismissDuration;
/**
 The spacing from the edge of the <screenView> when snapping to that edge via
 <positionDirection>. Default is `17.0f` for iPhone and `44.0f` for iPad.
 */
@property (nonatomic) CGFloat edgeOffset;
/**
 Spacing between toast and <titleLabel>. Default is `10.0f`.
 */
@property (nonatomic) CGFloat padding;
/**
 Toggle auto-dismissal. `YES` by default.
 
 For manual dismissal, just call the toggle methods with visible set to `NO`.
 */
@property (nonatomic) BOOL shouldAutoDismiss;
/**
 Prevent <titleLabel> text from changing when it's visible. `YES` by default.
 */
@property (nonatomic) BOOL shouldLockTextWhenVisible;
/**
 Callback.
 */
@property (nonatomic, copy) void (^dismissalBlock)(void);

/// -----------------------------
/// @name Other Public Properties
/// -----------------------------

/**
 Reference to the 'screen' view, the view the toast is displayed in relation to.
 Mainly used internally for layout.
 */
@property (weak, nonatomic) UIView *screenView;
/**
 The title label, if further customization is desired.
 
 @note By default, style is bold, uppercase font of size `12.0f` / `16.0f`
 (iPhone / iPad), with black text and transparent background.
 */
@property (strong, nonatomic, readonly) UILabel *titleLabel;

/// --------------
/// @name Toggling
/// --------------

/**
 Shorthand for `[self toggleToVisible:visible relativeToView:view withDelay:0.0f];`.
 @param visible See wrapped method.
 @param view See wrapped method.
 @return See wrapped method.
 */
- (BOOL)toggleToVisible:(BOOL)visible relativeToView:(UIView *)view;
/**
 Toggles toast to pop and fade.
 @param visible Pop out and fade in if `YES`, then vice versa if
 <shouldAutoDismiss>, and vice versa if `NO`.
 @param view New <screenView> that's stored and used during layout, or purged.
 @param delay Custom delay; `standardPresentDelay` is suggested if needed.
 @return Operation success.
 @note Will not show if no <titleText>.
 @note Options will be reset as needed.
 */
- (BOOL)toggleToVisible:(BOOL)visible relativeToView:(UIView *)view withDelay:(NSTimeInterval)delay;

/// --------------------------
/// @name Other Public Methods
/// --------------------------

/**
 The singleton.
 */
+ (UAFToastView *)sharedView;
/**
 Suggested delay for presenting a toast. Not used internally.
 */
+ (NSTimeInterval)standardPresentDelay;

@end