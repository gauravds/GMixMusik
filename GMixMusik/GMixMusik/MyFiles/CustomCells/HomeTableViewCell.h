//
//  HomeTableViewCell.h
//  GMixMusik
//
//  Created by gauravds on 5/7/15.
//  Copyright (c) 2015 SoftEx Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle, *lblSubtitle;
@property (nonatomic, weak) IBOutlet UIButton *btnDownload, *btnPlay;
@end
