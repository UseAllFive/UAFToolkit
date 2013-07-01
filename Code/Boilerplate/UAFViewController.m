//
//  UAFViewController.m
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import "UAFViewController.h"

@implementation UAFViewController

//-- UAFNavigationItem
@synthesize previousNavigationItemIdentifier, nextNavigationItemIdentifier;
@synthesize customNavigationController;
@synthesize customIsBeingPresented, customIsBeingDismissed;

//-- UAFObject
@synthesize shouldDebug;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self _commonInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self _commonInit];
  }
  return self;
}

- (id)init
{
  self = [super init];
  if (self) {
    [self _commonInit];
  }
  return self;
}

#pragma mark - UAFObject

- (void)_commonInit {}

@end
