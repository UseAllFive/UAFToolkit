//
//  NSBundle+UAFAdditions.m
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. See license.
//

#import "NSBundle+UAFAdditions.h"

@implementation NSBundle (UAFAdditions)

+ (NSBundle *)UAFBundle {
	static NSBundle *UAFBundle = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"UAFResources.bundle"];
		UAFBundle = [[NSBundle alloc] initWithPath:bundlePath];
	});
	return UAFBundle;
}

@end
