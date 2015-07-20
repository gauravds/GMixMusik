//
//  MP3FileModel.m
//  GMixMusik
//
//  Created by gauravds on 5/7/15.
//  Copyright (c) 2015 SoftEx Lab. All rights reserved.
//

#import "MP3FileModel.h"

@implementation MP3FileModel
@synthesize title, url, isDownloadingCompleted, progressView;
- (instancetype)initWithTitle:(NSString*)title1
                       andURL:(NSURL*)url1 {
    if (self = [super init]) {
        self.title = title1;
        self.url = url1;
        self.isDownloadingCompleted = NO;
    }
    return self;
}
@end
