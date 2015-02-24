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

@interface DetailViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet PlayerView *playerView;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIButton *prevButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, copy) NSString *chapterTitle;
@property (nonatomic, copy) NSString *userId;

- (IBAction)seek:(UISlider *)sender;
- (IBAction)play:(UIButton *)sender;
- (IBAction)pause:(UIButton *)sender;
- (IBAction)replay:(UIButton *)sender;
- (IBAction)prevChapter:(UIButton *)sender;
- (IBAction)nextChapter:(UIButton *)sender;
- (IBAction)zoomToFullScreen:(UIButton *)sender;

@end
