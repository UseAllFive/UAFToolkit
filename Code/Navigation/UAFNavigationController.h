//
//  UAFNavigationController.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/19/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <UIKit/UIKit.h>

#ifndef UAF_NAVIGATION
#define UAF_NAVIGATION
#endif

extern const NSTimeInterval kUAFNavigationDurationNone;

typedef NS_ENUM(NSUInteger, UAFNavigationDirection) {
  UAFNavigationDirectionNone,
  UAFNavigationDirectionHorizontal,
  UAFNavigationDirectionVertical,
};

@protocol UAFNavigationControllerDelegate, UAFPagingNavigationControllerDelegate;

/**
 A common protocol for custom navigation controllers. Covers most of the
 `UINavigationController` methods up until iOS 6. There are some minor
 differences, but these can only be fixed when the classes implementing this
 protocol get updated.

 The optional methods are mostly a guide for the daunting task of implementing a
 more advanced and not necessarily stack-based navigation controller. They
 introduce some new concepts:

 - `identifier` - Variants of the base push and pop methods allow getting the
   view-controller based on its storyboard identifier.
 - `focused` - If this flag is off, allows presenting or dismissing without
   calling the respective <UAFNavigationControllerDelegate> methods.
 - `pagingEnabled` - If this flag is on, the navigation controller would manage
   its children as a linear and uniform collection, ask for view controllers
   from the <pagingDelegate>, and optimize accordingly so view controllers can
   be lazy-loaded. This means there will not longer be a navigation stack.
 
 Also, while child view controllers can be any `UIViewController`, view
 controllers can implement <UAFNavigationItem> to allow even more non-linear
 navigation.
 */
@protocol UAFNavigationController <NSObject>

/**
 Main delegate.
 @see UAFNavigationControllerDelegate
 */
@property (weak, nonatomic) id<UAFNavigationControllerDelegate> delegate;

/**
 Navigation can happen only on one axis.
 
 `UAFNavigationDirection`:
 
 - `UAFNavigationDirectionHorizontal`
 - `UAFNavigationDirectionVertical`
 */
@property (nonatomic) UAFNavigationDirection baseNavigationDirection;
/**
 Duration of each navigation transition. Each transition, whether presenting or
 dismissing, is implied to have a uniform duration.
 */
@property (nonatomic) NSTimeInterval baseNavigationDuration;

/**
 `UINavigationController` method.
 @return Success.
 @note The different return value.
 */
- (BOOL)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
/**
 `UINavigationController` method.
 @return Success.
 @note The different return value.
 */
- (BOOL)popViewControllerAnimated:(BOOL)animated;
/**
 `UINavigationController` method.
 @return Success.
 @note The different return value.
 */
- (BOOL)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
/**
 `UINavigationController` method.
 @return Success.
 @note The different return value.
 */
- (BOOL)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;

@optional

//-- TODO: Eventually: Bad idea. Should be removed (with refactoring).
@property (nonatomic) UAFNavigationDirection onceNavigationDirection;
@property (nonatomic) NSTimeInterval onceNavigationDuration;

/**
 `UINavigationController` property.
 */
@property (weak, nonatomic, readonly) UIViewController *topViewController;
/**
 `UINavigationController` property.
 */
@property (weak, nonatomic, readonly) UIViewController *visibleViewController;
/**
 The previous view controller in the navigation stack, if any.
 */
@property (weak, nonatomic, readonly) UIViewController *previousViewController;
/**
 The next view controller in the navigation stack, if any.
 */
@property (weak, nonatomic, readonly) UIViewController *nextViewController;
/**
 `UINavigationController` property.
 @note The property is readonly. Use <setViewControllers:animated:>.
 */
@property (weak, nonatomic, readonly) NSArray *viewControllers;

/**
 Paging aspect delegate.
 @see UAFPagingNavigationControllerDelegate
 */
@property (weak, nonatomic) id<UAFPagingNavigationControllerDelegate> pagingDelegate;
/**
 Flag for allowing paging-specific logic.

 Default is `NO`.
 */
@property (nonatomic) BOOL pagingEnabled;
/**
 Flag for allowing navigation controller to update the optional
 <[UAFNavigationItem customIsBeingPresented]> and <[UAFNavigationItem
 customIsBeingDismissed]> flags.

 Default is `NO`.
 */
@property (nonatomic) BOOL shouldUpdatePresentationFlags;

/**
 Shorthand for calling <pushViewControllerWithIdentifier:animated:focused:>
 where `focused` is already set to a default value.
 @return Success.
 */
- (BOOL)pushViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated;
/**
 Shorthand for calling <popToViewController:animated:> where the view controller
 is acquired from a store based on the `identifier`.
 @return Success.
 */
- (BOOL)popToViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated;

/**
 Base push view controller method.
 @param focused See class documentation block above.
 @return Success.
 */
- (BOOL)pushViewController:(UIViewController *)viewController animated:(BOOL)animated focused:(BOOL)focused;
/**
 Shorthand for calling <pushViewController:animated:focused:> where the view
 controller is acquired from a store based on the `identifier`.
 @return Success.
 */
- (BOOL)pushViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated focused:(BOOL)focused;
/**
 Base pop view controller method.
 @param focused See class documentation block above.
 @return Success.
 */
- (BOOL)popViewControllerAnimated:(BOOL)animated focused:(BOOL)focused;
/**
 Wraps base push view controller with callback handling. Using
 <baseNavigationDuration> is suggested.
 @return Success.
 */
- (BOOL)pushViewController:(id)viewController animated:(BOOL)animated completion:(void(^)(void))completion;
/**
 Wraps base pop to view controller with callback handling. Using
 <baseNavigationDuration> is suggested.
 @return Success.
 */
- (BOOL)popToViewController:(id)viewController animated:(BOOL)animated completion:(void(^)(void))completion;
/**
 Wraps base pop view controller with callback handling. Using
 <baseNavigationDuration> is suggested.
 @return Success.
 */
- (BOOL)popViewControllerAnimated:(BOOL)animated completion:(void(^)(void))completion;

/**
 Wraps <setViewControllers:animated:> with `focused` aspect.
 @param focused See class documentation block above.
 @return Success.
 */
- (BOOL)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated focused:(BOOL)focused;

/**
 Request for view controller to be removed per navigation controller's judgment.
 @param viewController Will be set to `nil` on remove.
 @return Success.
 */
- (BOOL)handleRemovalRequestForViewController:(UIViewController *)viewController;

@end

/**
 The delegate protocol for custom navigation controllers.
 */
@protocol UAFNavigationControllerDelegate <NSObject>

@optional

/**
 Called when the navigation controller shows a new top view controller via a
 push, pop or setting of the view controller stack.
 */
- (void)customNavigationController:(id<UAFNavigationController>)navigationController
             willAddViewController:(UIViewController *)viewController;
/**
 Appearance delegate method.
 @param dismissed If happening on dismissal of current view controller, as opposed to presenting.
 */
- (void)customNavigationController:(id<UAFNavigationController>)navigationController
            willShowViewController:(UIViewController *)viewController animated:(BOOL)animated dismissed:(BOOL)dismissed;
/**
 Appearance delegate method.
 @param dismissed If happening on dismissal of current view controller, as opposed to presenting.
 */
- (void)customNavigationController:(id<UAFNavigationController>)navigationController
             didShowViewController:(UIViewController *)viewController animated:(BOOL)animated dismissed:(BOOL)dismissed;
/**
 Appearance delegate method.
 @param dismissed If happening on dismissal of current view controller, as opposed to presenting.
 */
- (void)customNavigationController:(id<UAFNavigationController>)navigationController
            willHideViewController:(UIViewController *)viewController animated:(BOOL)animated dismissed:(BOOL)dismissed;
/**
 Appearance delegate method.
 @param dismissed If happening on dismissal of current view controller, as opposed to presenting.
 */
- (void)customNavigationController:(id<UAFNavigationController>)navigationController
             didHideViewController:(UIViewController *)viewController animated:(BOOL)animated dismissed:(BOOL)dismissed;

/**
 Navigation guarding delegate method.
 */
- (BOOL)customNavigationController:(id<UAFNavigationController>)navigationController
    shouldNavigateToViewController:(UIViewController *)viewController;

/**
 Delegate method used for determining subviews that need to be affected in some
 way for interactive navigation to work. This is usually only necessary if the
 navigation process is very involved.
 @return Subviews that need to be affected by navigation controller.
 */
- (NSArray *)customNavigationControllerSubviewsToSupportInteractiveNavigation:(id<UAFNavigationController>)navigationController;

@end

/**
 The delegate protocol for the paging aspect of custom navigation controllers.
 */
@protocol UAFPagingNavigationControllerDelegate <NSObject>

/**
 Delegate, which keeps track of the child view controllers and acts as a
 factory, returns them and creates them as needed.
 @return Previous sibling view controller, if any.
 */
- (UIViewController *)customNavigationController:(id<UAFNavigationController>)navigationController
              viewControllerBeforeViewController:(UIViewController *)viewController;
/**
 Delegate, which keeps track of the child view controllers and acts as a
 factory, returns them and creates them as needed.
 @return Next sibling view controller, if any.
 */
- (UIViewController *)customNavigationController:(id<UAFNavigationController>)navigationController
               viewControllerAfterViewController:(UIViewController *)viewController;

@optional

/**
 Can be used in cases where appearance change is possible but not ensured. For
 example, the user can cancel the gesture. The delegate can decide if it still
 wants its will-change-appearance methods called in these situations. If not
 implemented, the delegate methods will not be called.
 @return Whether delegate wants notification.
 */
- (BOOL)customNavigationControllerShouldNotifyOfPossibleViewAppearanceChange:(id<UAFNavigationController>)navigationController;

@end
