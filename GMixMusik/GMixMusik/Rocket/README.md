#Intro
I'm Gaurav D. Sharma, creator of this rapid development environment i.e. Rocket. Well I know it should use pods, but at initial level it's ok. For other updates visit http://gauravds.blogspot.in. Voila!

# Rocket
iOS Rapid Development Environment : Rocket


Group of lots of methods for rapid development of iOS App.

CommonFunction.h [static methods]
+ (BOOL)isUserLogin;
+ (BOOL)userLoginDetail:(NSDictionary*)userDict;
+ (NSString*)getUserID;
+ (NSString*)getEmailID;
+ (NSDictionary*)userDetailFromUserDefaults;
+ (void)userLogout;
+ (void)removeAllUserDefault;
+(UIBarButtonItem*)getBackBtn;
+(void)BackBtnPressed;
+ (NSDate*)convertStringToDateTimeStyle:(NSString*)oldTimeStyle
newStyle:(NSString*)newTimeStyle
withOrignalDate:(NSString*)date;
+ (NSString*)convertTimeStyle:(NSString*)oldTimeStyle
newStyle:(NSString*)newTimeStyle
withOrignalDate:(NSString*)date;
+ (NSString*)getDateFormated:(NSString*)date;
+ (NSString*)getDateFormatedWithTime:(NSString*)date;
+ (NSString*)getCurrentDate;
+ (NSString *)documentsDirectory;
+ (void)openEmail:(NSString *)address;
+ (void)openPhone:(NSString *)number;
+ (void)openSms:(NSString *)number;
+ (void)openBrowser:(NSString *)url;
+ (void)openMap:(NSString *)address;
+ (void) hideTabBar:(UITabBarController *) tabbarcontroller;
+ (void) showTabBar:(UITabBarController *) tabbarcontroller;
+ (void)scrollViewToCenterOfScreen:(UIView *)theView onScrollView:(UIScrollView *) scrollview;
+ (void) becomeNextFirstResponder:(UIView*)vc :(UITextField*)textField;
// Alert View
+ (void)serverInternalError;
+(void)showServerNotFoundError;
+ (void) AlertWithMsg:(NSString*)msg;
+ (void) AlertWithMsg:(NSString*)msg andDelegate:(id)delegate;
+(void) AlertTitle:(NSString*)title withMsg:(NSString*)msg;
+(void) AlertTitle:(NSString*)title withMsg:(NSString*)msg andDelegate:(id)delegate;
// check that network available or not
+ (BOOL)isNetworkConnect;
//check that server is resonse is null or not
+ (BOOL)isValueNotEmpty:(NSString*)aString;
// handel open url for this app
+ (BOOL)handelOpenUrl:(NSString*)url;
// badge number set and increase decrease
+ (void)setBadgeNumber:(NSUInteger)totalBedgeNumber;
+ (void)increaseBadgeNumber;
+ (void)decreaseBadgeNumber;
// for base 64 converter
+ (NSString *)decodeBase64WithStringToString:(NSString *)strBase64;
+ (NSData *)decodeBase64WithString:(NSString *)strBase64;
+ (NSString *)encodeBase64WithString:(NSString *)strData;
+ (NSData*)encodeBase64WithData:(NSString *)strBase64 ;
// view shaker
+ (void)shakeView:(UIView *)viewToShake;
+ (void)vibrate;
// show network activity indicator
+ (void) setNetworkActivityIndicatorVisible:(BOOL)setVisible;
+ (NSString*)md5:(NSString*)str;
// design
//+ (void)designLable:(UILabel*)lblDynamic;
//+ (void)designTextField:(UITextField*)txtField;
+ (void)fireLocalNotification:(NSString*)msg;
+ (UIImage*)getCurrentScreenShot;


Config.h
Presetup for app.

Validate.h
+ (BOOL)isNull:(NSString*)str;
+ (BOOL)isValidEmailId:(NSString*)email;
+ (BOOL)isValidCreditCardNumber:(NSString*)number;
+ (BOOL)isValidCCV:(NSString*)number;
+ (BOOL)isNumber:(NSString*)number;
+ (BOOL)isValidMobileNumber:(NSString*)number;
+ (BOOL) isValidUserName:(NSString*)userName;
+ (BOOL) isValidPassword:(NSString*)password;
+ (BOOL) isValidName:(NSString*)name;

GPImageView

GPImage

MyScrollView

GSFont

ContactData

ImagePickerViewController



MBProcessHUD

AsyncImageView 1.5

JVFloatTextField

FMDB

HTML+NSString

DXPopover

UIImage+ImageEffect

FXBlurView: Use UIImage+ImageEffect instead of FXBlurView

DropDownListView [like Android]
