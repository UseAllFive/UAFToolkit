//
//  UIScrollView+UAFAdditions.m
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. See license.
//

#import "UIScrollView+UAFAdditions.h"

#import "UIView+UAFAdditions.h"

@implementation UIScrollView (UAFAdditions)

- (BOOL)canScrollHorizontally
{
  return self.width < self.contentSize.width;
}
- (BOOL)canScrollVertically
{
  return self.height < self.contentSize.height;
}

#pragma mark - Sam Soffes

- (void)scrollToTop {
	[self scrollToTopAnimated:NO];
}

- (void)scrollToTopAnimated:(BOOL)animated {
	[self setContentOffset:CGPointMake(0.0f, 0.0f) animated:animated];
}

@end
