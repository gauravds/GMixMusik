//
//  MP3FileModel.h
//  GMixMusik
//
//  Created by gauravds on 5/7/15.
//  Copyright (c) 2015 SoftEx Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MP3FileModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic) BOOL isDownloadingCompleted;
@property (nonatomic, weak) UIProgressView *progressView;

- (instancetype)initWithTitle:(NSString*)title1
                       andURL:(NSURL*)url1;
@end
