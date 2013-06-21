//
//  UIScreen+UAFAdditions.m
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. See license.
//

#import "UIScreen+UAFAdditions.h"

#import "UIView+UAFAdditions.h"
#import "UAFDrawingUtilities.h"

@implementation UIScreen (UAFAdditions)

#pragma mark - Accessing the Bounds

- (CGRect)currentBounds {
	return [self currentBounds:YES];
}

- (CGRect)currentBounds:(BOOL)fullScreen {
  return [self boundsForOrientation:self.currentOrientation fullScreen:fullScreen];
}

- (UIInterfaceOrientation)currentOrientation {
  return [[UIApplication sharedApplication] statusBarOrientation];
}

- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation {
  return [self boundsForOrientation:orientation fullScreen:YES];
}
- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation fullScreen:(BOOL)fullScreen {
	CGRect bounds = [self bounds];
  BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
	if (isLandscape) {
		bounds = [UIView flipRect:bounds];
	}
  if (!fullScreen) {
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    if (isLandscape) {
      statusBarFrame = [UIView flipRect:statusBarFrame];
    }
    bounds = CGRectSetHeight(bounds, bounds.size.height - statusBarFrame.size.height);
  }
	return bounds;
}

+ (CGRect)keyboardBoundsForNotification:(NSNotification *)notification
{
  CGRect keyboardBounds = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  if (keyboardBounds.size.height > keyboardBounds.size.width) {
    keyboardBounds = [UIView flipRect:keyboardBounds];
  }
  return keyboardBounds;
}

#pragma mark - Screen Attributes

- (BOOL)isRetinaDisplay {
	static dispatch_once_t predicate;
	static BOOL answer;
  
	dispatch_once(&predicate, ^{
		answer = ([self respondsToSelector:@selector(scale)] && [self scale] == 2);
	});
	return answer;
}

@end
