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
#import "DBModel.h"
#import "Chapter.h"
#import "User.h"


@interface DetailViewController ()

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end

@implementation DetailViewController

- (void)viewDidLoad {

    [super viewDidLoad];
   
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.204f green:0.282f blue:0.369f alpha:1.0f];
    UIImage * logoImage = [UIImage imageNamed:@"logo"];
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:logoImage];
    
    
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"View did load");
    
    DBModel *database = [[DBModel alloc] init];
    self.userId = [database currentUser];
    self.player = [[AVPlayer alloc] init];
    self.playerView.player = self.player;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
    self.player = nil;
}

- (void)viewWillAppear:(BOOL)animated {

    NSLog(@"View will appear");
    [self loadAsset];
}

- (void)setChapterTitle:(NSString *)chapterTitle {
    
    if (![_chapterTitle isEqualToString:chapterTitle]) {
        _chapterTitle = chapterTitle;
    }
    
    // Load video
    DBModel *database = [[DBModel alloc] init];
    Chapter *chapter = [database chapterWithTitle:self.chapterTitle][0];
    self.url = chapter.videoUrl;
    /*[self loadAsset];*/
}

- (void)loadAsset {

    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.url] options:nil];
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
                self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
                // Register for notification when reaches end
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(playerItemDidReachEnd:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:self.playerItem];
                // Initialize player
                [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
                [self.player setActionAtItemEnd:AVPlayerActionAtItemEndPause];
                self.progSlider.maximumValue = CMTimeGetSeconds(self.playerItem.duration);
                [self.playerView resumePlayback];
                UIImage *pauseImg = [UIImage imageNamed:@"pause"];
                [self.playButton setImage:pauseImg forState:UIControlStateNormal];
                [self.playButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
                [self.playButton addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                NSAssert(0, @"Error loading video: %@", error);
            }
        });
    }];
    
}

/* This method gets called when player reaches end */
- (void)playerItemDidReachEnd:(NSNotification *)notification {

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
        DBModel *database = [[DBModel alloc] init];
        [database setJournalWithUserId:self.userId chapterTitle:self.chapterTitle comment:commentField.text date:[NSDate date]];
    };
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

/* Jump with progress bar */
/* TODO: slide with the vide progress & fix malfunction after coming back from journal */
- (IBAction)seek:(UISlider *)sender {

    Float64 value = sender.value;
    CMTime jumpTo = CMTimeMakeWithSeconds(value, 1);
    [self.player seekToTime:jumpTo];
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
    [self.playerView resumePlayback];
    UIImage *pauseImg = [UIImage imageNamed:@"pause"];
    [self.playButton setImage:pauseImg forState:UIControlStateNormal];
    [sender removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [sender addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];

}

/* Pause button behavior */
- (IBAction)pause:(UIButton *)sender {
    
    [self.playerView pausePlayback];
    UIImage *playImg = [UIImage imageNamed:@"play"];
    [self.playButton setImage:playImg forState:UIControlStateNormal];
    [sender removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [sender addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
}

/* Replay button behavior */
- (IBAction)replay:(UIButton *)sender {

    [self loadAsset];
    /*[sender removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [sender addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];*/
}

/* Previous button behavior */
- (IBAction)prevChapter:(UIButton *)sender {

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
/* TODO: NEXT REFUSES TO WORK! */
- (IBAction)nextChapter:(UIButton *)sender {
    
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
    [self setChapterTitle:nextChapter.chapterTitle];
}

- (IBAction)zoomToFullScreen:(UIButton *)sender {


}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    JournalTableViewController *dest = [segue destinationViewController];
    [dest setUserId:self.userId];
    [dest setChapterTitle:self.chapterTitle];
    if ([self.playerView isPlaying]) {
        [self pause:self.playButton];
    }
}



@end
