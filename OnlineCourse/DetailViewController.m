//
//  DetailViewController.m
//  OnlineCourse
//
//  Created by Masih Tabrizi on 2/18/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import "DetailViewController.h"
#import "JournalTableViewController.h"
#import "PlayerView.h"
#import "Database.h"
#import "Chapter.h"
#import "User.h"


@interface DetailViewController ()

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSTimer *sliderTimer;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end

@implementation DetailViewController

- (void)viewDidLoad {

    [super viewDidLoad];
   
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.204f green:0.282f blue:0.369f alpha:1.0f];
    UIImage * logoImage = [UIImage imageNamed:@"logo"];
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:logoImage];
    self.willPause = NO;
    self.willRestart = NO;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
    self.playerView.player = nil;
    [self.sliderTimer invalidate];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    Database *database = [Database sharedData];
    Chapter *chapter = [database currentChapter];
    self.chapterTitleLabel.text = _chapterTitle ? _chapterTitle : @"Chapter Video";
    self.chapterDescription.text = chapter.chapterText;
    self.url = chapter.videoUrl;
    database.currentPlaybackTime = CMTimeMake(0, 1);
    [self loadAsset];
}

/* Change value for slider as video plays */
- (void)updateSlider {
    
    self.slider.maximumValue = CMTimeGetSeconds(self.playerItem.duration);
    self.slider.value = CMTimeGetSeconds(self.playerItem.currentTime);
}

- (void)setChapterTitle:(NSString *)chapterTitle {
    
    if (![_chapterTitle isEqualToString:chapterTitle]) {
        _chapterTitle = chapterTitle;
        [Database sharedData].currentChapterTitle = _chapterTitle;
    }
}

- (void)loadAsset {
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.url] options:nil];
    NSString *key = @"duration";  // A property of AVAsset that is observed for status
    NSError __block *error;
    AVKeyValueStatus status = [asset statusOfValueForKey:key error:&error];
    if (status == AVKeyValueStatusLoaded) {
        return;
    }
    // Load asset from url
    [asset loadValuesAsynchronouslyForKeys:@[key] completionHandler:^{
        // Since loadValuesAsynchronouslyForKeys does not execute on main thread
        // we need to force it onto main thread for updating UI
        dispatch_async(dispatch_get_main_queue(), ^{
            AVKeyValueStatus status = [asset statusOfValueForKey:key error:&error];
            // Loaded = ready to play
            if (status == AVKeyValueStatusLoaded) {
                self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
                // Register for notification when reaches end
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(playerItemDidReachEnd:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:self.playerItem];
                // Initialize player
                self.playerView.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                [self.playerView.player setActionAtItemEnd:AVPlayerActionAtItemEndPause];
                [self.playerView.player seekToTime:[Database sharedData].currentPlaybackTime];
                
                if (self.willRestart) {
                    [self.playerItem seekToTime:kCMTimeZero];
                    [self updateSlider];
                }
                // Simulate a tap on play button
                if (self.willPause)
                    [self pause:self.playButton];
                else
                    [self play:self.playButton];
            }
            else {
                NSAssert(0, @"Error loading video: %@", error);
            }
        });
    }];
    
}

/* This method gets called when player reaches end */
- (void)playerItemDidReachEnd:(NSNotification *)notification {

    self.willRestart = YES;
    // Stop slider timer
    [self updateSlider];
    [self.sliderTimer invalidate];
    // Reset current playback time
    [Database sharedData].currentPlaybackTime = CMTimeMake(0, 1);
    // Replay button
    UIImage *replayImg = [UIImage imageNamed:@"replay"];
    [self.playButton setImage:replayImg forState:UIControlStateNormal];
    [self.playButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.playButton addTarget:self action:@selector(replay:) forControlEvents:UIControlEventTouchUpInside];
    
    // Popup for entering comments
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Leave a comment"
                                                                   message:@"What did you think about the chapter?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter your comment";
    }];
    void (^submitBlock)(UIAlertAction *action) = ^(UIAlertAction *action){
        UITextField *commentField = [alert textFields][0];
        [[Database sharedData] setJournalWithUserId:[Database sharedData].currentUserId
                                       chapterTitle:self.chapterTitle
                                            comment:commentField.text
                                               date:[NSDate date]];
    };  // Block for handling action
    UIAlertAction *dismissComment = [UIAlertAction actionWithTitle:@"Cancel"
                                                             style:UIAlertActionStyleCancel
                                                           handler:nil];
    UIAlertAction *submitComment = [UIAlertAction actionWithTitle:@"Submit"
                                                           style:UIAlertActionStyleDefault
                                                         handler:submitBlock];
    [alert addAction:dismissComment];
    [alert addAction:submitComment];
    [self presentViewController:alert animated:YES completion:nil];
}

/* Seek with progress bar */
- (IBAction)seek:(UISlider *)sender {

    Float64 value = sender.value;
    CMTime jumpTo = CMTimeMakeWithSeconds(value, 1);
    [self.playerView.player seekToTime:jumpTo];
    [self updateSlider];
}

/* Play button behavior */
- (IBAction)play:(UIButton *)sender {

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
    
    // Set button image to that of pause button
    [self.playerView resumePlayback];
    UIImage *pauseImg = [UIImage imageNamed:@"pause"];
    [self.playButton setImage:pauseImg forState:UIControlStateNormal];
    
    // Instantiate slider timer and bind pause action to button
    self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                      selector:@selector(updateSlider)
                                                      userInfo:nil repeats:YES];
    [sender removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [sender addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];

}

/* Pause button behavior */
- (IBAction)pause:(UIButton *)sender {
    
    // Set button image to that of play button
    [self.playerView pausePlayback];
    UIImage *playImg = [UIImage imageNamed:@"play"];
    [self.playButton setImage:playImg forState:UIControlStateNormal];
    
    // Invalidate slider timer and bind play action to button
    [self.sliderTimer invalidate];
    [sender removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [sender addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
}

/* Replay button behavior */
- (IBAction)replay:(UIButton *)sender {

    [self loadAsset];
    self.willRestart = NO;
}

/* Previous button behavior */
- (IBAction)prevChapter:(UIButton *)sender {

    // Get all chapter list
    NSArray *chapterList = [[Database sharedData] chapters];
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
    self.chapterTitle = prevChapter.chapterTitle;;
    [self loadAsset];
}

/* Next button behavior */
- (IBAction)nextChapter:(UIButton *)sender {
    
    // Get all chapter list
    NSArray *chapterList = [[Database sharedData] chapters];
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
    [self setChapterTitle:nextChapter.chapterTitle];
    [self loadAsset];
}

/* TODO: fullscreen action */
- (IBAction)zoomToFullScreen:(UIButton *)sender {


}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"showJournal"]) {
        JournalTableViewController *dest = [segue destinationViewController];
        dest.parentView = self;
        [Database sharedData].currentPlaybackTime = self.playerItem.currentTime;
    }
}



@end
