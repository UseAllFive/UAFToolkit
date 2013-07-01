//
//  UAFScrollView.m
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import "UAFScrollView.h"

@implementation UAFScrollView

@synthesize viewState;

//-- UAFObject
@synthesize shouldDebug;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
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

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
  self = [super awakeAfterUsingCoder:aDecoder];
  if (self) {
    [self _commonAwake];
  }
  return self;
}
- (void)awakeFromNib
{
  [super awakeFromNib];
  [self _commonAwake];
}

#pragma mark - UAFObject

- (void)_commonInit {}
- (void)_commonAwake {}

@end
