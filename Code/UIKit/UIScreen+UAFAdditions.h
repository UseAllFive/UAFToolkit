//
//  UIScreen+UAFAdditions.h
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Provides extensions to `UIScreen` for various common tasks. 
 */
@interface UIScreen (UAFAdditions)

///---------------------------
/// @name Accessing the Bounds
///---------------------------

/**
 Returns the bounds of the screen for the current device orientation.
 @return A rect indicating the bounds of the screen.
 @see boundsForOrientation:
 */
- (CGRect)currentBounds;
/**
 Current device orientation.
 @return The interface orientation.
 */
- (UIInterfaceOrientation)currentOrientation;
/**
 Shorthand for `UIInterfaceOrientationIsLandscape([self currentOrientation]);`
 @return If device orientation is landscape.
 */
- (BOOL)isLandscape;
/**
 Returns the bounds of the screen for a given device orientation. `UIScreen`'s `bounds` method always returns the bounds
 of the screen of it in the portrait orientation.
 @param orientation The orientation to get the screen's bounds.
 @return A rect indicating the bounds of the screen.
 @see currentBounds
 */
- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation;
/**
 Abstracts away the procedure of getting the bounds of the system keyboard-view.
 @param notification Keyboard notification.
 @return A rect indicating the bounds of the keyboard.
 */
+ (CGRect)keyboardBoundsForNotification:(NSNotification *)notification;

///------------------------
/// @name Screen Attributes
///------------------------

/**
 Returns a Boolean indicating if the screen is a Retina display.
 @return A Boolean indicating if the screen is a Retina display.
 */
- (BOOL)isRetinaDisplay;

@end
