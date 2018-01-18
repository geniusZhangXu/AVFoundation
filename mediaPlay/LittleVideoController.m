//
//  LittleVideoController.m
//  mediaPlay
//
//  Created by SKOTC on 2017/12/11.
//  Copyright © 2017年 CAOMEI. All rights reserved.
//

/*!
@protocol AVCaptureFileOutputRecordingDelegate <NSObject>

@optional


 @method captureOutput:didStartRecordingToOutputFileAtURL:fromConnections:
 @abstract
 开始往file里面写数据
 Informs the delegate when the output has started writing to a file.
 
 @param captureOutput
 The capture file output that started writing the file.
 @param fileURL
 The file URL of the file that is being written.
 @param connections
 An array of AVCaptureConnection objects attached to the file output that provided the data that is being written to the file.
 
 @discussion
 方法在给输出文件当中写数据的时候开始调用 如果在开始写数据的时候有错误  方法就不会被调用  但 captureOutput:willFinishRecordingToOutputFileAtURL:fromConnections:error: and captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:
 这两个方法总是会被调用，即使没有数据写入
 
 This method is called when the file output has started writing data to a file. If an error condition prevents any data from being written, this method may not be called. captureOutput:willFinishRecordingToOutputFileAtURL:fromConnections:error: and captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error: will always be called, even if no data is written.
 Clients 顾客；客户端；委托方   specific特殊  efficient 有效的
 Clients should not assume that this method will be called on a specific thread, and should also try to make this method as efficient as possible.
方法:
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections;

 
 @method captureOutput:didPauseRecordingToOutputFileAtURL:fromConnections:
 @abstract 摘要
 
 没当客户端成功的暂停了录制时候这个方法就会被调用
 Called whenever the output is recording to a file and successfully pauses the recording at the request of the client.
 
 @param captureOutput
 The capture file output that has paused its file recording.
 @param fileURL
 The file URL of the file that is being written.
 @param connections
 attached 附加   provided 提供
 An array of AVCaptureConnection objects attached to the file output that provided the data that is being written to the file.
 
 @discussion  下面的谈论告诉我们你要是调用了stop方法，这个代理方法是不会被调用的
 Delegates can use this method to be informed when a request to pause recording is actually respected. It is safe for delegates to change what the file output is currently doing (starting a new file, for example) from within this method. If recording to a file is stopped, either manually or due to an error, this method is not guaranteed to be called, even if a previous call to pauseRecording was made.
 
 Clients should not assume that this method will be called on a specific thread, and should also try to make this method as efficient as possible.

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didPauseRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections NS_AVAILABLE(10_7, NA);


 @method captureOutput:didResumeRecordingToOutputFileAtURL:fromConnections:
 @abstract 这个摘要告诉我们的是这个方法在你暂停完之后成功的回复了录制就会进这个代理方法
 Called whenever the output, at the request of the client, successfully resumes a file recording that was paused.
 
 @param captureOutput
 The capture file output that has resumed(重新开始) its paused file recording.
 @param fileURL
 The file URL of the file that is being written.
 @param connections
 An array of AVCaptureConnection objects attached to the file output that provided the data that is being written to the file.
 
 @discussion
 Delegates can use this method to be informed（通知） when a request to resume recording is actually respected. It is safe for delegates to change what the file output is currently doing (starting a new file, for example) from within this method. If recording to a file is stopped, either manually or due to an error, this method is not guaranteed（确保、有保证） to be called, even if a previous call to resumeRecording was made.
 
 Clients should not assume that this method will be called on a specific thread, and should also try to make this method as efficient as possible.

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didResumeRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections NS_AVAILABLE(10_7, NA);


 @method captureOutput:willFinishRecordingToOutputFileAtURL:fromConnections:error:
 @abstract  这个方法在录制即将要结束的时候就会被调用
 Informs the delegate when the output will stop writing new samples to a file.
 
 @param captureOutput
 The capture file output that will finish writing the file.
 @param fileURL
 The file URL of the file that is being written.
 @param connections
 An array of AVCaptureConnection objects attached to the file output that provided the data that is being written to the file.
 @param error
 An error describing what caused the file to stop recording, or nil if there was no error.
 
 @discussion
 This method is called when the file output will stop recording new samples to the file at outputFileURL, either because startRecordingToOutputFileURL:recordingDelegate: or stopRecording were called, or because an error, described by the error parameter, occurred (if no error occurred, the error parameter will be nil). This method will always be called for each recording request, even if no data is successfully written to the file.
 
 Clients should not assume that this method will be called on a specific thread, and should also try to make this method as efficient as possible.

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput willFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections error:(NSError *)error NS_AVAILABLE(10_7, NA);


 下面是必须实现的代理方法，就是录制成功结束的时候调用的方法
 @required


 @method captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:
 @abstract
 Informs the delegate when all pending data has been written to an output file.
 
 @param captureOutput
 The capture file output that has finished writing the file.
 @param fileURL
 The file URL of the file that has been written.
 @param connections
 An array of AVCaptureConnection objects attached to the file output that provided the data that was written to the file.
 @param error
 An error describing what caused the file to stop recording, or nil if there was no error.
 
 @discussion
 This method is called when the file output has finished writing all data to a file whose recording was stopped, either because startRecordingToOutputFileURL:recordingDelegate: or stopRecording were called, or because an error, described by the error parameter, occurred (if no error occurred, the error parameter will be nil). This method will always be called for each recording request, even if no data is successfully written to the file.
 
 Clients should not assume that this method will be called on a specific thread.
 
 Delegates are required to implement this method.

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error;
 
@end
 */


#import "LittleVideoController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "mediaPlayController.h"

@interface LittleVideoController ()<AVCaptureFileOutputRecordingDelegate>


@property(nonatomic,strong) dispatch_source_t timer;
@property (weak, nonatomic) IBOutlet UIButton * startButton;
@property(nonatomic,strong) UIButton * videoButton;
@property(nonatomic,strong) AVCaptureSession *  captureSession;
@property(nonatomic,strong) AVCaptureMovieFileOutput * captureMovieFileOutput;
@property(nonatomic,strong) AVCaptureVideoPreviewLayer * captureVideoPreviewLayer;

@property(nonatomic,strong) NSString * videoPath;

@end

@implementation LittleVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.startButton addTarget:self action:@selector(startCaptureWithSession) forControlEvents:UIControlEventTouchUpInside];
    
    /*
     下面是一个有趣的写法，上网搜到这样一段话，补充说明之后能理解这种写法：
     这个问题严格上讲和Objective－C没什么太大的关系，这个是GNU C的对C的扩展语法 
     
     在理解一下什么是GNU C ，下面是百度给的定义：
     GNU C 函式库（GNU C Library，又称为glibc）是一种按照LGPL许可协议发布的，公开源代码的，免费的，方便从网络下载的C的编译程序。 GNU C运行期库，是一种C函式库，是程序运行时使用到的一些API集合，它们一般是已预先编译好，以二进制代码形式存 在Linux类系统中，GNU C运行期库，通常作为GNU C编译程序的一个部分发布。 它最初是自由软件基金会为其GNU操作系统所写，但目前最主要的应用是配合Linux内核，成为GNU/Linux操作系统一个重要的组成部分。
     
     继续解释：
     Xcode采用的Clang编译，Clang作为GCC(GCC的初衷是为GNU操作系统专门编写的一款编译器)的替代品，和GCC一样对于GNU C语法完全支持
     
     你可能知道if(condition)后面只能根一条语句，多条语句必须用{}阔起来，这个语法扩展即将一条(多条要用到{})语句外面加一个括号(),
     这样的话你就可以在表达式中应用循环、判断甚至本地变量等。
     表达式()最后一行应该一个能够计算结果的子表达式加上一个分号(;),这个子表达式作为整个结构的返回结果
     
     这个扩展在代码中最常见的用处在于宏定义中
     */
        
    self.captureSession = ({
        // 分辨率设置
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        // 先判断这个设备是否支持设置你要设置的分辨率
        if ([session canSetSessionPreset:AVCaptureSessionPresetMedium]) {
                
                /*
                 下面是对你能设置的预设图片的质量和分辨率的说明
                 AVCaptureSessionPresetHigh      High 最高的录制质量，每台设备不同
                 AVCaptureSessionPresetMedium    Medium 基于无线分享的，实际值可能会改变
                 AVCaptureSessionPresetLow       LOW 基于3g分享的
                 AVCaptureSessionPreset640x480   640x480 VGA
                 AVCaptureSessionPreset1280x720  1280x720 720p HD
                 AVCaptureSessionPresetPhoto     Photo 完整的照片分辨率，不支持视频输出
                 */
                [session setSessionPreset:AVCaptureSessionPresetMedium];
        }
        session;
    });
    
    
    // 初始化一个拍摄输出对象
    self.captureMovieFileOutput = ({
        
        //输出一个电影文件
        /*
         a.AVCaptureMovieFileOutput  输出一个电影文件
         b.AVCaptureVideoDataOutput  输出处理视频帧被捕获
         c.AVCaptureAudioDataOutput  输出音频数据被捕获
         d.AVCaptureStillImageOutput 捕获元数据
         */
        
        AVCaptureMovieFileOutput * output = [[AVCaptureMovieFileOutput alloc]init];
        
        /*
         一个ACCaptureConnection可以控制input到output的数据传输。
         */
        AVCaptureConnection * connection = [output connectionWithMediaType:AVMediaTypeVideo];
        
        if ([connection isVideoMirroringSupported]) {

                
            /*
             
             视频防抖 是在 iOS 6 和 iPhone 4S 发布时引入的功能。到了 iPhone 6，增加了更强劲和流畅的防抖模式，被称为影院级的视频防抖动。相关的 API 也有所改动 (目前为止并没有在文档中反映出来，不过可以查看头文件）。防抖并不是在捕获设备上配置的，而是在 AVCaptureConnection 上设置。由于不是所有的设备格式都支持全部的防抖模式，所以在实际应用中应事先确认具体的防抖模式是否支持：
             
             typedef NS_ENUM(NSInteger, AVCaptureVideoStabilizationMode) {
             AVCaptureVideoStabilizationModeOff       = 0,
             AVCaptureVideoStabilizationModeStandard  = 1,
             AVCaptureVideoStabilizationModeCinematic = 2,
             AVCaptureVideoStabilizationModeAuto      = -1,  自动
             } NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED;
             */
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
            //预览图层和视频方向保持一致
            connection.videoOrientation = [self.captureVideoPreviewLayer connection].videoOrientation;
        }
        
        if ([self.captureSession canAddOutput:output]) {
            
            [self.captureSession addOutput:output];
        }
        
        output;
    });
    
    /*
     用于展示制的画面
    */
    self.captureVideoPreviewLayer = ({
        
        AVCaptureVideoPreviewLayer * preViewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
        preViewLayer.frame = CGRectMake(10, 50, 355, 355);
        
        /*
         AVLayerVideoGravityResizeAspect:保留长宽比，未填充部分会有黑边
         AVLayerVideoGravityResizeAspectFill:保留长宽比，填充所有的区域
         AVLayerVideoGravityResize:拉伸填满所有的空间
        */
        preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer:preViewLayer];
        self.view.layer.masksToBounds = YES;
        preViewLayer;
    });
}


-(void)startCaptureWithSession{
    
    // 先删除之前的视频文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.videoPath]) {
                
        [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:self.videoPath] error:NULL];
    }
        
    NSError * error = nil;
    if ([self SetSessioninputs:error]) {
        
        // 开始录制
        [self.captureSession startRunning];
        [self startRecordSession];
        
    }else{
        
        [self.captureSession stopRunning];
        NSLog(@"录制失败：%@",error);
    }
}


-(BOOL)SetSessioninputs:(NSError *)error{
    
    // capture 捕捉 捕获
    /*
       视频输入类
       AVCaptureDevice 捕获设备类
       AVCaptureDeviceInput 捕获设备输入类
     */
    AVCaptureDevice * captureDevice   = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * videoInput = [AVCaptureDeviceInput deviceInputWithDevice: captureDevice error: &error];
    
    if (!videoInput) {
        return NO;
    }
    
    // 给捕获会话类添加输入捕获设备
    if ([self.captureSession canAddInput:videoInput]) {
        
        [self.captureSession addInput:videoInput];
    }else{
        return NO;
    }
    
    
    /*
      添加音频捕获设备
     */
    AVCaptureDevice * audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput * audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    
    if (!audioDevice) {
        
        return NO;
    }
    
    if ([self.captureSession canAddInput:audioInput]) {
        
        [self.captureSession addInput:audioInput];
    }
    return YES;
}



-(void)startRuningWithSession{
        
        __block int time = 0;
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_timer, ^{
                
                time++;
                NSLog(@"录制的时长：%d",time);
                if (time == 10) {
                        
                        NSLog(@"录制的时长限制在10秒以内");
                        [self.captureMovieFileOutput stopRecording];
                        [self.captureSession stopRunning];
                        dispatch_source_cancel(_timer);
                }
        });
        dispatch_resume(_timer);
}


#pragma mark --
#pragma mark -- AVCaptureMovieFileOutput 录制视频
-(void)startRecordSession{

        
    [self.captureMovieFileOutput startRecordingToOutputFileURL:({
        
        NSURL * url  = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"zhangxu.mov"]];
        NSLog(@"视频想要缓存的地址:%@",url);
        if ([[NSFileManager defaultManager]fileExistsAtPath:url.path]) {
            
            [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
        }
        url;
    }) recordingDelegate:self];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL
      fromConnections:(NSArray *)connections{
        
        //Recording started
        NSLog(@"视频录制开始！！");
        [self startRuningWithSession]; // 开始计时
}

- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(nullable NSError *)error{
    
        NSLog(@"视频录制结束！！");
        NSLog(@"视频缓存地址:%@",outputFileURL);
        BOOL recordedSuccessfully = YES;
        id captureResult = [[error userInfo]objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (captureResult) {
                
                recordedSuccessfully = [captureResult boolValue];
        }
        
        if (recordedSuccessfully) {
                
                [self compressVideoWithFileUrl:outputFileURL];
        }
}


#pragma mark --
#pragma mark -- 视频压缩方法
-(void)compressVideoWithFileUrl:(NSURL *)fileUrl{
    
    /* 
     
      这里需要注意的一点就是在重复的路径上保存文件是不行的，可以选择在点击开始的时候删除之前的
      也可以这样按照时间命名不同的文件保存
      在后面的 AVAssetWriter 也要注意这一点
     */
    // 压缩后的视频的方法命名
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        
    // 压缩后的文件路径
    self.videoPath = [NSString stringWithFormat:@"%@/%@.mov",NSTemporaryDirectory(),[formatter stringFromDate:[NSDate date]]];
    
    // 先根据你传入的文件的路径穿件一个AVAsset
    AVAsset * asset = [AVAsset  assetWithURL:fileUrl];
    /*
     
     根据urlAsset创建AVAssetExportSession压缩类
     第二个参数的意义：常用 压缩中等质量  AVAssetExportPresetMediumQuality
     AVF_EXPORT NSString *const AVAssetExportPresetLowQuality        NS_AVAILABLE_IOS(4_0);
     AVF_EXPORT NSString *const AVAssetExportPresetMediumQuality     NS_AVAILABLE_IOS(4_0);
     AVF_EXPORT NSString *const AVAssetExportPresetHighestQuality    NS_AVAILABLE_IOS(4_0);
    
    */
    AVAssetExportSession * exportSession = [[AVAssetExportSession alloc]initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    
    // 优化压缩，这个属性能使压缩的质量更好
    exportSession.shouldOptimizeForNetworkUse = YES;
    // 到处的文件的路径
    exportSession.outputURL =  [NSURL fileURLWithPath:self.videoPath];
    // 导出的文件格式
    /*!
      @constant  AVFileTypeMPEG4  mp4格式的   AVFileTypeQuickTimeMovie mov格式的
      @abstract A UTI for the MPEG-4 file format.
      @discussion
      The value of this UTI is @"public.mpeg-4".
      Files are identified with the .mp4 extension.
      可以看看这个outputFileType格式，比如AVFileTypeMPEG4也可以写成public.mpeg-4，其他类似
    */
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    
    NSLog(@"视频压缩后的presetName: %@",exportSession.presetName);
    // 压缩的方法
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        /*
         exportSession.status 枚举属性
         typedef NS_ENUM(NSInteger, AVAssetExportSessionStatus) {
         AVAssetExportSessionStatusUnknown,
         AVAssetExportSessionStatusWaiting,
         AVAssetExportSessionStatusExporting,
         AVAssetExportSessionStatusCompleted,
         AVAssetExportSessionStatusFailed,
         AVAssetExportSessionStatusCancelled
         };
         */
        int exportStatus = exportSession.status;
        switch (exportStatus) {
            case AVAssetExportSessionStatusFailed:
                
                NSLog(@"压缩失败");
                break;
            case AVAssetExportSessionStatusCompleted:
            {
                /*
                 压缩后的大小
                 也可以利用exportSession的progress属性，随时监测压缩的进度
                 */
                NSData * data = [NSData dataWithContentsOfFile:self.videoPath];
                float dataSize = (float)data.length/1024/1024;
                NSLog(@"视频压缩后大小 %f M", dataSize);
               
            }
                break;
            default:
                break;
        }
    }];
}


/*
 
   上面是第一种视频录制的情况，AVCaptureSession + AVCaptureMovieFileOutput  在利用 AVAssetExportSession 压缩视频
   上面第一种方式的缺点就是视频压缩需要时间，压缩的速度比较慢，对用户的体验有一定的影响。
   还有第二种方式，利用AVCaptureSession + AVAssetWriter  这种方案
 
 */

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
        
        if ([segue.identifier isEqualToString:@"mediaPlayController"]) {
                
                mediaPlayController * mediaPlayC = segue.destinationViewController;
                mediaPlayC.MovieURL = [NSURL fileURLWithPath:self.videoPath];
        }

}



-(IBAction)unwindSegue:(UIStoryboardSegue *)sender{
        
        NSLog(@"unwindSegue %@", sender);
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
