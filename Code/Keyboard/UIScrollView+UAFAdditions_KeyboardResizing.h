//
//  UIScrollView+UAFAdditions_KeyboardResizing.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <UIKit/UIKit.h>

#import "UAFKeyboardResizing.h"
#import "UIView+UAFAdditions.h"
#import "UIScreen+UAFAdditions.h"

#import "UAFDrawingUtilities.h"

@interface UIScrollView (UAFAdditions_KeyboardResizing)

/**
 Adapt frame to keyboard frame.
 @param notification Keyboard notification `UIKeyboardDidShowNotification`.
 @note Still experimental.
 */
- (void)keyboardDidShow:(NSNotification *)notification;
/**
 Reset keyboard-adapted frame.
 @param notification Keyboard notification `UIKeyboardWillHideNotification`.
 @note Still experimental.
 */
- (void)keyboardWillHide:(NSNotification *)notification;

@end
