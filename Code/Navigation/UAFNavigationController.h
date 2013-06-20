//
//  UAFNavigationController.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/19/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <UIKit/UIKit.h>

#ifndef UAF_NAVIGATION
#define UAF_NAVIGATION
#endif

extern const NSTimeInterval kUAFNavigationDurationNone;

typedef NS_ENUM(NSUInteger, UAFNavigationDirection) {
  UAFNavigationDirectionNone,
  UAFNavigationDirectionHorizontal,
  UAFNavigationDirectionVertical,
};

@protocol UAFNavigationControllerDelegate, UAFPagingNavigationControllerDelegate;

@protocol UAFNavigationController <NSObject>

@property (weak, nonatomic) id<UAFNavigationControllerDelegate> delegate;

@property (nonatomic) UAFNavigationDirection baseNavigationDirection;
@property (nonatomic) UAFNavigationDirection onceNavigationDirection;

@property (nonatomic) NSTimeInterval baseNavigationDuration;
@property (nonatomic) NSTimeInterval onceNavigationDuration;

- (BOOL)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (BOOL)popViewControllerAnimated:(BOOL)animated;
- (BOOL)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (BOOL)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;

@optional

@property (strong, nonatomic, readonly) UIViewController *topViewController;
@property (strong, nonatomic, readonly) UIViewController *visibleViewController;
@property (strong, nonatomic, readonly) NSArray *viewControllers;

@property (weak, nonatomic) id<UAFPagingNavigationControllerDelegate> pagingDelegate;
@property (nonatomic) BOOL pagingEnabled;

- (BOOL)pushViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated;
- (BOOL)popToViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated;

- (BOOL)pushViewController:(UIViewController *)viewController animated:(BOOL)animated focused:(BOOL)focused;
- (BOOL)pushViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated focused:(BOOL)focused;

- (BOOL)popViewControllerAnimated:(BOOL)animated focused:(BOOL)focused;

- (BOOL)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated focused:(BOOL)focused;

- (BOOL)handleRemovalRequestForViewController:(UIViewController *)viewController;

@end

@protocol UAFNavigationControllerDelegate <NSObject>

@optional

//-- Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)customNavigationController:(id<UAFNavigationController>)navigationController
            willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)customNavigationController:(id<UAFNavigationController>)navigationController
             didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

@protocol UAFPagingNavigationControllerDelegate <NSObject>

- (UIViewController *)customNavigationController:(id<UAFNavigationController>)navigationController
              viewControllerBeforeViewController:(UIViewController *)viewController;
- (UIViewController *)customNavigationController:(id<UAFNavigationController>)navigationController
               viewControllerAfterViewController:(UIViewController *)viewController;

@end