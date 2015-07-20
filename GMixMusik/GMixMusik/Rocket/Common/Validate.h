//
//  Validate.h
//  GiftMail
//
//  Created by Shivam on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validate : NSObject
{
  
}

+ (BOOL)isNull:(NSString*)str;
+ (BOOL)isValidEmailId:(NSString*)email;
+ (BOOL)isValidCreditCardNumber:(NSString*)number;
+ (BOOL)isValidCCV:(NSString*)number;
+ (BOOL)isNumber:(NSString*)number;
+ (BOOL)isValidMobileNumber:(NSString*)number;
+ (BOOL) isValidUserName:(NSString*)userName;
+ (BOOL) isValidPassword:(NSString*)password;
+ (BOOL) isValidName:(NSString*)name;

@end
