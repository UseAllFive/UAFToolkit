//
//  NSBundle+UAFAdditions.h
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012-2013UseAllFive. See license.
//

#define UAFLocalizedString(key) [[NSBundle UAFBundle] localizedStringForKey:(key) value:@"" table:@"UAF"]

@interface NSBundle (UAFAdditions)

+ (NSBundle *)UAFBundle;

@end
