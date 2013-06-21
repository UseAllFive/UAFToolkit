//
//  UICollectionViewFlowLayout+UAFAdditions_RegularLayout.m
//  UAFToolkit
//
//  Created by Peng Wang on 6/21/13.
//  Copyright (c) 2013 UseAllFive. All rights reserved.
//

#import "UICollectionViewFlowLayout+UAFAdditions_RegularLayout.h"

@implementation UICollectionViewFlowLayout (UAFAdditions_RegularLayout)

+ (void)calculateLayoutAttributes:(id<UAFCollectionViewLayoutAttributes>)attributes forOrientation:(UIInterfaceOrientation)orientation
{
  BOOL isLandscape;
  CGSize screenSize;
  UIScreen *screen = [UIScreen mainScreen];
  if (orientation == 0) {
    isLandscape = UIInterfaceOrientationIsLandscape(screen.currentOrientation);
    screenSize = screen.currentBounds.size;
  } else {
    isLandscape = UIInterfaceOrientationIsLandscape(orientation);
    screenSize = [screen boundsForOrientation:orientation].size;
  }
  Class attributesClass = [attributes class];
  attributes.numberOfColumns = [attributesClass numberOfColumnsWhenIsLandscape:isLandscape];
  CGFloat itemSize = floorf((screenSize.width - (attributes.numberOfColumns + 1) * attributes.gutter) /
                            attributes.numberOfColumns);
  attributes.itemSize = CGSizeMake(itemSize, itemSize);
}

@end
