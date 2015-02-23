//
//  PlayerView.h
//  OnlineCourse
//
//  Created by Di Kong on 2/20/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

/**
 * This class represents an AVPlayer on top of UIView
 * The AVPlayer is placed on UIView's layer
 *
 */


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerView : UIView

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, readonly) BOOL isPlaying;

@end
