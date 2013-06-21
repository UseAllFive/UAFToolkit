//
//  UIView+UAFAdditions_SFX.m
//  UAFToolkit
//
//  Created by Peng Wang on 6/21/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import "UIView+UAFAdditions_SFX.h"

#import "UAFUISoundController.h"

@implementation UIView (UAFAdditions_SFX)

+ (id)soundEffectPlayer
{
  return [UAFUISoundController sharedController];
}

@end
