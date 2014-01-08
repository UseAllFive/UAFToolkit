//
//  UAFViewController.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <UIKit/UIKit.h>

#import "UAFObject.h"
#import "UAFNavigationItem.h"

/**
 Custom base `UIViewController` that offers conveniences: implementation of
 `UAFObject`. Also implements `UAFNavigationItem` to support being used inside
 custom navigation controllers.
 */
@interface UAFViewController : UIViewController

<UAFObject, UAFNavigationItem>

@end
