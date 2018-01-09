//
//  AVAudioRecorderController.m
//  mediaPlay
//
//  Created by Zhangxu on 2018/1/2.
//  Copyright © 2018年 CAOMEI. All rights reserved.
//

/*
@interface AVAudioRecorder : NSObject {
 
// 私有的
@private
    void *_impl;
}

// 下面两个是初始化的方法，和我们前面说的AVAudioPlayer大致类似，我们不再解释
The file type to create can be set through the corresponding settings key. If not set, it will be inferred from the file extension. Will overwrite a file at the specified url if a file exists.
- (nullable instancetype)initWithURL:(NSURL *)url settings:(NSDictionary<NSString *, id> *)settings error:(NSError **)outError;

The file type to create can be set through the corresponding settings key. If not set, it will be inferred from the file extension. Will overwrite a file at the specified url if a file exists.
- (nullable instancetype)initWithURL:(NSURL *)url format:(AVAudioFormat *)format error:(NSError **)outError API_AVAILABLE(macos(10.12), ios(10.0), watchos(4.0)) API_UNAVAILABLE(tvos);

// prepareToRecord 准备去记录，它的作用和前面AVAudioPlayer的也是类似的，可以看看前面的注释
methods that return BOOL return YES on success and NO on failure.
- (BOOL)prepareToRecord;  creates the file and gets ready to record. happens automatically on record.
 
// 开始记录 类似与AVAudioPlayer的play方法
- (BOOL)record;  start or resume recording to file.
 
 
// 在将来的某个特殊的你设置的时间点开始记录
- (BOOL)recordAtTime:(NSTimeInterval)time NS_AVAILABLE_IOS(6_0);  start recording at specified time in the future. time is an absolute time based on and greater than deviceCurrentTime.

// 在某一段时间之后开始记录
- (BOOL)recordForDuration:(NSTimeInterval) duration;  record a file of a specified duration. the recorder will stop when it has recorded this length of audio

// 在某一个时间点的某一段时间之后开始记录
- (BOOL)recordAtTime:(NSTimeInterval)time forDuration:(NSTimeInterval) duration NS_AVAILABLE_IOS(6_0);  record a file of a specified duration starting at specified time. time is an absolute time based on and greater than deviceCurrentTime.

// 下面是暂停和停止的方法，这两个比较好理解
- (void)pause;  pause recording
- (void)stop;   stops recording. closes the file.

// 删除记录，调用这个方法之前必须保证 recorder 是 stop 状态
- (BOOL)deleteRecording;  delete the recorded file. recorder must be stopped. returns NO on failure.

// 下面是一些属性
properties
// 是否在记录
@property(readonly, getter=isRecording) BOOL recording;  is it recording or not?
// 保存记录音频文件的URL
@property(readonly) NSURL *url;  URL of the recorded file
//
these settings are fully valid only when prepareToRecord has been called
@property(readonly) NSDictionary<NSString *, id> *settings;

//10.0之后的属性， AVAudioFormat 音频格式注意是只读
this object is fully valid only when prepareToRecord has been called
@property(readonly) AVAudioFormat *format API_AVAILABLE(macos(10.12), ios(10.0), watchos(4.0)) API_UNAVAILABLE(tvos);
// 代理
the delegate will be sent messages from the AVAudioRecorderDelegate protocol
@property(assign, nullable) id<AVAudioRecorderDelegate> delegate;

// 下面的currentTime和deviceCurrentTime在前面也是解释过，按照理解AVAudioPlayer的理解就没问题
get the current time of the recording - only valid while recording
@property(readonly) NSTimeInterval currentTime;
get the device current time - always valid
@property(readonly) NSTimeInterval deviceCurrentTime NS_AVAILABLE_IOS(6_0);


// meteringEnabled 也是和AVAudioPlayer相同
// 需要注意的前面也有提过，注意这个属性以及下面两个方法之间的必要关系。
   至于方法是干什么的我们不在解释，前面AVAudioPlayer也有
@property(getter=isMeteringEnabled) BOOL meteringEnabled;  turns level metering on or off. default is off.
- (void)updateMeters; call to refresh meter values
- (float)peakPowerForChannel:(NSUInteger)channelNumber; returns peak power in decibels for a given channel
- (float)averagePowerForChannel:(NSUInteger)channelNumber; returns average power in decibels for a given channel

The channels property lets you assign the output to record specific channels as described by AVAudioSession's channels property
This property is nil valued until set.
The array must have the same number of channels as returned by the numberOfChannels property.
@property(nonatomic, copy, nullable) NSArray<AVAudioSessionChannelDescription *> *channelAssignments NS_AVAILABLE(10_9, 7_0); Array of AVAudioSessionChannelDescription objects



// 代理  代理需要注意的地方我们不再说了。这个代理和前面AVAudioPlayer的完全类似
   注意点也是类似，有不理解的可以往前面翻
@protocol AVAudioRecorderDelegate <NSObject>
@optional

audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption.
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag;

 if an error occurs while encoding it will be reported to the delegate.
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error;

#if TARGET_OS_IPHONE

// 下面的方法也是被AVAudioSession替换掉，这个我们在下面的介绍中会说这个AVAudioSession这个类的
AVAudioRecorder INTERRUPTION NOTIFICATIONS ARE DEPRECATED - Use AVAudioSession instead.
 
audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was recording. The recorded file will be closed.
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder NS_DEPRECATED_IOS(2_2, 8_0);

audioRecorderEndInterruption:withOptions: is called when the audio session interruption has ended and this recorder had been interrupted while recording.
Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume.
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags NS_DEPRECATED_IOS(6_0, 8_0);

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags NS_DEPRECATED_IOS(4_0, 6_0);

audioRecorderEndInterruption: is called when the preferred method, audioRecorderEndInterruption:withFlags:, is not implemented.
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder NS_DEPRECATED_IOS(2_2, 6_0);
*/

#import "AVAudioRecorderController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "AVAudioPlayerController.h"

@interface AVAudioRecorderController ()<AVAudioRecorderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UILabel *recoderTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *startRecoderButton;
@property (weak, nonatomic) IBOutlet UIButton *playerButton;
@property (weak, nonatomic) IBOutlet UIButton *stopRecorder;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong,nonatomic) dispatch_source_t  timer;

@property (nonatomic,strong) AVAudioRecorder * avAudioRecorder;
@property (nonatomic,strong) NSString * filePath;

@property (nonatomic,strong) NSURL * destURL;

@end

@implementation AVAudioRecorderController

- (void)viewDidLoad {
        
        
        [super viewDidLoad];
        // Do any additional setup after loading the view.
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        NSError *sessionerror;
        if (![session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionerror]) {
                NSLog(@"Category Error: %@", [sessionerror localizedDescription]);
        }
        
        if (![session setActive:YES error:&sessionerror]) {
                NSLog(@"Activation Error: %@", [sessionerror localizedDescription]);
        }
        
        
       self.stateLabel.text = @"准备录制";
       self.stateLabel.textColor = [UIColor blueColor];
       [self.startRecoderButton addTarget:self action:@selector(startRecoder) forControlEvents:UIControlEventTouchUpInside];
       [self.stopRecorder addTarget:self action:@selector(stopRecoder) forControlEvents:UIControlEventTouchUpInside];

       // 录制的音频路径
       _filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"memo.caf"];
    
       // 这个设置的字典在写AVAssetWriter的时候也会用到
       NSDictionary * audioSettings = @{
                                       AVFormatIDKey : @(kAudioFormatAppleIMA4),
                                       AVSampleRateKey : @44100.0f,
                                       AVNumberOfChannelsKey : @1,
                                       AVEncoderAudioQualityKey : @(AVAudioQualityMedium)
                                      };

    
       NSError * error;
       self.avAudioRecorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:_filePath] settings:audioSettings error:&error];
    
       NSParameterAssert(_avAudioRecorder);
        
       if (self.avAudioRecorder && !error) {
        
           self.avAudioRecorder.delegate = self;
           self.avAudioRecorder.meteringEnabled = YES;
           [self.avAudioRecorder prepareToRecord];
        
       }else{
        
           NSLog(@"AVAudioRecorder初始化失败:%@",error);
       }
        
    // 街上熙熙攘攘的人
    // 你夹在手中的烟
    // 如果可以选择
    // 又有谁愿意让自己有么多故事说给别人听
}


#pragma mark --
#pragma mark 开始录制
-(void)startRecoder{
    
            // 开启定时器
            self.stateLabel.text = @"录制中";
            if (self.avAudioRecorder.isRecording) {
                
                __block int time = 0;
                _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
                dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
                dispatch_source_set_event_handler(_timer, ^{
                    
                        time ++;
                    
                        if (time<=10) {
                             
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self updatePowerAndRecorderTime:time];
                                });
                        }else{
                        
                                [self stopRecoder];
                        }
                });
                    
                dispatch_resume(_timer);
                    
            }
    
            [self.avAudioRecorder record];
}


-(void)stopRecoder{

        
        dispatch_source_cancel(_timer);
        [self.avAudioRecorder stop];
        
        self.stateLabel.text =@"录制结束";
        self.stateLabel.textColor = [UIColor redColor];
        [self saveRecordingWithName:@"TESTAUDIO" completionHandler:^(BOOL save, id error) {
                
                if (save == YES && !error) {
                        
                        NSLog(@"音频文件保存成功,可以播放！");
                }else{
                        
                        NSLog(@"音频文件保存失败,不可以播放！");
                }
        }];
}


-(void)saveRecordingWithName:(NSString *)name completionHandler:(THRecordingSaveCompletionHandler)handler {
        
        
        NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
        NSString *filename = [NSString stringWithFormat:@"%@-%f.m4a", name, timestamp];
        
        NSString *docsDir = [self documentsDirectory];
        NSString *destPath = [docsDir stringByAppendingPathComponent:filename];
        
        NSURL *srcURL = self.avAudioRecorder.url;
        NSURL *destURL = [NSURL fileURLWithPath:destPath];
        
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] copyItemAtURL:srcURL toURL:destURL error:&error];
        if (success) {
                
                _destURL = destURL;
                handler(YES, error);
                [self.avAudioRecorder prepareToRecord];
        
                
        } else {
                
                handler(NO, error);
        }
}


- (NSString *)documentsDirectory {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        return [paths objectAtIndex:0];
}


#pragma mark --
#pragma mark 更新UI
-(void)updatePowerAndRecorderTime:(int)time{
    
        self.recoderTimeLabel.text = [NSString stringWithFormat:@" %d 秒",time];
        
        [self.avAudioRecorder updateMeters];

        float averagePower = [self.avAudioRecorder averagePowerForChannel:0];
        float peakPower = [self.avAudioRecorder peakPowerForChannel:0];

        self.powerLabel.text = [NSString stringWithFormat:@"指定频道分贝值:%f",peakPower];
        self.averageLabel.text = [NSString stringWithFormat:@"平均分贝值:%f",averagePower];
}


#pragma mark --
#pragma mark AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{

        NSLog(@"音频录制成功");
}


- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{

        NSLog(@"音频编码发生错误");
}


#pragma mark --
#pragma mark 播放
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
        
        if ([segue.identifier isEqualToString:@"AVAudioPlayerController"]) {
                
                AVAudioPlayerController * destination = segue.destinationViewController;
                destination.filePath = _destURL;
        }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
