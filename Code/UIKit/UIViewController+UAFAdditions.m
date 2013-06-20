//
//  UIViewController+UAFAdditions.m
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. See license.
//

#import "UIViewController+UAFAdditions.h"

@implementation UIViewController (UAFAdditions)

#pragma mark - Traversal

- (UIViewController *)rootPresentingViewController {
  UIViewController *rootController = self.presentingViewController;
  while (![rootController isKindOfClass:[UINavigationController class]]
         && rootController.presentingViewController
         ) {
    rootController = rootController.presentingViewController;
  }
  if ([rootController isKindOfClass:[UINavigationController class]]) {
    rootController = [(id)rootController topViewController];
  }
  return rootController;
}

#pragma mark - Sam Soffes

- (void)displayError:(NSError *)error {
	if (!error) {
		return;
	}
	
	[self displayErrorString:[error localizedDescription]];
}

- (void)displayErrorString:(NSString *)string {
	if (!string || [string length] < 1) {
		return;
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

@end
