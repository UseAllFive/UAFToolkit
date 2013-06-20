//
//  NSObject+UAFAdditions.h
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. All rights reserved.
//

@interface NSObject (UAFAdditions)

- (void)removeObserverAsNeeded:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context;

@end
