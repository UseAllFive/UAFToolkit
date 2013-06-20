//
//  UIScreen+UAFAdditions.m
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. All rights reserved.
//

#import "UIScreen+UAFAdditions.h"

#import "UIView+UAFAdditions.h"

@implementation UIScreen (UAFAdditions)

#pragma mark - Accessing the Bounds

- (CGRect)currentBounds {
	return [self boundsForOrientation:[self currentOrientation]];
}

- (UIInterfaceOrientation)currentOrientation {
  return [[UIApplication sharedApplication] statusBarOrientation];
}

- (BOOL)isLandscape {
  return UIInterfaceOrientationIsLandscape([self currentOrientation]);
}

- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation {
	CGRect bounds = [self bounds];
  
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		CGFloat buffer = bounds.size.width;
    
		bounds.size.width = bounds.size.height;
		bounds.size.height = buffer;
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
