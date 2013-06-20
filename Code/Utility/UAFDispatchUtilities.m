//
//  UAFDispatchUtilities.m
//  UAFToolkit
//
//  Created by Peng Wang on 5/29/13.
//  Copyright (c) 2013 UseAllFive. All rights reserved.
//

#import "UAFDispatchUtilities.h"

void UAFDispatchAfter(NSTimeInterval delayInSeconds, dispatch_block_t block)
{
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), block);
};
