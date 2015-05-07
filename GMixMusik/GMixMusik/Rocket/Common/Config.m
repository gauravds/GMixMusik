//
//  Config.M
//  
//
//  Created by GDS on 23/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.



#import "Config.h"  

@implementation Config


NSString *SiteAPIURL = @"http://cloudcl.apptesting.info/admin/h2odavis/";


AppDelegate *appDelegate;
UIWindow *mainWindow;
UIStoryboard *mainStoryBoard;
UITabBarController *tabBarController;
UINavigationController *navController;

NSString *appDeviceToken = @"123";

BOOL isBackgroundMode = NO;

BOOL isDebuggerMode = NO;

BOOL isUserLogin = NO;

NSString *userID = @"0";

NSDictionary *userDict = nil;


BOOL isDeviceInBackgroundMode = NO;

// HUD
MBProgressHUD *HUD = nil;


void pt(NSString *format, ...) {
    if (isDebuggerMode) {
        va_list args;
        va_start(args, format);
        NSLogv(format, args);
        va_end(args);
    }
}

@end