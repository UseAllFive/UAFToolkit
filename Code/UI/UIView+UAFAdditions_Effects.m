//
//  UIView+UAFAdditions_Effects.m
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import "UIView+UAFAdditions_Effects.h"

@implementation UIView (UAFAdditions_Effects)

+ (void)toggleModalView:(UIView<UAFModalView> *)view toVisible:(BOOL)visible animated:(BOOL)animated
{
  if (![view conformsToProtocol:@protocol(UAFModalView)]) {
    return DLog(@"GUARDED");
  }
  CGFloat totalDuration = view.toggleTransitionDuration;
  UAFDirection visibleDirection = UAFDirectionUp; //-- Default.
  if ([view respondsToSelector:@selector(toggleTransitionDirection)]
      && [view toggleTransitionDirection] != UAFDirectionNone
      ) {
    visibleDirection = view.toggleTransitionDirection;
  }
  //-- Handle hard transitions.
  if (!animated) {
    totalDuration = 0.0f;
  }
  //-- Pre.
  //-- The horizontal transition is like a page-flip.
  if (visible) {
    switch (visibleDirection) {
      case UAFDirectionUp:    view.top = view.height; break;
      case UAFDirectionRight: view.left = view.width; break;
      case UAFDirectionLeft:  view.left = -view.width; break;
      default: break;
    }
    [view show];
  } else {
    switch (visibleDirection) {
      case UAFDirectionUp:    view.top = 0.0f; break;
      case UAFDirectionRight: view.left = 0.0f; break;
      case UAFDirectionLeft:  view.left = 0.0f; break;
      default: break;
    }
  }
  //-- Slide.
  if (animated && [view respondsToSelector:@selector(setIsAnimating:)]) {
    view.isAnimating = YES;
  }
  [UIView animateWithDuration:totalDuration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
    switch (visibleDirection) {
      case UAFDirectionUp:    view.top = visible ? 0.0f : view.height; break;
      case UAFDirectionRight: view.left = visible ? 0.0f : -view.width; break;
      case UAFDirectionLeft:  view.left = visible ? 0.0f : -view.width; break;
      default: break;
    }
  } completion:^(BOOL finished) {
    //-- Post.
    if (!visible) {
      [view hide];
    }
    //-- Record as needed.
    if ([view respondsToSelector:@selector(setIsToggled:)]) {
      view.isToggled = visible;
    }
    if (animated && [view respondsToSelector:@selector(setIsAnimating:)]) {
      view.isAnimating = NO;
    }
  }];
}

+ (void)toggleMaskedView:(UIView *)view withSuperview:(UIView *)superview toRevealed:(BOOL)revealed animated:(BOOL)animated
{
  UIView<UAFToggledView> *toggledView = (UIView<UAFToggledView> *)
  ([view conformsToProtocol:@protocol(UAFToggledView)] ? view : superview);
  if (!toggledView) {
    return DLog(@"GUARDED");
  }
  CAGradientLayer *mask = (CAGradientLayer *)view.layer.mask;
  if (!mask && !CGRectEqualToRect(view.bounds, CGRectZero)) {
    mask = [CAGradientLayer layer];
    mask.frame = view.bounds;
    mask.colors = @[
                    (__bridge id)[UIColor clearColor].CGColor,
                    (__bridge id)[UIColor clearColor].CGColor,
                    (__bridge id)[UIColor whiteColor].CGColor,
                    (__bridge id)[UIColor whiteColor].CGColor];
    mask.startPoint = CGPointMake(0.0f, 0.5f);
    mask.endPoint = CGPointMake(1.0f, 0.5f);
    view.layer.mask = mask;
  }
  if (!mask) {
    return DLog(@"GUARDED");
  }
  //-- UIView's +animateWith[...] doesn't respect the 'soft edges' from the gradient mask.
  [CATransaction begin];
  [CATransaction setValue:[NSNumber numberWithFloat:(animated ? toggledView.toggleTransitionDuration : 0.0f)]
                   forKey:kCATransactionAnimationDuration];
  [CATransaction setValue:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] forKey:kCATransactionAnimationTimingFunction];
  //-- Note: Supported orientations / directions can be expanded here.
  if (revealed) {
    mask.locations = @[ @( -1.0f ), @( -0.5f ), @( 0.0f ), @( 1.0f ) ];
  } else {
    mask.locations = @[ @( 0.0f ), @( 1.0f ), @( 1.5f ), @( 2.0f ) ];
  }
  //-- Record as needed.
  [CATransaction setCompletionBlock:^{
    if ([toggledView respondsToSelector:@selector(setIsToggled:)]) {
      toggledView.isToggled = revealed;
    }
    if (animated && [toggledView respondsToSelector:@selector(setIsAnimating:)]) {
      toggledView.isAnimating = YES;
    }
  }];
  if (animated && [toggledView respondsToSelector:@selector(setIsAnimating:)]) {
    toggledView.isAnimating = YES;
  }
  [CATransaction commit];
}

+ (void)toggleView:(UIView *)view toPopInDirection:(UAFPopDirection)direction withOptions:(UAFPopOption)options completion:(void (^)(void))completion andConfiguration:(NSDictionary *)config
{
  BOOL isToggledView = [view conformsToProtocol:@protocol(UAFToggledView)];
  BOOL expanded   = direction == UAFPopDirectionOut;
  BOOL isStatic   = direction == UAFPopDirectionStatic;
  BOOL overshot   = options & UAFPopOptionOvershoot;
  BOOL undershot  = options & UAFPopOptionUndershoot && direction != UAFPopDirectionIn;
  NSString *soundName = (config && config[@"Sound-Name"]
                         ? config[@"Sound-Name"]
                         : (isToggledView
                            ? [UIView soundNameForToggledView:(id)view andState:expanded]
                            : nil));
  //-- Handle optional sounds.
  if (soundName
      && !(options & UAFPopOptionSilent)
      && (!isToggledView || ![(id)view isPlayingSound])
      ) {
    if (config) {
      NSMutableDictionary *newConfig = config.mutableCopy;
      [newConfig removeObjectForKey:@"Sound-Name"];
      config = newConfig;
    }
    //-- Abstract as needed.
    BOOL isPlayingSound = NO;
    if ([view respondsToSelector:@selector(soundEffectsPlayer)]) {
      id player = [view performSelector:@selector(soundEffectsPlayer)];
      if (player && [player respondsToSelector:@selector(playSound:withLoadCompletion:)]) {
        isPlayingSound = (BOOL)[player performSelector:@selector(playSound:withLoadCompletion:) withObject:soundName withObject:^{
          [UIView toggleView:view toPopInDirection:direction withOptions:options completion:completion andConfiguration:config];
        }];
      }
    }
    if ([view respondsToSelector:@selector(setIsPlayingSound:)]) {
      [(id)view setIsPlayingSound:isPlayingSound];
    }
    return; //-- Recurse.
  }
  //-- Configuration.
  CGFloat bounceRatio = (isToggledView && [view respondsToSelector:@selector(bounceRatio)])
  ? [(id)view bounceRatio] : (config[@"Bounce-Ratio"] ? [config[@"Bounce-Ratio"] floatValue] : 0.0f);
  CATransform3D contractedTransform   = (isToggledView && [view respondsToSelector:@selector(minScale)])
  ? CATransform3DMakeScale([(id)view minScale], [(id)view minScale], 1.0f) : CATransform3DMakeScale(0.0f, 0.0f, 1.0f);
  CATransform3D expandedTransform     = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
  CATransform3D expandedInTransform   = CATransform3DMakeScale(1.0f - bounceRatio, 1.0f - bounceRatio, 1.0f);
  CATransform3D expandedOutTransform  = CATransform3DMakeScale(1.0f + bounceRatio, 1.0f + bounceRatio, 1.0f);
  NSTimeInterval totalDuration = isToggledView ? [(id)view toggleTransitionDuration] : [config[@"Duration"] floatValue];
  NSTimeInterval duration = (undershot ? 0.7f : 1.0f) * totalDuration;
  NSTimeInterval undershootDuration = totalDuration * 0.3f;
  NSTimeInterval overshootDuration = totalDuration * 0.3f;
  NSTimeInterval delay = config[@"Delay"] ? [config[@"Delay"] floatValue] : 0.0f;
  UIViewAnimationOptions undershootOptions = UIViewAnimationOptionCurveEaseInOut;
  UIViewAnimationOptions overshootOptions = UIViewAnimationOptionCurveEaseInOut;
  UIViewAnimationOptions popOptions = UIViewAnimationOptionCurveEaseInOut;
  void (^undershootAnimation)(BOOL) = nil;
  void (^overshootAnimation)(BOOL) = nil;
  //-- Handle reverb animations.
  if (undershot) {
    undershootAnimation = ^(BOOL finished) {
      [UIView animateWithDuration:undershootDuration delay:0.0f options:undershootOptions animations:^{
        view.layer.transform = expandedInTransform;
        view.layer.transform = expandedTransform;
      } completion:nil];
    };
  }
  if (overshot) {
    overshootAnimation = ^(BOOL finished) {
      [UIView animateWithDuration:overshootDuration delay:0.0f options:overshootOptions animations:^{
        view.layer.transform = expandedOutTransform;
        view.layer.transform = expandedTransform;
      } completion:nil];
    };
  }
  //-- Start.
  if ([view respondsToSelector:@selector(setIsAnimating:)]) {
    [(id)view setIsAnimating:YES];
  }
  if (isStatic) {
    if (undershootAnimation) {
      totalDuration = undershootDuration;
      undershootAnimation(YES);
    } else if (overshootAnimation) {
      totalDuration = overshootDuration;
      overshootAnimation(YES);
    }
  } else {
    [UIView animateWithDuration:duration delay:delay options:popOptions animations:^{
      view.layer.transform = expanded ? contractedTransform : expandedTransform;
      if ((expanded && overshot) || (!expanded && undershot)) {
        view.layer.transform = expandedOutTransform;
      }
      view.layer.transform = expanded ? expandedTransform : contractedTransform;
    } completion:nil];
  }
  //-- Complete.
  UAFDispatchAfter(totalDuration, ^{
    if ([view respondsToSelector:@selector(setIsAnimating:)]) {
      [(id)view setIsAnimating:NO];
    }
    if ([view respondsToSelector:@selector(setIsPlayingSound:)]) {
      [(id)view setIsPlayingSound:NO];
    }
    if (completion) {
      completion();
    }
  });
}

+ (NSString *)soundNameForToggledView:(UIView<UAFToggledView> *)view andState:(BOOL)toggled
{
  if (([view respondsToSelector:@selector(shouldToggleSilently)] && view.shouldToggleSilently)
      || ![view respondsToSelector:@selector(isPlayingSound)]
      || (![view respondsToSelector:@selector(toggleSoundName)] && ![view respondsToSelector:@selector(toggleOnSoundName)])
      ) {
    //-- Handle silence or insufficient implementation.
    DLog(@"GUARDED");
    return nil;
  }
  return ([view respondsToSelector:@selector(toggleSoundName)] && view.toggleSoundName)
  ? view.toggleSoundName
  : ([view respondsToSelector:@selector(toggleOnSoundName)]
     ? (toggled ? view.toggleOnSoundName : view.toggleOffSoundName)
     : nil);
}

@end
