//
//  DetailViewController.m
//  OnlineCourse
//
//  Created by Masih Tabrizi on 2/18/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import "DetailViewController.h"
#import "PlayerView.h"
#import "DBModel.h"
#import "Chapter.h"
#import "User.h"


@interface DetailViewController ()

/*@property (nonatomic, strong) AVPlayer *player;*/

@end

@implementation DetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setChapterTitle:(NSString *)chapterTitle {
    
    if (![_chapterTitle isEqualToString:chapterTitle]) {
        _chapterTitle = chapterTitle;
    }
    
    // Update the view.
    [self loadAsset];
}

- (void)loadAsset {
    
    DBModel *database = [[DBModel alloc] init];
    Chapter *chapter = [database chapterWithTitle:self.chapterTitle][0];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:chapter.videoUrl] options:nil];
    NSString *key = @"duration";
    
    [asset loadValuesAsynchronouslyForKeys:@[key] completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error;
            AVKeyValueStatus status = [asset statusOfValueForKey:key error:&error];
            
            if (status == AVKeyValueStatusLoaded) {
                AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(playerItemDidReachEnd:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:playerItem];
                AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
                [self.playerView setPlayer:player];
                [player play];
                
                UIImage *pauseImg = [UIImage imageNamed:@"pause"];
                [self.playButton setImage:pauseImg forState:UIControlStateNormal];
            }
            else {
                NSAssert(0, @"Error loading video: %@", error);
            }
        });
    }];
    
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {

    [self.playerView.player seekToTime:kCMTimeZero];
    [self.playerView.player pause];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comment"
                                                    message:@"What did you think about the chapter?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Login", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    UITextField *username = [alert textFieldAtIndex:0];
    UITextField *password = [alert textFieldAtIndex:1];
    username.placeholder = @"Enter Username";
    password.placeholder = @"Enter Password";
    [alert show];
}

- (IBAction)playOrPause:(id)sender {

    if (self.chapterTitle == nil) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No chapters loaded!"
                                                                       message:@"Please select a chapter first from chapter list."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAlert = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
        [alert addAction:dismissAlert];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    if (self.playerView.isPlaying) {
        [self.playerView.player pause];
        UIImage *playImg = [UIImage imageNamed:@"play"];
        [self.playButton setImage:playImg forState:UIControlStateNormal];
    }
    else {
        [self.playerView.player play];
        UIImage *pauseImg = [UIImage imageNamed:@"pause"];
        [self.playButton setImage:pauseImg forState:UIControlStateNormal];
    }
}

- (IBAction)prevChapter:(id)sender {

    DBModel *database = [[DBModel alloc] init];
    NSArray *chapterList = [database chapters];
    NSUInteger index = 0;
    for (Chapter *ch in chapterList) {
        if ([ch.chapterTitle isEqualToString:self.chapterTitle])
            break;
        index ++;
    }
    if (index <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"First chapter reached!"
                                                                       message:@"Current chapter is the first chapter in the tutorial."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAlert = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
        [alert addAction:dismissAlert];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    Chapter *prevChapter = chapterList[index - 1];
    self.chapterTitle = prevChapter.chapterTitle;
    [self loadAsset];
}

- (IBAction)nextChapter:(id)sender {
    
    DBModel *database = [[DBModel alloc] init];
    NSArray *chapterList = [database chapters];
    NSUInteger index = 0;
    for (Chapter *ch in chapterList) {
        if ([ch.chapterTitle isEqualToString:self.chapterTitle])
            break;
        index ++;
    }
    if (index >= chapterList.count - 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Last chapter reached!"
                                                                       message:@"Current chapter is the last chapter in the tutorial."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAlert = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
        [alert addAction:dismissAlert];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    Chapter *nextChapter = chapterList[index + 1];
    self.chapterTitle = nextChapter.chapterTitle;
    [self loadAsset];
}

- (IBAction)zoomToFullScreen:(id)sender {


}


@end
