//
//  UIViewController+UAFAdditions.m
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. All rights reserved.
//

#import "UIViewController+UAFAdditions.h"

#import "UIScrollView+UAFAdditions.h"

@implementation UIViewController (UAFAdditions)

#pragma mark - Boilerplate.

- (void)commonInit {}
- (void)commonAwake {}

#pragma mark - UAFKeyboardResizing

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

#pragma mark - Traversal

- (UIViewController *)rootPresentingViewController {
  UIViewController *rootController = self.presentingViewController;
  while (![rootController isKindOfClass:[UINavigationController class]]
         && rootController.presentingViewController
         ) {
    rootController = rootController.presentingViewController;
  }
  if ([rootController isKindOfClass:[UINavigationController class]]) {
    rootController = [(id)rootController topViewController];
  }
  return rootController;
}

- (void)dismissViewController:(UIViewController *)viewController animated:(BOOL)flag completion:(void (^)(void))completion path:(NSIndexPath *)indexPath userInfo:(NSDictionary *)userInfo
{
  if (indexPath && [self conformsToProtocol:@protocol(UAFModalNavigation)]) {
    [(id)self viewWillAppearFromDismissalOfModalViewControllerOfClass:viewController.class withNavigationPath:indexPath andUserInfo:userInfo];
  }
  [self dismissViewControllerAnimated:flag completion:completion];
}

#pragma mark - Sam Soffes

- (void)displayError:(NSError *)error {
	if (!error) {
		return;
	}
	
	[self displayErrorString:[error localizedDescription]];
}

- (void)displayErrorString:(NSString *)string {
	if (!string || [string length] < 1) {
		return;
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

@end
