//
//  UAFKeyboardResizing.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <UIKit/UIKit.h>

/**
 Requirements for a view-controller that wants to adjust layout of certain
 selected scroll-views based on the appearance of the system keyboard view.
 @note See <UIViewController(UAFAdditions_KeyboardResizing)> for the methods involved. This is
 due to the methods being part of a category extension and this protocol being
 designed to be implemented by subclasses only. The methods will check if the
 view-controller conforms to this protocol.
 */
@protocol UAFKeyboardResizing <NSObject>

/**
 The views that should resize with the keyboard.
 @see [UIScrollView(UAFAdditions_KeyboardResizing) keyboardDidShow:]
 @see [UIScrollView(UAFAdditions_KeyboardResizing) keyboardWillHide:]
 */
@property (strong, nonatomic) NSMutableArray *keyboardResizingViews;

@optional
/**
 Optional flag for tracking keyboard state. Useful for determining input state.
 */
@property (nonatomic) BOOL isKeyboardVisible;

@end