//
//  UIScrollView+UAFAdditions_KeyboardResizing.m
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import "UIScrollView+UAFAdditions_KeyboardResizing.h"

@implementation UIScrollView (UAFAdditions_KeyboardResizing)

- (void)keyboardDidShow:(NSNotification *)notification
{
  CGFloat keyboardHeight = [UIScreen keyboardBoundsForNotification:notification].size.height;
  UIEdgeInsets contentInset = UIEdgeInsetsMake(0.0f, 0.0f, keyboardHeight, 0.0f);
  [UIView animateWithDuration:0.3f animations:^{
    self.contentInset = contentInset;
    self.scrollIndicatorInsets = contentInset;
  }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
  [UIView animateWithDuration:0.3f animations:^{
    self.contentInset = UIEdgeInsetsZero;
    self.scrollIndicatorInsets = UIEdgeInsetsZero;
  }];
}

@end
