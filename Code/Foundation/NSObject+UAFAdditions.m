//
//  NSObject+UAFAdditions.m
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. All rights reserved.
//

#import "NSObject+UAFAdditions.h"

@implementation NSObject (UAFAdditions)

- (void)removeObserverAsNeeded:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
  @try {
    [self removeObserver:observer forKeyPath:keyPath context:context];
  }
  @catch (NSException *exception) {
    if (exception.name != NSRangeException) {
      @throw exception;
    }
  }
}

@end
