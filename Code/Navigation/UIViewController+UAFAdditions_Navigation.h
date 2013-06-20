//
//  UIViewController+UAFAdditions_Navigation.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UAFNavigationItem.h"

@interface UIViewController (UAFAdditions_Navigation)

/**
 Wraps around `[UIViewController dismissViewControllerAnimated:completion:]`.
 Calls <[UAFNavigationItem
 viewWillAppearFromDismissalOfModalViewControllerOfClass:withNavigationPath:andUserInfo:]>
 if possible.
 @param viewController The presented view-controller.
 @param flag Animated. `NO` makes transition immediate.
 @param completion Callback.
 @param indexPath Model path for the view-controller's state. Depends on the
 view-controller.
 @param userInfo Additional information. Depends on the view-controller.
 */
- (void)dismissViewController:(UIViewController *)viewController
                     animated:(BOOL)flag completion:(void (^)(void))completion
                         path:(NSIndexPath *)indexPath userInfo:(NSDictionary *)userInfo;

@end
