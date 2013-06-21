//
//  UAFCollectionViewLayoutAttributes.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/21/13.
//  Copyright (c) 2013 UseAllFive. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Models an extended set of attributes on top of a flow-layout delegate
 (collection-view-controller) for a standard grid-based layout. This helps
 standardize and dry collection-view flow-layout logic. Works directly with
 <[UICollectionViewFlowLayout(UAFAdditions_[StyleOf]Layout)
 calculateLayoutAttributes:forOrientation:]>.
 */
@protocol UAFCollectionViewLayoutAttributes <UICollectionViewDelegateFlowLayout>

/**
 Helper value. More for internal uses.
 */
@property (nonatomic) NSUInteger numberOfColumns;
/**
 The collection-view-cell size. For integrating with
 <UICollectionViewDelegateFlowLayout> methods.
 */
@property (nonatomic) CGSize itemSize;
/**
 The gutter size. For integrating with <UICollectionViewDelegateFlowLayout>
 methods.
 */
@property (nonatomic) CGFloat gutter;
/**
 Desired columns for the given orientation.
 @param isLandscape Is device orientation landscape.
 */
+ (NSUInteger)numberOfColumnsWhenIsLandscape:(BOOL)isLandscape;

@optional
/**
 Collection-view-cell size. If not implemented, please set a <gutter> size.
 @param isLandscape Is device orientation landscape.
 */
+ (CGSize)itemSizeWhenIsLandscape:(BOOL)isLandscape;

@end
