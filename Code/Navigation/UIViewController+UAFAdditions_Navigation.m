//
//  UIViewController+UAFAdditions_Navigation.m
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. All rights reserved.
//

#import "UIViewController+UAFAdditions_Navigation.h"

@implementation UIViewController (UAFAdditions_Navigation)

- (void)dismissViewController:(UIViewController *)viewController animated:(BOOL)flag completion:(void (^)(void))completion path:(NSIndexPath *)indexPath userInfo:(NSDictionary *)userInfo
{
  if (indexPath && [self conformsToProtocol:@protocol(UAFNavigationItem)]) {
    [(id)self viewWillAppearFromDismissalOfModalViewControllerOfClass:viewController.class withNavigationPath:indexPath andUserInfo:userInfo];
  }
  [self dismissViewControllerAnimated:flag completion:completion];
}

@end
