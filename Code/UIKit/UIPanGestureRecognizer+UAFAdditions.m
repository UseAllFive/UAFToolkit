//
//  UIPanGestureRecognizer+UAFAdditions.m
//  UAFToolkit
//
//  Created by Peng Wang on 2/25/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import "UIPanGestureRecognizer+UAFAdditions.h"

static CGFloat const kUAFPanAsSwipeMinVelocity = 88.0f;

@implementation UIPanGestureRecognizer (UAFAdditions)

- (UIPanGestureRecognizerDirection)direction
{
  static CGFloat ratioFactor = 6.0f;
  CGPoint velocity = self.velocity;
  CGFloat magnitudeRatio = ABS(velocity.x || fmaxf(1.0f, velocity.y));
  UIPanGestureRecognizerDirection direction = 0;
  //-- Case: { 0, 100 }
  //-- Case: { 300, 2000 }
  //-- Case: { 1000, -1000 }
  if (magnitudeRatio > (ratioFactor / 1.0f) || ABS(velocity.x) > kUAFPanAsSwipeMinVelocity) {
    //-- Horizontal.
    if (velocity.x > 0.0f) {
      direction |= UIPanGestureRecognizerDirectionRight;
    } else if (velocity.x < 0.0f) {
      direction |= UIPanGestureRecognizerDirectionLeft;
    }
  }
  if (magnitudeRatio < (1.0f / ratioFactor) || ABS(velocity.y) > kUAFPanAsSwipeMinVelocity) {
    //-- Vertical.
    if (velocity.y > 0.0f) {
      direction |= UIPanGestureRecognizerDirectionDown;
    } else if (velocity.y < 0.0f) {
      direction |= UIPanGestureRecognizerDirectionUp;
    }
  }
  //-- Debug.
  SLog(@"RATIO: %f", magnitudeRatio);
  DLog(@"DIRECTION: %d", direction);
  return direction;
}

- (UISwipeGestureRecognizerDirection)swipeDirection
{
  CGFloat minDistance = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 44.0f : 88.0f;
  CGPoint velocity = self.velocity;
  UIPanGestureRecognizerDirection direction = self.direction;
  CGPoint distance = self.distance;
  if (ABS(velocity.x) < kUAFPanAsSwipeMinVelocity || ABS(distance.x) < minDistance) {
    if (direction & UIPanGestureRecognizerDirectionRight) {
      direction &= ~UIPanGestureRecognizerDirectionRight;
    }
    if (direction & UIPanGestureRecognizerDirectionLeft) {
      direction &= ~UIPanGestureRecognizerDirectionLeft;
    }
  }
  if (ABS(velocity.y) < kUAFPanAsSwipeMinVelocity || ABS(distance.y) < minDistance) {
    if (direction & UIPanGestureRecognizerDirectionDown) {
      direction &= ~UIPanGestureRecognizerDirectionDown;
    }
    if (direction & UIPanGestureRecognizerDirectionUp) {
      direction &= ~UIPanGestureRecognizerDirectionUp;
    }
  }
  return (UISwipeGestureRecognizerDirection)direction;
}

- (CGPoint)velocity
{
  if (!self.view) {
    DLog(@"GUARDED");
    return CGPointZero;
  }
  return [self velocityInView:self.view];
}

- (CGPoint)distance
{
  if (!self.view) {
    DLog(@"GUARDED");
    return CGPointZero;
  }
  return [self translationInView:self.view];
}

@end
