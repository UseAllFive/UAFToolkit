//
//  UAFToastView.m
//  UAFToolkit
//
//  Created by Peng Wang on 6/21/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import "UAFToastView.h"

#import "NSString+UAFAdditions.h"

static UAFToastView *toastView;

static NSArray *keyPathsToObserve;
static void *observationContext = &observationContext;
static NSDictionary *defaultOptions;

@interface UAFToastView ()

@property (strong, nonatomic, readwrite) UILabel *titleLabel;

/**
 Centers the toast and renders it on the <screenView>.
 @param view The <screenView>.
 @note Only supports top and bottom edges.
 */
- (void)setupForScreenView:(UIView *)view;
/**
 Removes the toast from the <screenView>.
 @param view The <screenView>.
 */
- (void)teardownForScreenView:(UIView *)view;
/**
 Uses `defaultOptions` to restore original property configuration.
 @note Uses key-value coding.
 */
- (void)resetOptions;

@end

@implementation UAFToastView

@synthesize didCommonInit;

@synthesize toggleTransitionDuration, isAnimating, minScale;

- (void)_commonInit
{
  self.shouldDebug = YES;
  if (self.didCommonInit) {
    if (self.shouldDebug) DLog(@"Guarded.");
    return;
  }
  self.didCommonInit = YES;
  BOOL isPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    defaultOptions = @{ @"autoDismissDuration" : @3.0f,
                        @"dismissalBlock" : [NSNull null],
                        @"edgeOffset" : (isPhone ? @17.0f : @44.0f),
                        @"minScale" : @0.9f,
                        @"padding" : @10.0f,
                        @"positionDirection" : @(UAFDirectionDown),
                        @"shouldAutoDismiss" : @YES,
                        @"shouldLockTextWhenVisible" : @YES,
                        @"titleLabel.backgroundColor" : [UIColor clearColor],
                        @"titleLabel.font" : [UIFont boldSystemFontOfSize:(isPhone ? 12.0f : 16.0f)],
                        @"titleLabel.lineBreakMode": @(NSLineBreakByWordWrapping),
                        @"titleLabel.numberOfLines": @0,
                        @"titleLabel.textColor" : [UIColor blackColor],
                        @"toggleTransitionDuration" : @0.4f };
    keyPathsToObserve = @[ ];
  });
  //-- Setup.
  self.hidden = YES;
  self.userInteractionEnabled = NO;
  self.titleLabel = [UILabel new];
  [self addSubview:self.titleLabel];
  //-- Bind.
  for (NSString *keyPath in keyPathsToObserve) {
    [self addObserver:self forKeyPath:keyPath
              options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:&observationContext];
  }
  //-- Styling.
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.backgroundColor = [UIColor clearColor];
  //-- Default options.
  [self resetOptions];
}

- (void)_commonAwake
{
  //-- Nothing b/c we're not using nibs.
}

- (void)dealloc
{
  //-- Unbind.
  for (NSString *keyPath in keyPathsToObserve) {
    [self removeObserver:self forKeyPath:keyPath context:&observationContext];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (context == &observationContext) {

    id previousValue = change[NSKeyValueChangeOldKey];
    id value = change[NSKeyValueChangeNewKey];

  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  //-- Resize title label.
  CGFloat containerWidth = self.width == 0 ? [UIScreen mainScreen].currentBounds.size.width : self.width;
  [self.titleLabel sizeToFit];
  self.titleLabel.bounds = CGRectInset(self.titleLabel.bounds, -self.padding * 2.0f, -self.padding);
  self.titleLabel.width += fmodf(self.titleLabel.width, 2.0f);
  self.titleLabel.width = MIN(self.titleLabel.width, containerWidth); //-- Constrain to container.
  //-- Reposition title label.
  self.titleLabel.centerX = self.relCenterX;
  self.titleLabel.centerY = self.relCenterY;
}

- (void)fadeInTo:(CGFloat)toAlpha withDelay:(NSTimeInterval)delay andCompletion:(void (^)(void))completion
{
  [super fadeInTo:toAlpha withDelay:delay andCompletion:completion];
  [UIView toggleView:self toPopInDirection:UAFPopDirectionOut withOptions:UAFPopOptionNone completion:nil andConfiguration:@{ @"Delay" : @( delay ) }];
}

- (void)fadeOutTo:(CGFloat)toAlpha withDelay:(NSTimeInterval)delay andCompletion:(void (^)(void))completion
{
  [super fadeOutTo:toAlpha withDelay:delay andCompletion:^{
    if (completion) {
      completion();
    }
    if (self.dismissalBlock) {
      self.dismissalBlock();
    }
  }];
  [UIView toggleView:self toPopInDirection:UAFPopDirectionIn withOptions:UAFPopOptionNone completion:nil andConfiguration:@{ @"Delay" : @( delay ) }];
}

#pragma mark - Public

- (void)setTitleText:(NSString *)titleText
{
  if ([titleText isEqualToString:_titleText]) {
    if (self.shouldDebug) DLog(@"Guarded.");
    return;
  }
  _titleText = titleText;
  if (!self.shouldLockTextWhenVisible || self.isHidden) {
    //-- Re-layout.
    //-- Forward.
    NSString *text = [titleText.uppercaseString stringByTrimmingLeadingAndTrailingWhitespaceAndNewlineCharacters];
    if (!text.length) {
      if (self.shouldDebug) DLog(@"Guarded: Empty text.");
      return;
    }
    self.titleLabel.text = text;
    [self setNeedsLayout];
    //DLog(@"Center: %@, label size: %@", NSStringFromCGPoint(self.center), NSStringFromCGSize(self.titleLabel.size));
  }
}

- (BOOL)toggleToVisible:(BOOL)visible relativeToView:(UIView *)view
{
  return [self toggleToVisible:visible relativeToView:view withDelay:0.0f];
}
- (BOOL)toggleToVisible:(BOOL)visible relativeToView:(UIView *)view withDelay:(NSTimeInterval)delay
{
  if ((!self.titleText || !self.titleText.length)
      || visible == !self.isHidden
      ) {
    if (self.shouldDebug) DLog(@"Guarded: Empty text or redundant toggling.");
    return NO;
  }
  //-- Step 2 / 3.
  void (^teardown)(void) = ^{
    [self teardownForScreenView:view];
  };
  //-- Step 1.
  if (visible) {
    [self setupForScreenView:view];
    [self fadeInTo:1.0f withDelay:delay andCompletion:^{
      //-- Step 2.
      if (self.shouldAutoDismiss) {
        [self fadeOutTo:0.0f withDelay:self.autoDismissDuration andCompletion:teardown];
      }
    }];
  } else {
    [self fadeOutTo:0.0f withDelay:delay andCompletion:teardown];
  }
  return YES;
}

+ (NSTimeInterval)standardPresentDelay
{
  return 0.5f;
}

#pragma mark - Private

- (void)setupForScreenView:(UIView *)view
{
  self.screenView = view;
  //-- Setup layout.
  //-- Centers by default.
  self.center = view.realCenter;
  self.width = MIN(self.width, view.width); //-- Constrain to container.
  //-- Snap to edge.
  CGSize size = view.bounds.size;
  if (self.positionDirection & UAFDirectionUp || self.positionDirection & UAFDirectionLeft) {
    self.top = self.edgeOffset;
  } else if (self.positionDirection & UAFDirectionDown || self.positionDirection & UAFDirectionRight) {
    self.bottom = size.height - self.edgeOffset;
  }
  //-- Commit.
  [view addSubview:self];
}

- (void)teardownForScreenView:(UIView *)view
{
  [self removeFromSuperview];
}

- (void)resetOptions
{
  for (NSString *keyPath in defaultOptions) {
    [self setValue:defaultOptions[keyPath] forKeyPath:keyPath];
  }
}

#pragma mark - Singleton

+ (void)initialize
{
  static BOOL initialized = NO;
  if (!initialized) {
    initialized = YES;
    toastView = [UAFToastView new];
  }
}

+ (UAFToastView *)sharedView
{
  if (toastView.isHidden) {
    [toastView resetOptions];
  }
  return toastView;
}

@end