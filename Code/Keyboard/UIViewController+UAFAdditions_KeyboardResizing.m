//
//  UIViewController+UAFAdditions_KeyboardResizing.m
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. All rights reserved.
//

#import "UIViewController+UAFAdditions_KeyboardResizing.h"

#import "UAFDebugUtilities.h"

@implementation UIViewController (UAFAdditions_KeyboardResizing)

- (BOOL)setupResizingWithKeyboardForView:(UIScrollView *)view
{
  if (![self conformsToProtocol:@protocol(UAFKeyboardResizing)]) {
    DLog(@"GUARDED");
    return NO;
  }
  UIViewController<UAFKeyboardResizing> *controller = (UIViewController<UAFKeyboardResizing> *)self;
  if (!controller.keyboardResizingViews) {
    //-- Setup.
    controller.keyboardResizingViews = [NSMutableArray array];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  }
  if ([controller.keyboardResizingViews indexOfObject:view] != NSNotFound) {
    DLog(@"GUARDED");
    return NO;
  }
  //-- Update setup.
  [controller.keyboardResizingViews addObject:view];
  return YES;
}

- (BOOL)teardownResizingWithKeyboardForView:(UIScrollView *)view
{
  if (![self conformsToProtocol:@protocol(UAFKeyboardResizing)]) {
    DLog(@"GUARDED");
    return NO;
  }
  UIViewController<UAFKeyboardResizing> *controller = (UIViewController<UAFKeyboardResizing> *)self;
  if (!controller.keyboardResizingViews) {
    DLog(@"GUARDED");
    return NO;
  }
  if (controller.keyboardResizingViews.count == 0) {
    //-- Teardown.
    controller.keyboardResizingViews = nil;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
  } else {
    //-- Update teardown.
    [controller.keyboardResizingViews removeObject:view];
  }
  return YES;
}

- (void)keyboardDidShow:(NSNotification *)notification {
  UIViewController<UAFKeyboardResizing> *controller = (UIViewController<UAFKeyboardResizing> *)self;
  for (UIScrollView *view in controller.keyboardResizingViews) {
    [view keyboardDidShow:notification];
  }
  if ([controller respondsToSelector:@selector(setIsKeyboardVisible:)]) {
    controller.isKeyboardVisible = YES;
  }
}
- (void)keyboardWillHide:(NSNotification *)notification {
  UIViewController<UAFKeyboardResizing> *controller = (UIViewController<UAFKeyboardResizing> *)self;
  for (UIScrollView *view in controller.keyboardResizingViews) {
    [view keyboardWillHide:notification];
  }
  if ([controller respondsToSelector:@selector(setIsKeyboardVisible:)]) {
    controller.isKeyboardVisible = NO;
  }
}

@end
