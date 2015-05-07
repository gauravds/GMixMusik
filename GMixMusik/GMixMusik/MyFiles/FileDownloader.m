//
//  FileDownloader.m
//  GMixMusik
//
//  Created by gauravds on 5/7/15.
//  Copyright (c) 2015 SoftEx Lab. All rights reserved.
//

#import "FileDownloader.h"
#define TMP NSTemporaryDirectory()

@interface FileDownloader() {
    NSMutableArray *arrayDownload;
    NSMutableData *fileData;
    MP3FileModel *downloading;
    NSUInteger indexDownloading;
    BOOL shouldStart;
}
@end

@implementation FileDownloader
+ (instancetype)sharedReference {
    static FileDownloader *fileDownloader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileDownloader = [[FileDownloader alloc] init];
    });
    return fileDownloader;
}
- (instancetype)init {
    if (self = [super init]) {
        arrayDownload = [NSMutableArray new];
        indexDownloading = -1;
        shouldStart = YES;
    }
    return self;
}

- (void)addFileToDownload:(MP3FileModel*)mp3File {
    if (mp3File) {
        pro(@"adding")
        [arrayDownload addObject:mp3File];
        [self startDownloading];
    }
}

- (void)startDownloading {
    pro(@"gds wait")
    if (shouldStart) {
        downloading = [self getNextDownling];
        pro(downloading);
        if (!downloading) {
            return;
        }
        shouldStart = NO;
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:downloading.url];
        NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:req
                                                               delegate:self
                                                       startImmediately:NO];
        [con scheduleInRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSRunLoopCommonModes];
        [con start];
        if (con) {
            fileData = [NSMutableData new];
        } else {
            pro(@"connection is NULL");
        }
    }
}

- (MP3FileModel*)getNextDownling {
    if (indexDownloading >= arrayDownload.count) {
        indexDownloading = -1;
    }
    
    for (indexDownloading++; indexDownloading < arrayDownload.count; indexDownloading++) {
        MP3FileModel *mp3FileModel = arrayDownload[indexDownloading];
        if (!mp3FileModel.isDownloadingCompleted) {
            return mp3FileModel;
        }
    }
    
    indexDownloading = -1;
    [arrayDownload removeAllObjects];
    return nil;
}


#pragma mark - NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
    [fileData setLength:0];
    pro(@"downloading started");
}
- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {
    pro(@"downloading...");
    [fileData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    pro(@"downloading error");
    [self startNext];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [fileData writeToFile:[self getUniquePath:downloading.title] atomically:YES];
    downloading.isDownloadingCompleted = YES;
    pro(@"downloading completed.");
    [self startNext];
}

- (NSString*)getUniquePath:(NSString*)name {
    NSMutableString *tempImgUrlStr = [name mutableCopy];
    [tempImgUrlStr replaceOccurrencesOfString:@"/" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempImgUrlStr length])];
    [tempImgUrlStr replaceOccurrencesOfString:@" " withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempImgUrlStr length])];
    // Generate a unique path to a resource representing the image you want
    NSString *filename = [NSString stringWithFormat:@"%@.mp3",tempImgUrlStr] ;
    // [[something unique, perhaps the image name]];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    pro(uniquePath);
    return uniquePath;
}

- (void)startNext {
    fileData = nil;
    shouldStart = YES;
    [self startDownloading];
}

@end
