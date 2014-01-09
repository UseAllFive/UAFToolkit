//
//  UAFObject.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

@protocol UAFObject <NSObject>

/**
 Every object has a debug flag. It's up to its implementation what the debug
 flag actually controls. Most libraries will cease most loggin if the flag is
 off.
 */
@property (nonatomic) BOOL shouldDebug;

@optional

/**
 Useful for when multiple constructors need to share common initialization
 logic. Default implementation does nothing.
 */
- (void)_commonInit;

/**
 Useful for when multiple constructors for views using nibs need to share common
 initialization logic. Default implementation does nothing.
 */
- (void)_commonAwake;

@optional

/**
 Flag for guarding redundant inits. Useful for singletons.
 */
@property (nonatomic) BOOL didCommonInit;
/**
 Flag for guarding redundant awakes. Useful for singletons.
 */
@property (nonatomic) BOOL didCommonAwake;

@end