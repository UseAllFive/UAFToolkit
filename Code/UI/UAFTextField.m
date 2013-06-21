//
//  UAFTextField.m
//  UAFToolkit
//
//  Created by Peng Wang on 1/29/13.
//  Copyright (c) 2013 UseAllFive. See license.
//

#import "UAFTextField.h"

@interface UAFTextField ()

- (void)_initialize;

@end

@implementation UAFTextField

#pragma mark - Accessors

@synthesize textEdgeInsets = _textEdgeInsets;
@synthesize clearButtonEdgeInsets = _clearButtonEdgeInsets;
@synthesize placeholderTextColor = _placeholderTextColor;

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
	_placeholderTextColor = placeholderTextColor;
	
	if (!self.text && self.placeholder) {
		[self setNeedsDisplay];
	}
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    [self _initialize];
  }
  return self;
}


- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self _initialize];
  }
  return self;
}


#pragma mark - UITextField

- (CGRect)textRectForBounds:(CGRect)bounds {
	return UIEdgeInsetsInsetRect([super textRectForBounds:bounds], _textEdgeInsets);
}


- (CGRect)editingRectForBounds:(CGRect)bounds {
	return [self textRectForBounds:bounds];
}


- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
	CGRect rect = [super clearButtonRectForBounds:bounds];
	rect = CGRectSetY(rect, rect.origin.y + _clearButtonEdgeInsets.top);
	return CGRectSetX(rect, rect.origin.x + _clearButtonEdgeInsets.right);
}


- (void)drawPlaceholderInRect:(CGRect)rect {
	if (!_placeholderTextColor) {
		[super drawPlaceholderInRect:rect];
		return;
	}
	
  [_placeholderTextColor setFill];
  [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
  if (!self.canPerformAnyAction) {
    [self resignFirstResponder]; // Don't select anything.
    //DLog("%@", self.gestureRecognizers);
    self.didResignFirstResponderOnSelect = YES;
    [self.delegate textFieldDidEndEditing:self];
    self.didResignFirstResponderOnSelect = NO;
  }
  return self.canPerformAnyAction;
}

#pragma mark - Private

- (void)_initialize {
	_textEdgeInsets = UIEdgeInsetsZero;
	_clearButtonEdgeInsets = UIEdgeInsetsZero;
  self.canPerformAnyAction = YES;
}

@end
