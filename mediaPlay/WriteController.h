//
//  WriteController.h
//  mediaPlay
//
//  Created by SKOTC on 2017/12/14.
//  Copyright © 2017年 CAOMEI. All rights reserved.
//

#import <UIKit/UIKit.h>

//录制状态，（这里把视频录制与写入合并成一个状态）
typedef NS_ENUM(NSInteger, FMRecordState) {
        FMRecordStateInit = 0,
        FMRecordStatePrepareRecording,
        FMRecordStateRecording,
        FMRecordStateFinish,
        FMRecordStateFail,
};


@interface WriteController : UIViewController

@property (nonatomic, assign) FMRecordState writeState;

@end
