//
//  PlayerView.m
//  OnlineCourse
//
//  Created by Di Kong on 2/20/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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

@end
