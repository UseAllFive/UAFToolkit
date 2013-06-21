//
//  UIControl+UAFAdditions.h
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012-2013UseAllFive. See license.
//

#import <UIKit/UIKit.h>

/**
 Provides extensions to `UIControl` for various common tasks.
 */
@interface UIControl (UAFAdditions)

/**
 Removes all targets and actions for all events from an internal dispatch table.
 */
- (void)removeAllTargets;

@end
