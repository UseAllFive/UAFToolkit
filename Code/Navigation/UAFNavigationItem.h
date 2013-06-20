//
//  UAFNavigationItem.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <UIKit/UIKit.h>

#import "UAFNavigationController.h"

@protocol UAFNavigationItem <NSObject>

@optional

@property (strong, nonatomic) NSString *previousNavigationItemIdentifier; //-- TODO: Finally: Think through design of this property.
@property (strong, nonatomic) NSString *nextNavigationItemIdentifier;

@property (weak, nonatomic) id<UAFNavigationController> customNavigationController;

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