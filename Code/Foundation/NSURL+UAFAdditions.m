//
//  NSURL+UAFAdditions.m
//  UAFToolkit
//
//  Created by Peng Wang on 7/23/12.
//  Copyright (c) 2012 UseAllFive. See license.
//

#import "NSURL+UAFAdditions.h"
#import "NSDictionary+UAFAdditions.h"

@implementation NSURL (UAFAdditions)

+ (id)URLWithFormat:(NSString *)format, ... {
	va_list arguments;
  va_start(arguments, format);
	NSString *string = [[NSString alloc] initWithFormat:format arguments:arguments];
	va_end(arguments);
	
	return [NSURL URLWithString:string];
}

- (NSDictionary *)queryDictionary {
  return [NSDictionary dictionaryWithFormEncodedString:self.query];
}

@end
