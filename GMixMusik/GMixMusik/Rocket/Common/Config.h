//
//  Config.h
//  
//
//  Created by GDS on 23/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "GSFont.h"

#define DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define kClientIDSoundCloud @"4346c8125f4f5c40ad666bacd8e96498"
#define kAPIURLSearchSoundCloud @"https://api.soundcloud.com/tracks?client_id=%@&q=%@"
#define kAPIURLStreamSoundCloud @"http://api.soundcloud.com/tracks/%@/stream?client_id=%@"


//HelveticaNeue-BoldItalic,
//HelveticaNeue-Light,
//HelveticaNeue-UltraLightItalic,
//HelveticaNeue-CondensedBold,
//HelveticaNeue-MediumItalic,
//HelveticaNeue-Thin,
//HelveticaNeue-Medium,
//HelveticaNeue-ThinItalic,
//HelveticaNeue-LightItalic,
//HelveticaNeue-UltraLight,
//HelveticaNeue-Bold,
//HelveticaNeue,
//HelveticaNeue-CondensedBlack


#define UIFontAppFontRegularSize(s) [UIFont fontWithName:@"HelveticaNeue" size:s]

#define UIFontAppFontITSize(s) [UIFont fontWithName:@"HelveticaNeue-MediumItalic" size:s]

#define UIFontAppFontLightSize(s) [UIFont fontWithName:@"HelveticaNeue-Light" size:s]

#define UIFontAppFontBoldSize(s) [UIFont fontWithName:@"HelveticaNeue-Bold" size:s]

#define UIFontAppFontSemiboldSize(s) [UIFont fontWithName:@"HelveticaNeue-Medium" size:s]


#define IS_iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_iPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define APPDELEGATE ((AppDelegate*)[[UIApplication sharedApplication]delegate])

#define pr(nsString,args...) pt(nsString,args);
#define pro(object)     pt(@"%@",object);


@interface Config : NSObject {

    
}

//configuration section...
extern  NSString            *SiteAPIURL;


extern AppDelegate *appDelegate;
extern UIWindow *mainWindow;
extern UIStoryboard *mainStoryBoard;
extern UITabBarController *tabBarController;
extern UINavigationController *navController;

extern NSString *appDeviceToken;

extern BOOL isBackgroundMode;

extern BOOL isDebuggerMode;


extern BOOL isUserLogin;

extern NSString *userID;

extern NSDictionary *userDict;

extern BOOL isDeviceInBackgroundMode;


// hud
extern MBProgressHUD *HUD;

void pt(NSString *format, ...);

@end
