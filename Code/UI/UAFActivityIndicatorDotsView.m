//
//  UAFActivityIndicatorDotsView.m
//  UAFToolkit
//
//  Created by Peng Wang on 6/21/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import "UAFActivityIndicatorDotsView.h"

@interface UAFActivityIndicatorDotsView ()

@property (nonatomic) CGFloat elementCount;

@property (nonatomic) CGFloat cellSize;
@property (nonatomic) CGFloat gutterSize;
@property (nonatomic) CGFloat elementSize;
@property (strong, nonatomic) NSMutableArray *animations;

@end

@implementation UAFActivityIndicatorDotsView

@synthesize toggleTransitionDuration, isAnimating, bounceRatio;

- (void)_commonInit
{
  //-- Custom initialization.
  self.fillColor = [UIColor whiteColor];
  self.fromAlpha = 0.5f;
  self.toAlpha = 1.0f;
  self.gutterRatio = 0.2f;
  self.bounceRatio = 0.2f;
  
  self.cycleDuration = 1.0f;
  self.elementCount = 3;
  
  self.animations = [NSMutableArray array];
  
  self.toggleTransitionDuration = kUAFFadeDuration;
  
  for (NSUInteger i = 0; i < self.elementCount; i++) {
    //-- Layer.
    CAShapeLayer *element = [CAShapeLayer layer];
    [self.layer addSublayer:element];
    //-- Animation.
    //-- TODO: Doesn't offer delay.
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = YES;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.animations addObject:animation];
  }
  self.isAnimating = NO;
}

- (void)_commonAwake
{
  //-- Custom initialization.
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  //-- Section: layout.
  self.cellSize = floorf(self.width / self.elementCount);
  self.elementSize = floorf(self.cellSize * (1.0f - self.gutterRatio));
  CGFloat gutter = self.gutterSize / 2.0f;
  CGFloat margin = (self.cellSize - self.elementSize) / 2.0f;
  [self.layer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    CAShapeLayer *element = (CAShapeLayer *)obj;
    CGRect rect = CGRectMake(((self.cellSize + gutter) * idx) + margin, margin,
                             self.elementSize, self.elementSize);
    element.path = [UIBezierPath bezierPathWithOvalInRect:rect].CGPath;
  }];
  //-- Section: styling.
  for (CAShapeLayer *element in self.layer.sublayers) {
    element.fillColor = self.fillColor.CGColor;
  }
  //-- Animated.
  NSTimeInterval duration = self.cycleDuration / 2.0f;
  CGFloat offset = self.cycleDuration / self.elementCount;
  [self.animations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    CABasicAnimation *animation = (CABasicAnimation *)obj;
    animation.fromValue = @( self.fromAlpha );
    animation.toValue = @( self.toAlpha );
    animation.duration = duration;
    animation.beginTime = (idx + 1) * offset;
  }];
}

- (void)fadeInWithCompletion:(void (^)(void))completion
{
  //-- Note: The sound for indicator views can vary, so this part's empty.
  [super fadeInWithCompletion:nil];
  for (CAShapeLayer *element in self.layer.sublayers) {
    element.opacity = 0.0f;
  }
  [UIView animateWithDuration:self.toggleTransitionDuration delay:0.0f options:0 animations:^{
    for (CAShapeLayer *element in self.layer.sublayers) {
      element.opacity = self.fromAlpha;
    }
  } completion:nil];
  //-- This will take the longest.
  [UIView toggleView:self toPopInDirection:UAFPopDirectionOut withOptions:UAFPopOptionOvershoot completion:completion andConfiguration:nil];
}

- (void)fadeOutWithCompletion:(void (^)(void))completion
{
  [super fadeOutWithCompletion:nil];
  //-- This will take the longest.
  [UIView toggleView:self toPopInDirection:UAFPopDirectionIn withOptions:UAFPopOptionUndershoot completion:completion andConfiguration:nil];
}

#pragma mark - Public

- (void)toggleToAnimating:(BOOL)animating
{
  if (animating == self.isAnimating) {
    if (self.shouldDebug) DLog(@"Guarded.");
    return;
  }
  self.isAnimating = animating;
  if (animating) {
    [self.layer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      CALayer *element = (CALayer *)obj;
      [element addAnimation:self.animations[idx] forKey:@"opacity"];
    }];
  } else {
    for (CALayer *layer in self.layer.sublayers) {
      [layer removeAllAnimations];
    }
  }
}

@end
