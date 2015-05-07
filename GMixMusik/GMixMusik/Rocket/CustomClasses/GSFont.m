//
//  GSFont.m
//  TradeApp
//
//  Created by Gaurav Sharma on 21/08/14.
//  Copyright (c) 2014 ___baltech___. All rights reserved.
//

#import "GSFont.h"

@implementation GSFont

// Returns a font using CSS name matching semantics.
+ (UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize{
    if (IS_iPad) {
        fontSize = fontSize*2;
    }
    return [UIFont fontWithName:fontName size:fontSize];
}

@end
