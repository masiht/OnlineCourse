//
//  DetailViewController.h
//  OnlineCourse
//
//  Created by Masih Tabrizi on 2/18/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class PlayerView;

@interface DetailViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet PlayerView *playerView;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIButton *prevButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet UILabel *chapterTitleLabel;
@property (nonatomic, weak) IBOutlet UITextView *chapterDescription;
@property (nonatomic, assign) BOOL willPause;
@property (nonatomic, assign) BOOL willRestart;
@property (nonatomic, copy) NSString *chapterTitle;

- (IBAction)seek:(UISlider *)sender;
- (IBAction)play:(UIButton *)sender;
- (IBAction)pause:(UIButton *)sender;
- (IBAction)replay:(UIButton *)sender;
- (IBAction)prevChapter:(UIButton *)sender;
- (IBAction)nextChapter:(UIButton *)sender;
- (IBAction)zoomToFullScreen:(UIButton *)sender;

@end
