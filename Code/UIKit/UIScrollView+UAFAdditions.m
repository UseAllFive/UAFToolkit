//
//  UIScrollView+UAFAdditions.m
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. All rights reserved.
//

#import "UIScrollView+UAFAdditions.h"

#import "UAFDrawingUtilities.h"
#import "UIView+UAFAdditions.h"
#import "UIScreen+UAFAdditions.h"

@implementation UIScrollView (UAFAdditions)

- (BOOL)canScrollHorizontally
{
  return self.width < self.contentSize.width;
}
- (BOOL)canScrollVertically
{
  return self.height < self.contentSize.height;
}

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

#pragma mark - Sam Soffes

- (void)scrollToTop {
	[self scrollToTopAnimated:NO];
}

- (void)scrollToTopAnimated:(BOOL)animated {
	[self setContentOffset:CGPointMake(0.0f, 0.0f) animated:animated];
}

@end
