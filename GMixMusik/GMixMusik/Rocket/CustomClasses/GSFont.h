//
//  GSFont.h
//  TradeApp
//
//  Created by Gaurav Sharma on 21/08/14.
//  Copyright (c) 2014 ___baltech___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSFont : UIFont
// Returns a font using CSS name matching semantics.
+ (UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize;
@end
