//
//  Validate.m
//  GiftMail
//
//  Created by Shivam on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Validate.h"
#import "NSString+HTML.h"

@implementation Validate

/**
 * Function name isNull                         
 *                                              
 * @params: NSString *str                       
 *                                              
 * @object: function to check a string to null  
 *
 * return BOOL
 */

+ (BOOL)isNull:(NSString*)str{
    str = [str trim];
	if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || str==nil) {
		return YES;
	}
	return NO;
}
/**
 * Function name isValidEmailId                
 *                                              
 * @params: NSString                            
 *                                              
 * @object: function to check a valid email id  
 *
 * return BOOL
 */
+ (BOOL)isValidEmailId:(NSString*)email
{
    if ([self isNull:email]) {
        return NO;
    }
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
	return [emailTest evaluateWithObject:email];
}

/**
 * Function name isValidCreditCardNumber
 *
 * @params: NSString
 *
 * @object: function to check a Number #
 *
 * return BOOL
 */
+ (BOOL)isValidCreditCardNumber:(NSString*)number
{
    if ([self isNull:number]) {
        return NO;
    }
    
    number=[number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([number length]<12 || [number length]>16) {
		return NO;
	}
	NSString *Regex = @"^([0-9]*)$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
	
    return [numberTest evaluateWithObject:number];
}
/**
 * Function name isValidCCV
 *
 * @params: NSString
 *
 * @object: function to check a Number #
 *
 * return BOOL
 */
+ (BOOL)isValidCCV:(NSString*)number
{
    if ([self isNull:number]) {
        return NO;
    }
    
    number=[number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([number length] != 3) {
		return NO;
	}
	NSString *Regex = @"^([0-9]*)$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
	
    return [numberTest evaluateWithObject:number];
}

/**
 * Function name isNumber
 *
 * @params: NSString
 *
 * @object: function to check a Number #
 *
 * return BOOL
 */
+ (BOOL)isNumber:(NSString*)number
{
    if ([self isNull:number]) {
        return NO;
    }
    
    number=[number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([number length]<1 || [number length]>17) {
		return NO;
	}
	NSString *Regex = @"^([0-9]*)$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
	
    return [numberTest evaluateWithObject:number];
}
/**
 * Function name isValidMobileNumber           
 *                                              
 * @params: NSString                            
 *                                              
 * @object: function to check a valid Mobile # 
 *
 * return BOOL
 */
+ (BOOL)isValidMobileNumber:(NSString*)number
{
    if ([self isNull:number]) {
        return NO;
    }
    
    number=[number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([number length]<5 || [number length]>17) {
		return FALSE;
	}
	NSString *Regex = @"^([0-9]*)$"; 
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex]; 
	
    return [mobileTest evaluateWithObject:number];
}
/**
 * Function name isValidUserName                
 *                                             
 * @params: NSString                            
 *                                              
 * @object: function to check a valid user name 
 *
 * return BOOL
 */
+ (BOOL) isValidUserName:(NSString*)userName{
    if ([self isNull:userName]) {
        return NO;
    }
    NSString *regex=@"^[a-zA-Z0-9_-]{5,10}$";
    NSPredicate *userNameTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [userNameTest evaluateWithObject:userName];
}
/**
 * Function name isValidPassword                
 *                                              
 * @params: NSString                            
 *                                              
 * @object: function to check a valid password 
 *
 * return BOOL
 */
+ (BOOL) isValidPassword:(NSString*)password{
    if ([self isNull:password]) {
        return NO;
    }
    NSString *regex=@"^.{5,15}$";
    NSPredicate *passwordTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [passwordTest evaluateWithObject:password];
}


+ (BOOL) isValidName:(NSString*)name{
    if ([self isNull:name]) {
        return NO;
    }
    NSString *regex=@"[a-zA-Z]+([ '-][a-zA-Z]+)*$";
    NSPredicate *nameTest=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [nameTest evaluateWithObject:name];
}
@end
