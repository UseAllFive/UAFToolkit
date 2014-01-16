//
//  NSDictionary+UAFAdditions.m
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012-2014 UseAllFive. See license.
//

#import "NSDictionary+UAFAdditions.h"

@interface NSDictionary (UAFPrivateAdditions)
- (NSData *)_prehashData;
@end

@implementation NSDictionary (UAFAdditions)

+ (NSDictionary *)dictionaryWithFormEncodedString:(NSString *)encodedString {
	if (!encodedString) {
		return nil;
	}
	
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	NSArray *pairs = [encodedString componentsSeparatedByString:@"&"];
	
	for (NSString *kvp in pairs) {
		if ([kvp length] == 0) {
			continue;
		}
		
		NSRange pos = [kvp rangeOfString:@"="];
		NSString *key;
		NSString *val;
		
		if (pos.location == NSNotFound) {
			key = [kvp stringByUnescapingFromURLQuery];
			val = @"";
		} else {
			key = [[kvp substringToIndex:pos.location] stringByUnescapingFromURLQuery];
			val = [[kvp substringFromIndex:pos.location + pos.length] stringByUnescapingFromURLQuery];
		}
		
		if (!key || !val) {
			continue; // I'm sure this will bite my arse one day
		}
		
		[result setObject:val forKey:key];
	}
	return result;
}

- (NSString *)stringWithFormEncodedComponents {
	NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:[self count]];
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
		[arguments addObject:[NSString stringWithFormat:@"%@=%@",
                          [key stringByEscapingForURLQuery],
                          [[object description] stringByEscapingForURLQuery]]];
	}];
	
	return [arguments componentsJoinedByString:@"&"];
}

- (NSMutableDictionary *)deepMutableCopy {
	return (__bridge_transfer NSMutableDictionary *)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (__bridge CFDictionaryRef)self, kCFPropertyListMutableContainers);
}

- (NSString *)MD5Sum {
	return [[self _prehashData] MD5Sum];
}

- (NSString *)SHA1Sum {
	return [[self _prehashData] SHA1Sum];
}

@end

@implementation NSDictionary (UAFPrivateAdditions)

- (NSData *)_prehashData {
	return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];
}

@end
