//
//  UAFCollectionReusableView.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <UIKit/UIKit.h>

#import "UAFObject.h"
#import "UAFViewOptions.h"

@interface UAFCollectionReusableView : UICollectionReusableView

<UAFObject>

@property (nonatomic) UAFViewState viewState;

@end