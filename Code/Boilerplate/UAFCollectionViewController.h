//
//  UAFCollectionViewController.h
//  UAFToolkit
//
//  Created by Peng Wang on 6/20/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import <UIKit/UIKit.h>

#import "UAFObject.h"
#import "UAFNavigationItem.h"

@interface UAFCollectionViewController : UICollectionViewController

<UAFObject, UAFNavigationItem>

@end
