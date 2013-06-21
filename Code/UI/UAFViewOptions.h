//
//  UAFViewState.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

typedef NS_OPTIONS(NSUInteger, UAFViewState) {
  UAFViewStateInitial        = 0,
  UAFViewStateUpdatingLayout = 1 << 0,
  UAFViewStateUpdatingStyle  = 1 << 1,
  UAFViewStateAnimating      = 1 << 2,
  UAFViewStateAnimatingLoop  = 1 << 3,
};

typedef NS_OPTIONS(NSUInteger, UAFDirection) {
  UAFDirectionNone   = 0,
  UAFDirectionUp     = 1 << 0,
  UAFDirectionRight  = 1 << 1,
  UAFDirectionDown   = 1 << 2,
  UAFDirectionLeft   = 1 << 3,
};