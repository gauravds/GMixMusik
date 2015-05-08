//
//  HomeViewController.m
//  GMixMusik
//
//  Created by gauravds on 5/7/15.
//  Copyright (c) 2015 SoftEx Lab. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "FileDownloader.h"
#import "MP3FileModel.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface HomeViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
    __weak IBOutlet UITableView *tblView;
    NSArray *arrayTableData;
    AVAudioPlayer *player;
}
- (IBAction)btnDownloadTapped:(UIButton*)sender;
- (IBAction)btnPlayTabbed:(UIButton*)sender;

- (IBAction)btnAlreadyDownloadedTapped:(id)sender;
- (IBAction)btnAlreadyDownloadingTapped:(id)sender;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 0, 320, 44)];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    [searchBar sizeToFit];
    UIView *barWrapper = [[UIView alloc]initWithFrame:self.navigationController.navigationBar.bounds];
    [barWrapper addSubview:searchBar];
    [self.navigationController.navigationBar addSubview:barWrapper];
    
    [self removeUISearchBarBackgroundInViewHierarchy:searchBar];
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (void) removeUISearchBarBackgroundInViewHierarchy:(UIView *)view
{
    for (UIView *subview in [view subviews]) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break; //To avoid an extra loop as there is only one UISearchBarBackground
        } else {
            [self removeUISearchBarBackgroundInViewHierarchy:subview];
        }
    }
}
#pragma mark - search bar delegates
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [mainWindow addSubview:HUD];
    [HUD showWhileExecuting:@selector(searchTextOnline:)
                   onTarget:self
                 withObject:searchBar.text
                   animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchTextOnline:(NSString*)search {
    if ([Validate isNull:search]) {
        return;
    }
    @try {
        NSString *strUrl = [NSString stringWithFormat:kAPIURLSearchSoundCloud, kClientIDSoundCloud, search];
        
        pr(@"%@",strUrl);
        
        NSError *errorServer;
        
        NSString *jsonStr = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:[strUrl stringByURLEncode]]
                                                           encoding:NSUTF8StringEncoding
                                                              error:&errorServer];
        if (![NSThread isMainThread]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (!errorServer && jsonStr) {
                    NSError *errorParse;
                    NSArray *arr = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&errorParse];
                    pr(@"%@, error %@",arr, errorParse);
                    if (arr && !errorParse) {
                        arrayTableData = arr;
                        [tblView reloadData];
                    } else {
                        [CommonFunctions showServerNotFoundError];
                    }
                } else {
                    [CommonFunctions showServerNotFoundError];
                }
            });
        }
    } @catch (NSException *exception) {
        [CommonFunctions serverInternalError];
    }
}

#pragma mark - UITableView Datasource and deletegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tblView.hidden = (arrayTableData.count == 0 ? YES : NO);
    return arrayTableData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"HomeTableViewCell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:cellID];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.imgView];
    }
    
    @try {
        NSDictionary *dictForCell = arrayTableData[indexPath.row];
        cell.lblTitle.text = (dictForCell[@"title"] == [NSNull null]) ? @"" : dictForCell[@"title"];
        cell.lblSubtitle.text = (dictForCell[@"description"] == [NSNull null]) ? @"" : dictForCell[@"description"];
        cell.btnDownload.tag = indexPath.row;
        cell.btnPlay.tag = indexPath.row;
        if (dictForCell[@"artwork_url"] != [NSNull null]) {
            cell.imgView.imageURL = [NSURL URLWithString:dictForCell[@"artwork_url"]];
        }
    }
    @catch (NSException *exception) {
        pro(@"some value are missing in webservice");
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    pr(@"cell tapped %d:%@", indexPath.row, arrayTableData[indexPath.row]);
}

#pragma mark - btn tapped
- (IBAction)btnDownloadTapped:(UIButton*)sender {
    pr(@"download %d:%@", sender.tag, arrayTableData[sender.tag]);
    
    NSDictionary *dictForCell = arrayTableData[sender.tag];
    NSString *title = (dictForCell[@"title"] == [NSNull null]) ? @"" : dictForCell[@"title"];
    NSString *songID = [@([dictForCell[@"id"] integerValue]) stringValue];
    if ([Validate isNull:songID]) {
        return;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kAPIURLStreamSoundCloud,songID, kClientIDSoundCloud]];
    pr(@"streaming url %@", url);
    MP3FileModel *mp3File = [[MP3FileModel alloc] initWithTitle:title andURL:url];
    [[FileDownloader sharedReference] addFileToDownload:mp3File];
}

- (IBAction)btnPlayTabbed:(UIButton*)sender {
    pr(@"play %d:%@", sender.tag, arrayTableData[sender.tag]);
}

- (IBAction)btnAlreadyDownloadedTapped:(id)sender {
    NSString *localPath = [NSString stringWithFormat:@"%@/last.mp3", DOCUMENT_PATH];
    NSURL *fileURL = [NSURL fileURLWithPath:localPath isDirectory:NO];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[fileURL] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)btnAlreadyDownloadingTapped:(id)sender {
    NSString *localPath = [NSString stringWithFormat:@"%@/last.mp3", DOCUMENT_PATH];
    NSData *localData = [NSData dataWithContentsOfFile:localPath];
    player = [[AVAudioPlayer alloc] initWithData:localData error:nil];
    player.numberOfLoops = -1; //Infinite
    player.volume = 1.f;
    [player play];
}
#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
