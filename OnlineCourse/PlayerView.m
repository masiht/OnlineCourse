//
//  PlayerView.m
//  OnlineCourse
//
//  Created by Di Kong on 2/20/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

+ (Class)layerClass {

    return [AVPlayerLayer class];
}

- (AVPlayer *)player {

    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {

    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (BOOL)isPlaying {

    return self.player.rate;
}

- (void)pausePlayback {

    self.pausedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 32)];
    self.pausedLabel.enabled = YES;
    NSAttributedString *pauseString = [[NSMutableAttributedString alloc]
                                       initWithString:@"PAUSED"
                                       attributes:@{
                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:32],
                                                    NSForegroundColorAttributeName : [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.6]
                                                    }];
    self.pausedLabel.attributedText = pauseString;
    
    [self addSubview:self.pausedLabel];
    [self.player pause];
}

- (void)resumePlayback {

    [self.pausedLabel removeFromSuperview];
    self.pausedLabel.enabled = NO;
    self.pausedLabel = nil;
    [self.player play];
}

@end
