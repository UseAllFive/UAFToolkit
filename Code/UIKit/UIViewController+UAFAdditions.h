//
//  UIViewController+UAFAdditions.h
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012-2014 UseAllFive. See license.
//

#import <UIKit/UIKit.h>

/**
 Provides extensions to `UIViewController` for various common tasks.
 */
@interface UIViewController (UAFAdditions)

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
