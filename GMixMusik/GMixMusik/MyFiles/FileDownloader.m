//
//  FileDownloader.m
//  GMixMusik
//
//  Created by gauravds on 5/7/15.
//  Copyright (c) 2015 SoftEx Lab. All rights reserved.
//

#import "FileDownloader.h"
@import AVKit;
@import AVFoundation;
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
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSData *data = [NSData dataWithContentsOfURL:mp3File.url];
//            if (data) {
//                [data writeToFile:[self getUniquePath:mp3File.title] atomically:YES];
//            }
//        });
        
//        [arrayDownload addObject:mp3File];
        downloading = mp3File;
        [self startDownloading];
    }
}

- (void)startDownloading {
    pro(@"gds wait")
//    if (shouldStart) {
//        downloading = [self getNextDownling];
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
//    }
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
    NSString *localPath = [self getUniquePath:downloading.title];
    [fileData writeToFile:localPath atomically:YES];
    [CommonFunctions AlertWithMsg:@"Downloading completed"];
 /*
//    CMTime nextClipStartTime = kCMTimeZero;
    //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
    AVMutableComposition *composition = [[AVMutableComposition alloc] init];
    
    AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionAudioTrack setPreferredVolume:0.8];
    NSString *soundOne  =[[NSBundle mainBundle] pathForResource:@"test1" ofType:@"caf"];
    NSURL *url = [NSURL fileURLWithPath:soundOne];
    AVAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *tracks = [avAsset tracksWithMediaType:AVMediaTypeAudio];
    AVAssetTrack *clipAudioTrack = [[avAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, avAsset.duration) ofTrack:clipAudioTrack atTime:kCMTimeZero error:nil];
    
    
//    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
//    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
//                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
////    [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration))
//                        ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
//    AVAsset *avasset = [[AVAsset alloc] init];
//    avasset.
//    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
//                                                                      presetName:AVAssetExportPresetHighestQuality];
//    exporter.outputURL=url;
//    exporter.outputFileType = AVMediaTypeAudio;
//    exporter.shouldOptimizeForNetworkUse = YES;
//    [exporter exportAsynchronouslyWithCompletionHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            downloading.isDownloadingCompleted = YES;
//            pro(@"downloading completed.");
//            [self startNext];
//        });
//    }];
    
    
    AVAssetExportSession *exportSession = [AVAssetExportSession
                                           exportSessionWithAsset:composition
                                           presetName:AVAssetExportPresetAppleM4A];
    if (nil == exportSession) return;
   
    
    // configure export session  output with all our parameters
    exportSession.outputURL = [NSURL fileURLWithPath:localPath]; // output path
    exportSession.outputFileType = AVFileTypeAppleM4A; // output file type
    
    // perform the export
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        if (AVAssetExportSessionStatusCompleted == exportSession.status) {
            NSLog(@"AVAssetExportSessionStatusCompleted");
        } else if (AVAssetExportSessionStatusFailed == exportSession.status) {
            // a failure may happen because of an event out of your control
            // for example, an interruption like a phone call comming in
            // make sure and handle this case appropriately
            NSLog(@"AVAssetExportSessionStatusFailed");
        } else {
            NSLog(@"Export Session Status: %ld", (long)exportSession.status);
        }
    }];
    
//    AVAssetWriterInput* videoWriterInput = [[AVAssetWriterInput
//                                             assetWriterInputWithMediaType:
//                                             AVMediaTypeAudio
//                                             outputSettings:videoSettings] retain];
    

    */
    
}

- (NSString*)getUniquePath:(NSString*)name {
    NSMutableString *tempImgUrlStr = [name mutableCopy];
    [tempImgUrlStr replaceOccurrencesOfString:@"/" withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempImgUrlStr length])];
    [tempImgUrlStr replaceOccurrencesOfString:@" " withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempImgUrlStr length])];
    // Generate a unique path to a resource representing the image you want
    NSString *filename = [NSString stringWithFormat:@"last.mp3"];//@"%@.mp3",tempImgUrlStr] ;
    // [[something unique, perhaps the image name]];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    pro(uniquePath);
    return uniquePath;
}

- (void)startNext {
    fileData = nil;
    shouldStart = YES;
//    [self startDownloading];
}

@end
