//
//  HomeTableViewCell.m
//  GMixMusik
//
//  Created by gauravds on 5/7/15.
//  Copyright (c) 2015 SoftEx Lab. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

@synthesize imgView;
@synthesize lblTitle, lblSubtitle;
@synthesize btnDownload, btnPlay;
- (void)awakeFromNib {
    // Initialization code
    [imgView.layer setBorderWidth:0.5f];
    [imgView.layer setBackgroundColor:UIColorFromRGB(0x2b84d3).CGColor];
    [imgView.layer setCornerRadius:8.0f];
    [imgView setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
