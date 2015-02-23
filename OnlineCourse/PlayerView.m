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

@end
