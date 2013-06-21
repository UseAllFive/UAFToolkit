//
//  UAFActivityIndicatorDotsView.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/21/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "UAFView.h"
#import "UAFViewDynamics.h"
#import "UIView+UAFAdditions_Effects.h"

#import "UAFDebugUtilities.h"
#import "UAFDrawingUtilities.h"

@interface UAFActivityIndicatorDotsView : UAFView

<UAFToggledView>

@property (strong, nonatomic) UIColor *fillColor;
@property (nonatomic) CGFloat fromAlpha;
@property (nonatomic) CGFloat toAlpha;
@property (nonatomic) CGFloat gutterRatio;
@property (nonatomic) NSTimeInterval cycleDuration;

- (void)toggleToAnimating:(BOOL)animating;

@end
