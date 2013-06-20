//
//  UAFCollectionReusableView.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAFObject.h"
#ifdef UAF_VIEW_STATE
#import "UAFViewState.h"
#endif
@interface UAFCollectionReusableView : UICollectionReusableView

<UAFObject>

#ifdef UAF_VIEW_STATE
@property (nonatomic) UAFViewState viewState;
#endif

@end