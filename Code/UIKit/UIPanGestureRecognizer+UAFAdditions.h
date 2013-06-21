//
//  UIPanGestureRecognizer+UAFAdditions.h
//  UAFToolkit
//
//  Created by Peng Wang on 2/25/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <UIKit/UIKit.h>

#import "UAFDebugUtilities.h"

//-- UIPanGestureRecognizerDirection mirrors UISwipeGestureRecognizerDirection.
typedef NS_OPTIONS(NSUInteger, UIPanGestureRecognizerDirection) {
  UIPanGestureRecognizerDirectionRight = 1 << 0,
  UIPanGestureRecognizerDirectionLeft  = 1 << 1,
  UIPanGestureRecognizerDirectionUp    = 1 << 2,
  UIPanGestureRecognizerDirectionDown  = 1 << 3,
};

@interface UIPanGestureRecognizer (UAFAdditions)

//-- Note: These are calculated on each access.
- (UIPanGestureRecognizerDirection)direction;
- (UISwipeGestureRecognizerDirection)swipeDirection;

- (CGPoint)velocity;
- (CGPoint)distance;

@end
