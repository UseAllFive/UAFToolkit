//
//  UIViewController+UAFAdditions.h
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Requirements for a view-controller that wants to adjust layout of certain
 selected scroll-views based on the appearance of the system keyboard view.
 @note See <UIViewController(UAFAdditions)> for the methods involved. This is
 due to the methods being part of a category extension and this protocol being
 designed to be implemented by subclasses only. The methods will check if the
 view-controller conforms to this protocol.
 */
@protocol UAFKeyboardResizing <NSObject>

/**
 The views that should resize with the keyboard.
 @see [UIScrollView(UAFAdditions) keyboardDidShow:]
 @see [UIScrollView(UAFAdditions) keyboardWillHide:]
 */
@property (strong, nonatomic) NSMutableArray *keyboardResizingViews;

@optional
/**
 Optional flag for tracking keyboard state. Useful for determining input state.
 */
@property (nonatomic) BOOL isKeyboardVisible;

@end

/**
 Requirements for a view-controller that wants to maintain the state of modal
 view-controllers it presents. Intended to work with
 <[UIViewController(UAFAdditions) rootPresentingViewController]>. It is up to
 each view-controller to decide how to store and restore the state data.
 
 For a view-controller that wants to dismiss while sending state,
 <[UIViewController(UAFAdditions)
 dismissViewController:animated:completion:path:userInfo:]> should be used, as
 that calls
 <viewWillAppearFromDismissalOfModalViewControllerOfClass:withNavigationPath:andUserInfo:>.
 */
@protocol UAFModalNavigation <NSObject>

/**
 Hook for when a presented modal view-controller dismisses itself while sending
 state.
 @param aClass The class of the dismissed view-controller.
 @param indexPath Model path for the view-controller's state. Depends on the
 view-controller.
 @param userInfo Additional information. Depends on the view-controller.
 */
- (void)viewWillAppearFromDismissalOfModalViewControllerOfClass:(Class)aClass
                                             withNavigationPath:(NSIndexPath *)indexPath
                                                    andUserInfo:(NSDictionary *)userInfo;

@end

/**
 Provides extensions to `UIViewController` for various common tasks.
 */
@interface UIViewController (UAFAdditions)

///------------------
/// @name Boilerplate
///------------------

/**
 Useful for when multiple constructors need to share common initialization
 logic. Default implementation does nothing.
 */
- (void)commonInit;
/**
 Useful for when multiple constructors for view-controllers using nibs need to
 share common initialization logic. Default implementation does nothing.
 */
- (void)commonAwake;

///--------------------------
/// @name UAFKeyboardResizing
///--------------------------

/**
 Binds own keyboard event handlers to notifications as needed. Registers view to
 <[UAFKeyboardResizing keyboardResizingViews]>
 @param view The view that should resize with keyboard.
 @return Operation success.
 */
- (BOOL)setupResizingWithKeyboardForView:(UIScrollView *)view;
/**
 Tears down keyboard event bindings. Unregisters view from <[UAFKeyboardResizing
 keyboardResizingViews]>.
 @param view Description.
 @return Operation success.
 */
- (BOOL)teardownResizingWithKeyboardForView:(UIScrollView *)view;
/**
 Wraps around <[UIScrollView(UAFAdditions) keyboardDidShow:]>. Updates
 <[UAFKeyboardResizing isKeyboardVisible]> as needed.
 @param notification Keyboard notification `UIKeyboardDidShowNotification`.
 */
- (void)keyboardDidShow:(NSNotification *)notification;
/**
 Wraps around <[UIScrollView(UAFAdditions) keyboardWillHide:]>. Updates
 <[UAFKeyboardResizing isKeyboardVisible]> as needed.
 @param notification Keyboard notification `UIKeyboardWillHideNotification`.
 */
- (void)keyboardWillHide:(NSNotification *)notification;

///----------------
/// @name Traversal
///----------------

/**
 Traverses to find the 'root' view-controller. Uses `presentingViewController`
 and walks up the chain of presenters. When encountering a
 navigation-controller, the `topViewController` is returned.
 @return The target view controller.
 @note Experimental.
 */
- (UIViewController *)rootPresentingViewController;
/**
 Wraps around `[UIViewController dismissViewControllerAnimated:completion:]`.
 Calls <[UAFModalNavigation
 viewWillAppearFromDismissalOfModalViewControllerOfClass:withNavigationPath:andUserInfo:]>
 if possible.
 @param viewController The presented view-controller.
 @param flag Animated. `NO` makes transition immediate.
 @param completion Callback.
 @param indexPath Model path for the view-controller's state. Depends on the
 view-controller.
 @param userInfo Additional information. Depends on the view-controller.
 */
- (void)dismissViewController:(UIViewController *)viewController
                     animated:(BOOL)flag completion:(void (^)(void))completion
                         path:(NSIndexPath *)indexPath userInfo:(NSDictionary *)userInfo;

///------------------------
/// @name Presenting Errors
///------------------------

/**
 Present a `UIAlertView` with an error message.
 @param error Error to present.
 */
- (void)displayError:(NSError *)error;

/**
 Present a `UIAlertView` with an error message.
 @param string Error string to present.
 */
- (void)displayErrorString:(NSString *)string;

@end
