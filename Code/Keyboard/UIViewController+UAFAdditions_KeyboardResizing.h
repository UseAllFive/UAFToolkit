//
//  UIViewController+UAFAdditions_KeyboardResizing.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UAFKeyboardResizing.h"
#import "UIScrollView+UAFAdditions_KeyboardResizing.h"

@interface UIViewController (UAFAdditions_KeyboardResizing)

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
 Wraps around <[UIScrollView(UAFAdditions_KeyboardResizing) keyboardDidShow:]>. Updates
 <[UAFKeyboardResizing isKeyboardVisible]> as needed.
 @param notification Keyboard notification `UIKeyboardDidShowNotification`.
 */
- (void)keyboardDidShow:(NSNotification *)notification;
/**
 Wraps around <[UIScrollView(UAFAdditions_KeyboardResizing) keyboardWillHide:]>. Updates
 <[UAFKeyboardResizing isKeyboardVisible]> as needed.
 @param notification Keyboard notification `UIKeyboardWillHideNotification`.
 */
- (void)keyboardWillHide:(NSNotification *)notification;

@end
