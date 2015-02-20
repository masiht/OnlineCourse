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
@class Chapter;
@class User;

@interface DetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet PlayerView *playerView;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIButton *prevButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IBOutlet UISlider *progSlider;
@property (nonatomic, strong) NSString *chapterTitle;
@property (nonatomic, strong) NSString *userId;

- (IBAction)playOrPause:(id)sender;
- (IBAction)prevChapter:(id)sender;
- (IBAction)nextChapter:(id)sender;
- (IBAction)zoomToFullScreen:(id)sender;

@end
