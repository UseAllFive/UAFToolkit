//
//  UAFViewState.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#ifndef UAF_VIEW_STATE
#define UAF_VIEW_STATE
#endif

typedef NS_OPTIONS(NSUInteger, UAFViewState) {
  UAFViewStateInitial        = 0,
  UAFViewStateUpdatingLayout = 1 << 0,
  UAFViewStateUpdatingStyle  = 1 << 1,
  UAFViewStateAnimatingLoop  = 1 << 2,
};
