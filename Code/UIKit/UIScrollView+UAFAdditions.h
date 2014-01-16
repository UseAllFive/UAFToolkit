//
//  UIScrollView+UAFAdditions.h
//  UAFToolkit

//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012-2014 UseAllFive. See license.
//

#import <UIKit/UIKit.h>

#import "UIView+UAFAdditions.h"

/**
 Provides extensions to `UIScrollView` for various common tasks.
 */
@interface UIScrollView (UAFAdditions)

///--------------
/// @name Helpers
///--------------

/**
 Tests to see if scroll-view content is overflowing horizontally.
 @return Test result.
 */
- (BOOL)canScrollHorizontally;
/**
 Tests to see if scroll-view content is overflowing vertically.
 @return Test result.
 */
- (BOOL)canScrollVertically;

///----------------
/// @name Scrolling
///----------------

/**
 Scroll to the top of the receiver without animation.
 */
- (void)scrollToTop;

/**
 Scroll to the top of the receiver.
 @param animated `YES` to animate the transition at a constant velocity to the new offset, `NO` to make the transition immediate.
 */
- (void)scrollToTopAnimated:(BOOL)animated;

@end
