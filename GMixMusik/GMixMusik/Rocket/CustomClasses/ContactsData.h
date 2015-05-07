//
//  ContactsData.h
//  TradeApp
//
//  Created by Balaji on 17/07/14.
//  Copyright (c) 2014 ___baltech___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContactsData : NSObject

@property (nonatomic,strong) NSString *firstNames,*lastNames;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSArray *numbers, *emails;

@end
