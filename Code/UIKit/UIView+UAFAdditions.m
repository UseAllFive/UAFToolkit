//
//  UIView+UAFAdditions.m
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. See license.
//

#import "UIView+UAFAdditions.h"
#import "UIScreen+UAFAdditions.h"
#import <QuartzCore/QuartzCore.h>

NSTimeInterval kUAFFadeDuration = 0.2f;

@implementation UIView (UAFAdditions)

#pragma mark - Absolute Position Accessors

- (CGFloat)left {
  return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)x {
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}

- (CGFloat)top {
  return self.frame.origin.y;
}
- (void)setTop:(CGFloat)y {
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = frame;
}

- (CGFloat)right {
  return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)right {
  CGRect frame = self.frame;
  frame.origin.x = right - frame.size.width;
  self.frame = frame;
}

- (CGFloat)bottom {
  return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
  CGRect frame = self.frame;
  frame.origin.y = bottom - frame.size.height;
  self.frame = frame;
}

- (CGFloat)centerX {
  return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX {
  self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
  return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY {
  self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
  return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin {
  CGRect frame = self.frame;
  frame.origin = origin;
  self.frame = frame;
}

#pragma mark - Relative Position Accessors

- (CGFloat)relLeft {
  return self.bounds.origin.x;
}
- (void)setRelLeft:(CGFloat)x {
  CGRect bounds = self.bounds;
  bounds.origin.x = x;
  self.bounds = bounds;
}

- (CGFloat)relTop {
  return self.bounds.origin.y;
}
- (void)setRelTop:(CGFloat)y {
  CGRect bounds = self.bounds;
  bounds.origin.y = y;
  self.bounds = bounds;
}

- (CGFloat)relRight {
  return self.bounds.origin.x + self.bounds.size.width;
}
- (void)setRelRight:(CGFloat)right {
  CGRect bounds = self.bounds;
  bounds.origin.x = right - bounds.size.width;
  self.bounds = bounds;
}

- (CGFloat)relBottom {
  return self.bounds.origin.y + self.bounds.size.height;
}
- (void)setRelBottom:(CGFloat)bottom {
  CGRect bounds = self.bounds;
  bounds.origin.y = bottom - bounds.size.height;
  self.bounds = bounds;
}

- (CGFloat)relCenterX {
  return self.centerX - self.left + self.relLeft;
}
- (void)setRelCenterX:(CGFloat)relCenterX {
  self.centerX = relCenterX + self.left - self.relLeft;
}

- (CGFloat)relCenterY {
  return self.centerY - self.top + self.relTop;
}
- (void)setRelCenterY:(CGFloat)relCenterY {
  self.centerY = relCenterY + self.top - self.relTop;
}

- (CGPoint)relOrigin {
  return self.bounds.origin;
}
- (void)setRelOrigin:(CGPoint)origin {
  CGRect bounds = self.bounds;
  bounds.origin = origin;
  self.bounds = bounds;
}

#pragma mark - Size Accessors.

- (CGFloat)width {
  return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}

- (CGFloat)height {
  return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}

- (CGSize)size {
  return self.frame.size;
}
- (void)setSize:(CGSize)size {
  CGRect frame = self.frame;
  frame.size = size;
  self.frame = frame;
}

#pragma mark - Helpers.

- (void)removeAllSubviews {
  while (self.subviews.count) {
    UIView* child = self.subviews.lastObject;
    [child removeFromSuperview];
  }
}

- (CGPoint)realCenter {
  return (UIDeviceOrientationIsLandscape([UIScreen mainScreen].currentOrientation) && self.centerX < self.centerY)
  ? CGPointMake(self.centerY, self.centerX) : self.center;
}

+ (CGRect)flipRect:(CGRect)rect
{
  CGFloat buffer = rect.size.width;
  rect.size.width = rect.size.height;
  rect.size.height = buffer;
  buffer = rect.origin.x;
  rect.origin.x = rect.origin.y;
  rect.origin.y = buffer;
  return rect;
}

- (UIView *)firstSubviewOfClass:(Class)subviewClass
{
  for (UIView *subview in self.subviews) {
    if ([subview isKindOfClass:subviewClass]) {
      return subview;
    }
  }
  return nil;
}

#pragma mark - Sam Soffes

- (UIImage *)imageRepresentation {
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (void)hide {
	self.alpha = 0.0f;
	self.hidden = YES;
}

- (void)show {
	self.alpha = 1.0f;
	self.hidden = NO;
}

- (void)setIsVisible:(BOOL)isVisible {
  self.alpha = isVisible ? 1.0f : 0.0f;
}

- (BOOL)isOnScreen {
  return !!self.window;
}

- (void)fadeOut {
  [self fadeOutWithCompletion:nil];
}
- (void)fadeOutTo:(CGFloat)toAlpha {
  [self fadeOutTo:toAlpha withCompletion:nil];
}
- (void)fadeOutWithCompletion:(void (^)(void))completion {
  [self fadeOutTo:0.0f withCompletion:completion];
}
- (void)fadeOutTo:(CGFloat)toAlpha withCompletion:(void (^)(void))completion {
  [self fadeOutTo:toAlpha withDelay:0.0f andCompletion:completion];
}
- (void)fadeOutTo:(CGFloat)toAlpha withDelay:(NSTimeInterval)delay andCompletion:(void (^)(void))completion {
  toAlpha = fmaxf(0.0f, fminf(1.0f, toAlpha));
	UIView *view = self;
	[UIView animateWithDuration:((view.alpha == toAlpha) ? 0.0f : kUAFFadeDuration) delay:delay options:UIViewAnimationOptionAllowUserInteraction animations:^{
		view.alpha = toAlpha;
	} completion:^(BOOL finished) {
    if (toAlpha == 0.0f) {
      view.hidden = YES;
      if (completion) {
        dispatch_async(dispatch_get_main_queue(), completion);
      }
    }
  }];
}

- (void)fadeOutAndRemoveFromSuperview {
	UIView *view = self;
  [self fadeOutWithCompletion:^{ [view removeFromSuperview]; }];
}

- (void)fadeIn {
  [self fadeInWithCompletion:nil];
}
- (void)fadeInTo:(CGFloat)toAlpha {
  [self fadeInTo:toAlpha withCompletion:nil];
}
- (void)fadeInWithCompletion:(void (^)(void))completion {
  [self fadeInTo:1.0f withCompletion:completion];
}
- (void)fadeInTo:(CGFloat)toAlpha withCompletion:(void (^)(void))completion {
  [self fadeInTo:toAlpha withDelay:0.0f andCompletion:completion];
}
- (void)fadeInTo:(CGFloat)toAlpha withDelay:(NSTimeInterval)delay andCompletion:(void (^)(void))completion {
  toAlpha = fmaxf(0.0f, fminf(1.0f, toAlpha));
	UIView *view = self;
	view.hidden = NO;
	[UIView animateWithDuration:((view.alpha == toAlpha) ? 0.0f : kUAFFadeDuration) delay:delay options:UIViewAnimationOptionAllowUserInteraction animations:^{
		view.alpha = toAlpha;
	} completion:^(BOOL finished) {
    if (completion) {
      dispatch_async(dispatch_get_main_queue(), completion);
    }
  }];
}

- (NSArray *)superviews {
	NSMutableArray *superviews = [[NSMutableArray alloc] init];
	
	UIView *view = self;
	UIView *superview = nil;
	while (view) {
		superview = [view superview];
		if (!superview) {
			break;
		}
		
		[superviews addObject:superview];
		view = superview;
	}
	
	return superviews;
}

- (id)firstSuperviewOfClass:(Class)superviewClass {
	UIView *view = self;
	UIView *superview = nil;
	while (view) {
		superview = [view superview];
		if ([superview isKindOfClass:superviewClass]) {
			return superview;
		}
		view = superview;
	}
	return nil;
}

@end
