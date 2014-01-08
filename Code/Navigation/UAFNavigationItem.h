//
//  UAFNavigationItem.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <UIKit/UIKit.h>

#import "UAFNavigationController.h"

/**
 A common protocol for items representing custom navigation child controllers.
 It includes the delegate protocol, so the navigation item is automatically a
 navigation controller delegate and can manage its own navigation controller,
 for nested navigation hierarchies.
 
 It also further enhances the navigation controller's ability to be non-linear
 if ever needed. See <previousNavigationItemIdentifier>,
 <nextNavigationItemIdentifier>, and <navigationStateInfo>
 */
@protocol UAFNavigationItem <UAFNavigationControllerDelegate>

@optional

/**
 The navigation item can optionally know its previous sibling's ID, so its
 navigation controller can automatically pop to it, or properly replace the
 current previous sibling with the requested one.
 */
@property (strong, nonatomic) NSString *previousNavigationItemIdentifier; //-- TODO: Finally: Think through design of this property.
/**
 The navigation item can optionally know its next sibling's ID, so its
 navigation controller can automatically, preemptively push it, or properly
 replace the current next sibling with the requested one.
 */
@property (strong, nonatomic) NSString *nextNavigationItemIdentifier;

/**
 The navigation item can keep reference to its navigation controller, much like
 how it does with its `navigationController`, which is already reserved as a
 `UINavigationController`.
 */
@property (weak, nonatomic) id<UAFNavigationController> customNavigationController;

/**
 Custom presentation flag much like `isBeingPresented`. Managed by the
 navigation controller. Avoid setting this manually otherwise.
 @note Requires implementing <customIsBeingDismissed>.
 */
@property (nonatomic) BOOL customIsBeingPresented;
/**
 Custom presentation flag much like `isBeingDismissed`. Managed by the
 navigation controller. Avoid setting this manually otherwise.
 @note Requires implementing <customIsBeingPresented>.
 */
@property (nonatomic) BOOL customIsBeingDismissed;

/**
 The navigation item can optionally provide a state information that can be used
 deterministically to restore state to its represented view controller. This
 usually requires providing data associated with the view controller.
 @note Use this when possible, and only use
 <viewWillAppearFromDismissalOfModalViewControllerOfClass:withNavigationPath:andUserInfo:>
 as needed.
 */
@property (strong, nonatomic, readonly, getter = navigationStateInfo) NSDictionary *navigationStateInfo;

/**
 Hook for when a presented modal view-controller dismisses itself while sending
 state.

 For a view-controller that wants to maintain the state of modal
 view-controllers it presents. Intended to work with
 <[UIViewController(UAFAdditions) rootPresentingViewController]>. It is up to
 each view-controller to decide how to store and restore the state data.
 
 For a view-controller that wants to dismiss while sending state,
 <[UIViewController(UAFAdditions_Navigation)
 dismissViewController:animated:completion:path:userInfo:]> should be used, as
 that calls
 <viewWillAppearFromDismissalOfModalViewControllerOfClass:withNavigationPath:andUserInfo:>.

 @param aClass The class of the dismissed view-controller.
 @param indexPath Model path for the view-controller's state. Depends on the
 view-controller.
 @param userInfo Additional information. Depends on the view-controller.
 */
- (void)viewWillAppearFromDismissalOfModalViewControllerOfClass:(Class)aClass
                                             withNavigationPath:(NSIndexPath *)indexPath
                                                    andUserInfo:(NSDictionary *)userInfo;

@end