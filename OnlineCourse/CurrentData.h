//
//  DataCenter.h
//  OnlineCourse
//
//  Created by Di Kong on 2/24/15.
//  Copyright (c) 2015 Masih. All rights reserved.
//

/**
 * This class serves as a singleton class that saves current user and chapter data
 *
 */


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface CurrentData : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *chapterTitle;
@property (nonatomic, assign) CMTime playback;

+ (CurrentData *)sharedData;

@end
