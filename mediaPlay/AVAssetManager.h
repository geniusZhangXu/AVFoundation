//
//  AVAssetManager.h
//  mediaPlay
//
//  Created by SKOTC on 2018/1/16.
//  Copyright © 2018年 CAOMEI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AVAssetManager : NSObject

-(void)getAssetMessage;

-(void)getAVMetadataItemMessage;

-(void)CMTimeCalculate;


@end
