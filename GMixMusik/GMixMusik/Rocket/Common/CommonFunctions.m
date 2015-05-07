//
//  CommonFunctions.m
//
//
//  Created by GDS on 23/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "CommonFunctions.h"
#import "ImgCache.h"
#import "AppDelegate.h"
#import "GPImage.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIImage+RoundedCorner.h"
#import "Validate.h"
#import <CommonCrypto/CommonDigest.h>


@implementation CommonFunctions



#pragma mark - user session
+(BOOL)isUserLogin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSDictionary *dict = [userDefaults objectForKey:@"userDict"];
    
//    pr(@"userdeflt===  %@",[userDefaults objectForKey:@"userDict"]);
    if (dict) {
        userID = dict[@"userId"];
        
        if ( userID  && ![Validate isNull:userID] )
        {
            isUserLogin = YES;
            userDict = dict;
            return YES;
        }
    }
    
    userID = @"0";
    userDict = nil;
    
    isUserLogin = NO;
    
    return NO;
}

+ (BOOL)userLoginDetail:(NSDictionary*)userDict1{
    if (userDict1 == nil) {
        return NO;
    }
    
    // set SESSION for user
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userDict1 forKey:@"userDict"];
    [userDefaults synchronize];
    userID = userDict1[@"userId"];
    userDict = userDict1;
    isUserLogin = YES;

//    pr(@"userdefault=== %@",[userDefaults objectForKey:@"userDict"]);
    return YES;
}
+ (NSString*)getUserID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    pr(@"userdeflt===  %@",[userDefaults objectForKey:@"userDict"]);
    NSString *userIDTemp = [[userDefaults objectForKey:@"userDict"] objectForKey:@"userId"];
    if ( userIDTemp  && ![Validate isNull:userIDTemp] )
    {
        return userIDTemp;
    }
    
    return @"0";
}

+ (NSString*)getEmailID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    pr(@"userdeflt===  %@",[userDefaults objectForKey:@"userDict"]);
    NSString *emailID = [[userDefaults objectForKey:@"userDict"] objectForKey:@"emailId"];
    if ( emailID  && ![Validate isNull:emailID] )
    {
        return emailID;
    }
    
    return @"";
}

+ (NSDictionary*)userDetailFromUserDefaults{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userDict = [userDefaults objectForKey:@"userDict"];
    pr(@"USER DEFAULT user  detail userDict ===  %@",userDict);
    
    return userDict;
}

+ (void)userLogout{
    //RESET THE DEFAULT USER THUS SESSION LOGOUT
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    //    [defs removeObjectForKey:@"username"];
    [defs removeObjectForKey:@"userDict"];
    //    [defs removeObjectForKey:@"userLoginWithFacebook"];
    [defs synchronize];
    
    isUserLogin = NO;
    
    userDict = nil;
}

+ (void)removeAllUserDefault{
    // remove all user default
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
    isUserLogin = NO;
}

#pragma mark- navigation bar back btn
// Make Custom back button for Navigation Bar
+(UIBarButtonItem*) getBackBtn{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] init];
    leftBarButton.target = self;
    leftBarButton.action = @selector(BackBtnPressed);
    leftBarButton.tintColor = [UIColor blackColor];
    [leftBarButton setImage:[UIImage imageNamed:@"btn-back"]];
	return leftBarButton;
}
+(void)BackBtnPressed{
    if (!navController)
    {
        return;
    }
    
    [navController popViewControllerAnimated:YES];
}

#pragma mark - Time and Date format change
+ (NSDate*)convertStringToDateTimeStyle:(NSString*)oldTimeStyle
                               newStyle:(NSString*)newTimeStyle
                        withOrignalDate:(NSString*)date{
    
    //    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //    dateFormatter.dateFormat = oldTimeStyle;
    //    NSDate *yourDate = [dateFormatter dateFromString:date];
    //    dateFormatter.dateFormat = newTimeStyle;
    //    return [dateFormatter stringFromDate:yourDate];
    
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = oldTimeStyle;
    NSDate *yourDate = [dateFormatter dateFromString:date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    //calc time difference
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:yourDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:yourDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    //set current real date
    NSDate *newdate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:yourDate];
    dateFormatter.dateFormat = newTimeStyle;
    return newdate;
}

+ (NSString*)convertTimeStyle:(NSString*)oldTimeStyle
                     newStyle:(NSString*)newTimeStyle
              withOrignalDate:(NSString*)date{

//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = oldTimeStyle;
//    NSDate *yourDate = [dateFormatter dateFromString:date];
//    dateFormatter.dateFormat = newTimeStyle;
//    return [dateFormatter stringFromDate:yourDate];
    
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = oldTimeStyle;
    NSDate *yourDate = [dateFormatter dateFromString:date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    //calc time difference
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:yourDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:yourDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    //set current real date
    NSDate *newdate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:yourDate];
    dateFormatter.dateFormat = newTimeStyle;
    NSString *dateToReturn = [dateFormatter stringFromDate:newdate];

    return [dateToReturn uppercaseString];
}

+ (NSString*)getDateFormated:(NSString*)date{
    return [self convertTimeStyle:@"yyyy-MM-dd HH:mm:ss" newStyle:@"MMM dd, yyyy" withOrignalDate:date];
}
+ (NSString*)getDateFormatedWithTime:(NSString*)date {
    return [self convertTimeStyle:@"yyyy-MM-dd HH:mm:ss" newStyle:@"MMM dd, yyyy hh:mm a" withOrignalDate:date];
}

+ (NSString*)getCurrentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

#pragma mark -
//Default document paths
+ (NSString *)documentsDirectory {
    NSArray *paths =
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
										NSUserDomainMask,
										YES);
    return [paths objectAtIndex:0];
}

// Open application methods
+ (void)openEmail:(NSString *)address {
    NSString *url = [NSString stringWithFormat:@"mailto://%@", address];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    /*
    // if opening in web view use this code
    // web view delegates
    - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
        if ([[[request URL] scheme] isEqual:@"mailto"]) {
            [[UIApplication sharedApplication] openURL:[request URL]];
            return NO;
        }
        return YES;
    }
    */
}

+ (void)openPhone:(NSString *)number {
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *url = [NSString stringWithFormat:@"tel://%@", number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openSms:(NSString *)number {
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *url = [NSString stringWithFormat:@"sms://%@", number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openBrowser:(NSString *)url {
    if ([Validate isNull:url])
    {
        return;
    }
    
    if (![url hasPrefix:@"http"] && ![url hasPrefix:@"https"] ) {
        url = [NSString stringWithFormat:@"http://%@",url];
    }
    NSString *escaped = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
}

+ (void)openMap:(NSString *)address {
	NSString *addressText = [address stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", addressText];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}



// Custom tab bar
+ (void) hideTabBar:(UITabBarController *) tabbarcontroller {
	
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.0];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
		if([view isKindOfClass:[UITabBar class]])
        {
			[view setFrame:CGRectMake(view.frame.origin.x, window.frame.size.height, view.frame.size.width, view.frame.size.height)];
        }
		else
		{
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, window.frame.size.height)];
        }
		
    }
	
    [UIView commitAnimations];
	
}
// Tab bar custmize
+ (void) showTabBar:(UITabBarController *) tabbarcontroller {
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.0];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
//        pr(@"%@", view);
		
        if([view isKindOfClass:[UITabBar class]])
        {
			[view setFrame:CGRectMake(view.frame.origin.x, window.frame.size.height-49, view.frame.size.width, view.frame.size.height)];
			
        }
		else
		{
			[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, window.frame.size.height-49)];
        }
		
		
    }
	
    [UIView commitAnimations];
	
}



// set UITextField to be center of UISrollView pass the textFiled and scrollView obj as arguments
+ (void)scrollViewToCenterOfScreen:(UIView *)theView onScrollView:(UIScrollView *) scrollview {
    
	
	CGFloat viewCenterY = theView.center.y;
	CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
	CGFloat availableHeight = applicationFrame.size.height - 216;            // Remove area covered by keyboard
    
	CGFloat y = viewCenterY - availableHeight / 2.0;
	if (y < 0) {
		y = 0;
	}
	[scrollview setContentOffset:CGPointMake(0, y) animated:YES];
    
}


+(void) becomeNextFirstResponder:(UIView*)vc :(UITextField*)textField{
	
	NSMutableArray *arr1=[[NSMutableArray alloc] init];
	BOOL isFound=NO;
    
	for(UIView *tf in [vc subviews])
	{
		if([tf isKindOfClass:[UITextField class]] && ((UITextField*)tf).enabled  && ((UITextField*)tf).hidden==NO)
		{
			[arr1 addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:((UITextField*)tf).frame.origin.y	], @"y", ((UITextField*)tf), @"obj", nil]];
		}
	}
	NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"y"
																 ascending:YES];
    
    
	NSArray	*sortDescriptors = [NSArray arrayWithObject:sortByName];
	arr1 = [[arr1 sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
	for(NSMutableDictionary *dic in arr1){
		UITextField *tf=[dic valueForKey:@"obj"];
		if (isFound) {
			[tf becomeFirstResponder];
			break;
		}
		if (textField == tf) {
			isFound=YES;
			[textField resignFirstResponder];
            if ([vc isKindOfClass:[UIScrollView class]]) {
                [(UIScrollView*)vc setContentOffset:CGPointMake(0, 0) animated:YES];
            }
		}
	}
}
+ (void)serverInternalError {
    [self AlertWithMsg:@"We are facing server internal error, please try again later"];
}

+(void)showServerNotFoundError{
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Cannot communicate with server"
                                                          message:@"We are currently having trouble connecting to our server. Please make sure you are able to connect to the internet. Thank you!"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
            [alert show];
        });
    } else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Cannot communicate with server"
                                                      message:@"We are currently having trouble connecting to our server. Please make sure you are able to connect to the internet. Thank you!"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [alert show];
        
    }
}
+ (void) AlertWithMsg:(NSString*)msg{
    [self AlertTitle:@"GMix Musik" withMsg:msg];
}
+ (void) AlertWithMsg:(NSString*)msg andDelegate:(id)delegate{
    [self AlertTitle:@"GMix Musik" withMsg:msg andDelegate:delegate];
}

+(void) AlertTitle:(NSString*)title withMsg:(NSString*)msg{
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [[[UIAlertView alloc] initWithTitle:title
                                        message:msg
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil] show];
            
        });
    } else {
        
        [[[UIAlertView alloc] initWithTitle:title
                                    message:msg
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
        
        
    }
}

+(void) AlertTitle:(NSString*)title withMsg:(NSString*)msg andDelegate:(id)delegate{
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:title
                                        message:msg
                                       delegate:delegate
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil] show];
        });
    } else {
        [[[UIAlertView alloc] initWithTitle:title
                                    message:msg
                                   delegate:delegate
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
        
    }
}


+ (BOOL)isNetworkConnect{
    if ([UIDevice networkAvailable]){
		return YES;
	}
    
    // if there is no network
//    [[[UIAlertView alloc] initWithTitle:@"Network Problem"
//                                message:@"You are not connected to the network!"
//                               delegate:nil
//                      cancelButtonTitle:@"Cancel"
//                      otherButtonTitles:nil] show];
    return NO;
}

+ (BOOL)isValueNotEmpty:(NSString*)aString{
    if (aString == nil || [aString length] == 0){
        [CommonFunctions AlertTitle:@"Server Response Error"
                            withMsg:@"Please try again, server is not responding."];
        return NO;
    }
    return YES;
}

+ (BOOL)handelOpenUrl:(NSString*)url{
    if (url) {
        NSString *messageID = [[url substringFromIndex:([url rangeOfString:@"://" options:NSBackwardsSearch].location+3)] stringByRemovingNewLinesAndWhitespace];
        
        pr(@"Message id %@",messageID);
        //[CommonFunctions AlertTitle:messageID withMsg:nil];
        
//        AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
//        UINavigationController *navController = (UINavigationController*) [[appDelegate window] rootViewController];
//        HomeViewController *hvc = [HomeViewController new];
//        HomeViewController *mdvc = [HomeViewController new];
        //        mdvc.messageID = messageID;
        
//        navController.viewControllers = [NSArray arrayWithObject:hvc];
//        
//        [CommonFunctions pushViewController:mdvc];
        
        return YES;
    }
    return NO;
}

+ (void)setBadgeNumber:(NSUInteger)totalBedgeNumber{
    
    UIApplication *application = [UIApplication sharedApplication];
    
    application.applicationIconBadgeNumber = totalBedgeNumber;
    
}

+ (void)increaseBadgeNumber{
    UIApplication *application = [UIApplication sharedApplication];
    
    application.applicationIconBadgeNumber += 1;
}

+ (void)decreaseBadgeNumber{
    UIApplication *application = [UIApplication sharedApplication];
    
    application.applicationIconBadgeNumber -= 1;
}


// for base 64 encode decode
static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

+ (NSString *)decodeBase64WithStringToString:(NSString *)strBase64{
    if (![CommonFunctions decodeBase64WithString:strBase64]) {
        return @"";
    }
    return [NSString stringWithUTF8String:[[CommonFunctions decodeBase64WithString:strBase64] bytes]];
}

+ (NSData *)decodeBase64WithString:(NSString *)strBase64 {
    const char * objPointer = [strBase64 cStringUsingEncoding:NSASCIIStringEncoding];
    NSInteger intLength = strlen(objPointer);
    int intCurrent;
    int i = 0, j = 0, k;
    
    unsigned char * objResult;
    objResult = calloc(intLength, sizeof(unsigned char));
    
    // Run through the whole string, converting as we go
    while ( ((intCurrent = *objPointer++) != '\0') && (intLength-- > 0) ) {
        if (intCurrent == '=') {
            if (*objPointer != '=' && ((i % 4) == 1)) {// || (intLength > 0)) {
                // the padding character is invalid at this point -- so this entire string is invalid
                free(objResult);
                return nil;
            }
            continue;
        }
        
        intCurrent = _base64DecodingTable[intCurrent];
        if (intCurrent == -1) {
            // we're at a whitespace -- simply skip over
            continue;
        } else if (intCurrent == -2) {
            // we're at an invalid character
            pr(@"exit string %s",objResult);
            free(objResult);
            return nil;
        }
        
        switch (i % 4) {
            case 0:
                objResult[j] = intCurrent << 2;
                break;
                
            case 1:
                objResult[j++] |= intCurrent >> 4;
                objResult[j] = (intCurrent & 0x0f) << 4;
                break;
                
            case 2:
                objResult[j++] |= intCurrent >>2;
                objResult[j] = (intCurrent & 0x03) << 6;
                break;
                
            case 3:
                objResult[j++] |= intCurrent;
                break;
        }
        i++;
    }
    
    // mop things up if we ended on a boundary
    k = j;
    if (intCurrent == '=') {
        switch (i % 4) {
            case 1:
                // Invalid state
                free(objResult);
                return nil;
                
            case 2:
                k++;
                // flow through
            case 3:
                objResult[k] = 0;
        }
    }
    
    // Cleanup and setup the return NSData
    NSData * objData = [[NSData alloc] initWithBytes:objResult length:j];
    free(objResult);
    return objData;
}
+ (NSString *)encodeBase64WithString:(NSString *)strData {
    if (![CommonFunctions encodeBase64WithData:strData]) {
        return @"";
    }
    return [NSString stringWithUTF8String:[[CommonFunctions encodeBase64WithData:strData] bytes]];

}

+ (NSData*)encodeBase64WithData:(NSString *)strBase64 {
    const char * objRawData = [strBase64 cStringUsingEncoding:NSASCIIStringEncoding];;
    
    // Get the Raw Data length and ensure we actually have data
    NSUInteger intLength = strlen(objRawData);
    
    if (intLength == 0) return nil;
    
    unsigned char * objPointer;
    unsigned char * strResult;
    
    // Setup the String-based Result placeholder and pointer within that placeholder
    strResult = (unsigned char *)calloc((((intLength + 2) / 3) * 4) + 1, sizeof(unsigned char));
    objPointer = strResult;
    
    // Iterate through everything
    while (intLength > 2) { // keep going until we have less than 24 bits
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
        *objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
        *objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
        // we just handled 3 octets (24 bits) of data
        objRawData += 3;
        intLength -= 3;
    }
    
    // now deal with the tail end of things
    if (intLength != 0) {
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        if (intLength > 1) {
            *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
            *objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    
    // Terminate the string-based result
    *objPointer = '\0';
    
    // Return the results as an NSString object
    NSData * objData = [[NSData alloc] initWithBytes:strResult length:strlen(objRawData)];
    free(strResult);
    return objData;
//    return [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
}

// view shaker
+ (void)shakeView:(UIView *)viewToShake{
    CGFloat t = 5.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft   = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat
                     animations:^{[UIView setAnimationRepeatCount:2.0];
                         viewToShake.transform = translateRight;}
                     completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05
                                  delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{viewToShake.transform = CGAffineTransformIdentity;}
                             completion:NULL];
        }
    }];
}

+ (void)vibrate{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (void) setNetworkActivityIndicatorVisible:(BOOL)setVisible {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:setVisible];
}

+ (NSString*)md5:(NSString*)str {
    NSString *salt = @"passwdIs";
    NSString *strWithSalt = [NSString stringWithFormat:@"%@%@",str,salt];
    const char *cStr = [strWithSalt UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG) strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
}



#pragma mark - design
//+ (void)designLable:(UILabel*)lblDynamic {
//    lblDynamic.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    lblDynamic.layer.borderWidth = 0.5;
//    
//    [lblDynamic setFont:UIFontSourceSansProSemiboldSize(15.0f)];
//    [lblDynamic setBackgroundColor:[UIColor whiteColor]];
//    [lblDynamic setTextColor:UIColorFromRGB(0x827f7f)];
//}
//
//+ (void)designTextField:(UITextField*)txtField {
//    [txtField setTextColor:UIColorFromRGB(0xb0b0b0)];
//    [txtField setFont:UIFontSourceSansProRegularSize(15.0f)];
//    [txtField setBackgroundColor:[UIColor clearColor]];
////    txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email"
////                                                                     attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xb0b0b0)}];
//}





+ (void)fireLocalNotification:(NSString*)msg  {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // current time plus 10 secs
    NSDate *now = [NSDate date];
    NSDate *dateToFire = [now dateByAddingTimeInterval:2];
    
    pr(@"now time: %@", now);
    pr(@"fire time: %@", dateToFire);
    
    localNotification.fireDate = dateToFire;
    localNotification.alertBody = msg;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    NSDictionary *infoDict = @{@"msg":msg};
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}



+ (UIImage*)getCurrentScreenShot {
    
    UIWindow *window = [(AppDelegate*)[[UIApplication sharedApplication] delegate] window];
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    
    else
        
        UIGraphicsBeginImageContext(window.bounds.size);
    
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
