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
@property (nonatomic) NSTimeInterval baseNavigationDuration;

- (BOOL)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (BOOL)popViewControllerAnimated:(BOOL)animated;
- (BOOL)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (BOOL)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;

@optional

//-- TODO: Eventually: Bad idea. Should be removed (with refactoring).
@property (nonatomic) UAFNavigationDirection onceNavigationDirection;
@property (nonatomic) NSTimeInterval onceNavigationDuration;

@property (weak, nonatomic, readonly) UIViewController *topViewController;
@property (weak, nonatomic, readonly) UIViewController *visibleViewController;
@property (weak, nonatomic, readonly) UIViewController *previousViewController;
@property (weak, nonatomic, readonly) UIViewController *nextViewController;
@property (weak, nonatomic, readonly) NSArray *viewControllers;

@property (weak, nonatomic) id<UAFPagingNavigationControllerDelegate> pagingDelegate;
@property (nonatomic) BOOL pagingEnabled;

@property (nonatomic) BOOL shouldUpdatePresentationFlags;

- (BOOL)pushViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated;
- (BOOL)popToViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated;

- (BOOL)pushViewController:(UIViewController *)viewController animated:(BOOL)animated focused:(BOOL)focused;
- (BOOL)pushViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated focused:(BOOL)focused;

- (BOOL)popViewControllerAnimated:(BOOL)animated focused:(BOOL)focused;

- (BOOL)pushViewController:(id)viewController animated:(BOOL)animated completion:(void(^)(void))completion;
- (BOOL)popToViewController:(id)viewController animated:(BOOL)animated completion:(void(^)(void))completion;
- (BOOL)popViewControllerAnimated:(BOOL)animated completion:(void(^)(void))completion;

- (BOOL)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated focused:(BOOL)focused;

- (BOOL)handleRemovalRequestForViewController:(UIViewController *)viewController;

@end

@protocol UAFNavigationControllerDelegate <NSObject>

@optional

//-- Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)customNavigationController:(id<UAFNavigationController>)navigationController
             willAddViewController:(UIViewController *)viewController;
- (void)customNavigationController:(id<UAFNavigationController>)navigationController
           removeAddViewController:(UIViewController *)viewController;
- (void)customNavigationController:(id<UAFNavigationController>)navigationController
            willShowViewController:(UIViewController *)viewController animated:(BOOL)animated dismissed:(BOOL)dismissed;
- (void)customNavigationController:(id<UAFNavigationController>)navigationController
             didShowViewController:(UIViewController *)viewController animated:(BOOL)animated dismissed:(BOOL)dismissed;
- (void)customNavigationController:(id<UAFNavigationController>)navigationController
            willHideViewController:(UIViewController *)viewController animated:(BOOL)animated dismissed:(BOOL)dismissed;
- (void)customNavigationController:(id<UAFNavigationController>)navigationController
             didHideViewController:(UIViewController *)viewController animated:(BOOL)animated dismissed:(BOOL)dismissed;

- (BOOL)customNavigationController:(id<UAFNavigationController>)navigationController
    shouldNavigateToViewController:(UIViewController *)viewController;

- (NSArray *)customNavigationControllerSubviewsToSupportInteractiveNavigation:(id<UAFNavigationController>)navigationController;

@end

@protocol UAFPagingNavigationControllerDelegate <NSObject>

- (UIViewController *)customNavigationController:(id<UAFNavigationController>)navigationController
              viewControllerBeforeViewController:(UIViewController *)viewController;
- (UIViewController *)customNavigationController:(id<UAFNavigationController>)navigationController
               viewControllerAfterViewController:(UIViewController *)viewController;

@optional

- (BOOL)customNavigationControllerShouldNotifyOfPossibleViewAppearanceChange:(id<UAFNavigationController>)navigationController;

@end
