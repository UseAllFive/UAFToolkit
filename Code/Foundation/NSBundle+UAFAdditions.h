//
//  NSBundle+UAFAdditions.h
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. All rights reserved.
//

#define UAFLocalizedString(key) [[NSBundle UAFBundle] localizedStringForKey:(key) value:@"" table:@"UAF"]

@interface NSBundle (UAFAdditions)

+ (NSBundle *)UAFBundle;

@end
