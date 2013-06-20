//
//  UIScrollView+UAFAdditions.h
//  UAFToolkit

//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. All rights reserved.
//

#import <UIKit/UIKit.h>

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

///--------------------------
/// @name UAFKeyboardResizing
///--------------------------

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
