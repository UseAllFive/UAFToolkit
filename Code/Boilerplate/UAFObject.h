//
//  UAFObject.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

@protocol UAFObject <NSObject>

/**
 Useful for when multiple constructors need to share common initialization
 logic. Default implementation does nothing.
 */
- (void)_commonInit;

@optional

/**
 Useful for when multiple constructors for views using nibs need to share common
 initialization logic. Default implementation does nothing.
 */
- (void)_commonAwake;

@optional

@property (nonatomic) BOOL didCommonInit;
@property (nonatomic) BOOL didCommonAwake;

@end