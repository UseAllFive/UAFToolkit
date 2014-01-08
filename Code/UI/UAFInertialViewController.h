//
//  UAFInertialViewController.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <UIKit/UIKit.h>

/**
 Common protocol for view controllers whose views use physics-based animations.
 */
@protocol UAFInertialViewController <NSObject>

/**
 Allow the main view to go to the edge and then 'bounce' back, like in
 `UIScrollView`.
 */
@property (nonatomic) BOOL bounces;

@end
