//
//  FileDownloader.h
//  GMixMusik
//
//  Created by gauravds on 5/7/15.
//  Copyright (c) 2015 SoftEx Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MP3FileModel.h"

@interface FileDownloader : NSObject
+ (instancetype)sharedReference;

- (void)addFileToDownload:(MP3FileModel*)mp3File;
@end
