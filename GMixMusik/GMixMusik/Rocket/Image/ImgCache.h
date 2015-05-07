//
//  ImgCache.h
//  
//
//  Created by GDS on 23/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//
 

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImgCache : NSObject {
	
}

// Methods
- (void) cacheImage: (NSString *) ImageURLString;
- (UIImage *) getCachedImage: (NSString *) ImageURLString;
- (void) removeFromCache:(NSString *) ImageURLString;

@end