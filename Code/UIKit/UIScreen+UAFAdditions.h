//
//  UIScreen+UAFAdditions.h
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012-2014 UseAllFive. See license.
//

#import <UIKit/UIKit.h>

#import "UIView+UAFAdditions.h"

#import "UAFDrawingUtilities.h"

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
- (CGRect)currentBounds:(BOOL)fullScreen;
/**
 Current device orientation.
 @return The interface orientation.
 */
- (UIInterfaceOrientation)currentOrientation;
/**
 Returns the bounds of the screen for a given device orientation. `UIScreen`'s `bounds` method always returns the bounds
 of the screen of it in the portrait orientation.
 @param orientation The orientation to get the screen's bounds.
 @return A rect indicating the bounds of the screen.
 @see currentBounds
 */
- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation;
- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation fullScreen:(BOOL)fullScreen;
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
/**
 Returns a Boolean indicating if the screen is a widescreen display.
 @return A Boolean indicating if the screen is a widescreen display.
 */
- (BOOL)isWideDisplay;

@end
