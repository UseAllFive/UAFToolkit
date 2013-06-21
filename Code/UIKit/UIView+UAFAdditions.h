//
//  UIView+UAFAdditions.h
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012-2013UseAllFive. See license.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "UIScreen+UAFAdditions.h"

#define kUAFFadeDuration 0.2f //-- Pre-defining to avoid re-defining issue.

/**
 Provides extensions to `UIView` for various common tasks.
 
 Rips parts of `Three20UI/UIViewAdditions`.
 
 @note If SSDrawingUtilities is available, it provides similar features, but as
 functions.
 
 @note Relative position accessors prepend the regular position accessors with
 `rel`. They use `bounds.origin` instead of `frame.origin`.

 */
@interface UIView (UAFAdditions)

///----------------------------------
/// @name Absolute Position Accessors
///----------------------------------

/**
 Shortcut for `frame.origin.x`.
 Sets `frame.origin.x = left`.
 */
@property (nonatomic) CGFloat left;
/**
 Shortcut for `frame.origin.y`.
 Sets `frame.origin.y = top`.
 */
@property (nonatomic) CGFloat top;
/**
 Shortcut for `frame.origin.x + frame.size.width`.
 Sets `frame.origin.x = right - frame.size.width`.
 */
@property (nonatomic) CGFloat right;
/**
 Shortcut for `frame.origin.y + frame.size.height`.
 Sets `frame.origin.y = bottom - frame.size.height`.
 */
@property (nonatomic) CGFloat bottom;
/**
 Shortcut for `center.x`.
 Sets `center.x = centerX`.
 */
@property (nonatomic) CGFloat centerX;
/**
 Shortcut for `center.y`.
 Sets `center.y = centerY`.
 */
@property (nonatomic) CGFloat centerY;
/**
 Shortcut for `frame.origin`.
 Sets `frame.origin = origin`.
 */
@property (nonatomic) CGPoint origin;

///----------------------------------
/// @name Relative Position Accessors
///----------------------------------

/**
 Shortcut for `bounds.origin.x`.
 Sets `bounds.origin.x = x`.
 */
@property (nonatomic) CGFloat relLeft;
/**
 Shortcut for `bounds.origin.y`.
 Sets `bounds.origin.y = y`.
 */
@property (nonatomic) CGFloat relTop;
/**
 Shortcut for `bounds.origin.x + bounds.size.width`.
 Sets `bounds.origin.x = right - bounds.size.width`.
 */
@property (nonatomic) CGFloat relRight;
/**
 Shortcut for `bounds.origin.y + bounds.size.height`.
 Sets `bounds.origin.y = bottom - bounds.size.height`.
 */
@property (nonatomic) CGFloat relBottom;
/**
 Shortcut for `center.x - frame.origin.x + bounds.origin.x`.
 Sets `center.x = relCenterX + frame.origin.x - bounds.origin.x`.
 @note Experimental.
 */
@property (nonatomic) CGFloat relCenterX;
/**
 Shortcut for `center.y - frame.origin.y + bounds.origin.y`.
 Sets `center.y = relCenterY + frame.origin.y - bounds.origin.y`.
 @note Experimental.
 */
@property (nonatomic) CGFloat relCenterY;
/**
 Shortcut for `bounds.origin`.
 Sets `bounds.origin = origin`.
 */
@property (nonatomic) CGPoint relOrigin;

///---------------------
/// @name Size Accessors
///---------------------

/**
 Shortcut for `frame.size.width`.
 Sets `frame.size.width = width`.
 */
@property (nonatomic) CGFloat width;

/**
 Shortcut for `frame.size.height`.
 Sets `frame.size.height = height`.
 */
@property (nonatomic) CGFloat height;

/**
 Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

///--------------
/// @name Helpers
///--------------

/**
 Removes all subviews.
 */
- (void)removeAllSubviews;
/**
 Get first subview by class. For managing simple views.
 @param subviewClass Description.
 */
- (UIView *)firstSubviewOfClass:(Class)subviewClass;
/**
 Kludge to help deal with view centers that don't update with the interface orientation.
 */
- (CGPoint)realCenter;
/**
 Kludge to help deal with frames that don't update with the interface orientation.
 @param rect A `CGRect`.
 */
+ (CGRect)flipRect:(CGRect)rect;

///-------------------------
/// @name Taking Screenshots
///-------------------------

/**
 Takes a screenshot of the underlying `CALayer` of the receiver and returns a
 `UIImage` object representation.
 
 @return An image representing the receiver
 */
- (UIImage *)imageRepresentation;

///-------------------------
/// @name Hiding and Showing
///-------------------------

/**
 Sets the `alpha` value of the receiver to `0.0`, updates `hidden`.
 */
- (void)hide;

/**
 Sets the `alpha` value of the receiver to `1.0`, updates `hidden`.
 */
- (void)show;

/**
 Just toggles the `alpha`. Shows and hides 'softly'.
 @param isVisible Is visible.
 */
- (void)setIsVisible:(BOOL)isVisible;

/**
 View is 'on screen' if it has a reference to its `window`.
 @return Test results.
 */
- (BOOL)isOnScreen;

///------------------------
/// @name Fading In and Out
///------------------------

/**
 Fade out the receiver as needed, in `kUAFFadeDuration`.
 */
- (void)fadeOut;
/**
 Fade out the receiver as needed, in `kUAFFadeDuration`.
 @param completion Callback.
 */
- (void)fadeOutWithCompletion:(void (^)(void))completion;
/**
 Fade out the receiver as needed, in `kUAFFadeDuration`.
 @param toAlpha Target alpha.
 */
- (void)fadeOutTo:(CGFloat)toAlpha;
/**
 Fade out the receiver as needed, in `kUAFFadeDuration`.
 @param toAlpha Target alpha.
 @param completion Callback.
 */
- (void)fadeOutTo:(CGFloat)toAlpha withCompletion:(void (^)(void))completion;
/**
 Fade out the receiver as needed, in `kUAFFadeDuration`.
 @param toAlpha Target alpha.
 @param delay Seconds of delay.
 @param completion Callback.
 */
- (void)fadeOutTo:(CGFloat)toAlpha withDelay:(NSTimeInterval)delay andCompletion:(void (^)(void))completion;

/**
 Fade out the receiver as needed and remove from its super view, in `kUAFFadeDuration`.
 */
- (void)fadeOutAndRemoveFromSuperview;

/**
 Fade in the receiver as needed, in `kUAFFadeDuration`.
 */
- (void)fadeIn;
/**
 Fade in the receiver as needed, in `kUAFFadeDuration`.
 @param completion Callback.
 */
- (void)fadeInWithCompletion:(void (^)(void))completion;
/**
 Fade in the receiver as needed, in `kUAFFadeDuration`.
 @param toAlpha Target alpha.
 */
- (void)fadeInTo:(CGFloat)toAlpha;
/**
 Fade in the receiver as needed, in `kUAFFadeDuration`.
 @param toAlpha Target alpha.
 @param completion Callback.
 */
- (void)fadeInTo:(CGFloat)toAlpha withCompletion:(void (^)(void))completion;
/**
 Fade in the receiver as needed, in `kUAFFadeDuration`.
 @param toAlpha Target alpha.
 @param delay Seconds of delay.
 @param completion Callback.
 */
- (void)fadeInTo:(CGFloat)toAlpha withDelay:(NSTimeInterval)delay andCompletion:(void (^)(void))completion;

///----------------------------------
/// @name Managing the View Hierarchy
///----------------------------------

/**
 Returns an array of the receiver's superviews.
 The immediate super view is the first object in the array. The outer most super
 view is the last object in the array.
 @return An array of view objects containing the receiver
 */
- (NSArray *)superviews;

/**
 Returns the first super view of a given class.
 If a super view is not found for the given `superviewClass`, `nil` is returned.
 @param superviewClass A Class to search the `superviews` for
 @return A view object or `nil`
 */
- (id)firstSuperviewOfClass:(Class)superviewClass;

@end
