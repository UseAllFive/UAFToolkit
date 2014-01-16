//
//  UIControl+UAFAdditions.m
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012-2014 UseAllFive. See license.
//

#import "UIControl+UAFAdditions.h"

@implementation UIControl (UAFAdditions)

- (void)removeAllTargets {
	[[self allTargets] enumerateObjectsUsingBlock:^(id object, BOOL *stop) {
		[self removeTarget:object action:NULL forControlEvents:UIControlEventAllEvents];
	}];
}

@end
