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
    
    // Load video
    [self loadAsset];
}

- (void)loadAsset {
    
    DBModel *database = [[DBModel alloc] init];
    Chapter *chapter = [database chapterWithTitle:self.chapterTitle][0];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:chapter.videoUrl] options:nil];
    NSString *key = @"duration";  // A property of AVAsset that is observed for status
    
    // Load asset from url
    [asset loadValuesAsynchronouslyForKeys:@[key] completionHandler:^{
        // Since loadValuesAsynchronouslyForKeys does not execute on main thread
        // we need to force it onto main thread for updating UI
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error;
            AVKeyValueStatus status = [asset statusOfValueForKey:key error:&error];
            // Loaded = ready to play
            if (status == AVKeyValueStatusLoaded) {
                AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
                // Register for notification when reaches end
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(playerItemDidReachEnd:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:playerItem];
                // Initialize player
                [self.playerView setPlayer:[[AVPlayer alloc] initWithPlayerItem:playerItem]];
                [self.playerView.player setActionAtItemEnd:AVPlayerActionAtItemEndNone];
                [self.playerView.player play];
                UIImage *pauseImg = [UIImage imageNamed:@"pause"];
                [self.playButton setImage:pauseImg forState:UIControlStateNormal];
            }
            else {
                NSAssert(0, @"Error loading video: %@", error);
            }
        });
    }];
    
}

/* This method gets called when player reaches end */
- (void)playerItemDidReachEnd:(NSNotification *)notification {

    // Popup for comments
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Leave a comment"
                                                                   message:@"What did you think about the chapter?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter your comment";
    }];
    UIAlertAction *submitComment = [UIAlertAction actionWithTitle:@"Submit"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             UITextField *commentField = [alert textFields][0];
                                                             NSLog(@"Comment: %@", commentField.text);
                                                         }];
    [alert addAction:submitComment];
    [self presentViewController:alert animated:YES completion:nil];
}

/* Play button behavior */
- (IBAction)playOrPause:(id)sender {

    // No video loaded: error message
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
    // Currently playing: pause video
    if (self.playerView.isPlaying) {
        [self.playerView.player pause];
        UIImage *playImg = [UIImage imageNamed:@"play"];
        [self.playButton setImage:playImg forState:UIControlStateNormal];
    }
    // Currently paused: play video
    else {
        [self.playerView.player play];
        UIImage *pauseImg = [UIImage imageNamed:@"pause"];
        [self.playButton setImage:pauseImg forState:UIControlStateNormal];
    }
}

/* Previous button behavior */
- (IBAction)prevChapter:(id)sender {

    // Get all chapter list
    DBModel *database = [[DBModel alloc] init];
    NSArray *chapterList = [database chapters];
    NSUInteger index = 0;
    for (Chapter *ch in chapterList) {
        if ([ch.chapterTitle isEqualToString:self.chapterTitle])
            break;
        index ++;
    }
    // Check if current chapter is the first chapter
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
    // Load next chapter
    Chapter *prevChapter = chapterList[index - 1];
    self.chapterTitle = prevChapter.chapterTitle;
    [self loadAsset];
}

/* Next button behavior */
- (IBAction)nextChapter:(id)sender {
    
    // Get all chapter list
    DBModel *database = [[DBModel alloc] init];
    NSArray *chapterList = [database chapters];
    NSUInteger index = 0;
    for (Chapter *ch in chapterList) {
        if ([ch.chapterTitle isEqualToString:self.chapterTitle])
            break;
        index ++;
    }
    // Check if current chapter is the last chapter
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
    // Load next chapter
    Chapter *nextChapter = chapterList[index + 1];
    self.chapterTitle = nextChapter.chapterTitle;
    [self loadAsset];
}

- (IBAction)zoomToFullScreen:(id)sender {


}


@end
