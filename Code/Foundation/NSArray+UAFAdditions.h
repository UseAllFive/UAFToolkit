//
//  NSArray+UAFAdditions.h
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012-2014 UseAllFive. See license.
//

#import "NSData+UAFAdditions.h"

@interface NSArray (UAFAdditions)

///--------------
/// @name Parsing
///--------------

/**
 Extract a list of values for given property name from list of dictionaries /
 collections.
 @param key Property name.
 */
- (NSArray *)pluckValuesForKey:(NSString *)key;

///------------------------
/// @name Querying an Array
///------------------------

/**
 Returns the object in the array with the lowest index value.
 
 @return The object in the array with the lowest index value. If the array is empty, returns `nil`.
 */
- (id)firstObject;

/**
 Returns the object in the array with a random index value.
 
 @return The object in the array with a random index value. If the array is empty, returns `nil`.
 */
- (id)randomObject;

///--------------------------
/// @name Deriving New Arrays
///--------------------------

/**
 Returns a new array with its elements shuffled.
 
 @return A new array containing the receiving array's elements rearranged in a random order.
 */
- (NSArray *)shuffledArray;

/**
 Returns the object returned by `mutableCopyWithZone:` where the zone is `nil`.
 
 This differs from `mutableCopy` in that it makes any contained `NSArray` objects or `NSDictionary` objects mutable as
 well. The returned dictionary follows standard memory management conventions for copied objects. You are responsible
 for releasing it.
 
 @return The object returned by the `NSMutableCopying` protocol method `mutableCopyWithZone:`, where the zone is `nil`.
 */
- (NSMutableArray *)deepMutableCopy NS_RETURNS_RETAINED;

- (NSArray *)reversedArray;

///--------------
/// @name Hashing
///--------------

/**
 Returns a string of the MD5 sum of the receiver.
 
 @return The string of the MD5 sum of the receiver.
 
 Internally, `NSPropertyListSerialization` is used to created the hash. Only objects that can be serialized should be
 contained in the receiver when calling this method.
 */
- (NSString *)MD5Sum;

/**
 Returns a string of the SHA1 sum of the receiver.
 
 @return The string of the SHA1 sum of the receiver.
 
 Internally, `NSPropertyListSerialization` is used to created the hash. Only objects that can be serialized should be
 contained in the receiver when calling this method.
 */
- (NSString *)SHA1Sum;

@end
