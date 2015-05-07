

#import <UIKit/UIKit.h>
#import <netinet/in.h>
@protocol ReachabilityWatcher <NSObject>
- (void) reachabilityChanged;
@end

@interface UIDevice (Reachability)
+ (NSString *) stringFromAddress: (const struct sockaddr *) address;
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address;

+ (NSString *) hostname;
+ (NSString *) getIPAddressForHost: (NSString *) theHost;
+ (NSString *) localIPAddress;
+ (NSString *) localWiFiIPAddress;
+ (NSString *) whatismyipdotcom;

+ (BOOL) hostAvailable: (NSString *) theHost;
+ (BOOL) networkAvailable;
+ (BOOL) activeWLAN;
+ (BOOL) activeWWAN;
+ (BOOL) performWiFiCheck;

+ (BOOL) scheduleReachabilityWatcher: (id) watcher;
+ (void) unscheduleReachabilityWatcher;
@end