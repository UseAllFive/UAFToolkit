//
//  UAFCollectionViewCell.m
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. All rights reserved.
//

#import "UAFCollectionViewCell.h"

@implementation UAFCollectionViewCell

#ifdef UAF_VIEW_STATE
@synthesize viewState;
#endif

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
