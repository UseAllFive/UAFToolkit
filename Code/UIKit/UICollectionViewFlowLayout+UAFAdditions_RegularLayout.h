//
//  UICollectionViewFlowLayout+UAFAdditions_RegularLayout.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/21/13.
//  Copyright (c) 2013 UseAllFive. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UAFCollectionViewLayoutAttributes.h"
#import "UIScreen+UAFAdditions.h"

#import "UAFDebugUtilities.h"

/**
 Mainly integration with <UAFCollectionViewLayoutAttributes>.
 */
@interface UICollectionViewFlowLayout (UAFAdditions_RegularLayout)

/**
 Abstraction for deriving orientation-friendly layout attributes based on given
 attributes.
 
 Given attributes should be:
 
 - <[UAFCollectionViewLayoutAttributes numberOfColumnsWhenIsLandscape:]>.
 
 Derived attributes can then be simply piped out of the attributes'
 <UICollectionViewDelegateFlowLayout> methods.
 @param attributes <UAFCollectionViewLayoutAttributes> implementation.
 @param orientation A device orientation.
 @note Layout will be calculated based on the gutters as 'struts' and the
 item-sizes as 'springs'.
 */
+ (void)calculateLayoutAttributes:(id<UAFCollectionViewLayoutAttributes>)attributes
                   forOrientation:(UIInterfaceOrientation)orientation;

@end

