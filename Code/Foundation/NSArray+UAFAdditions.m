//
//  NSArray+UAFAdditions.m
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. All rights reserved.
//

#import "NSArray+UAFAdditions.h"
#import "NSData+UAFAdditions.h"

@interface NSArray (UAFPrivateAdditions)

- (NSData *)_prehashData;

@end

@implementation NSArray (UAFAdditions)

- (NSArray *)pluckValuesForKey:(NSString *)key
{
  NSMutableArray *result = [NSMutableArray array];
  for (NSDictionary *object in self) {
    [result addObject:[object valueForKeyPath:key]];
  }
  return result;
}

- (id)firstObject {
	if ([self count] == 0) {
	  return nil;
	}
	
	return [self objectAtIndex:0];
}

- (id)randomObject {
	return [self objectAtIndex:arc4random() % [self count]];
}

- (NSArray *)shuffledArray {
	
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
	
	NSMutableArray *copy = [self mutableCopy];
	while ([copy count] > 0) {
		NSUInteger index = arc4random() % [copy count];
		id objectToMove = [copy objectAtIndex:index];
		[array addObject:objectToMove];
		[copy removeObjectAtIndex:index];
	}
	
	return array;
}

- (NSMutableArray *)deepMutableCopy {
	return (__bridge_transfer NSMutableArray *)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (__bridge CFArrayRef)self, kCFPropertyListMutableContainers);
}

- (NSString *)MD5Sum {
	return [[self _prehashData] MD5Sum];
}

- (NSString *)SHA1Sum {
	return [[self _prehashData] SHA1Sum];
}

@end

@implementation NSArray (UAFPrivateAdditions)

- (NSData *)_prehashData {
	return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];
}

@end
