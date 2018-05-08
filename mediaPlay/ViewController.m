//
//  ViewController.m
//  mediaPlay
//
//  Created by SKOTC on 2017/12/5.
//  Copyright © 2017年 CAOMEI. All rights reserved.
//

#import "ViewController.h"
#import "mediaPlayController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import "AVAssetManager.h"
#import <FrameWorkTest/FrameWorkTest.h>
#import "URLSessionController.h"


#import "ForwardMessage.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *AVAssetButton;

@end

@implementation ViewController

- (void)viewDidLoad {
        
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        // AVMetadataItem
        
        /*
         typedef NS_ENUM(NSInteger, AVKeyValueStatus) {
         
                 AVKeyValueStatusUnknown,
                 AVKeyValueStatusLoading,
                 AVKeyValueStatusLoaded,
                 AVKeyValueStatusFailed,
                 AVKeyValueStatusCancelled
         };
         
         // 这个方法可以用来查询给定属性的状态，如果返回的这个状态不是AVKeyValueStatusLoaded,那我们在此刻去请求这个状态的时候可能会出现卡顿
         - (AVKeyValueStatus)statusOfValueForKey:(NSString *)key error:(NSError * _Nullable * _Nullable)outError;
         
         // keys参数就是我们要请求的属性数组，当完成请求之后就会在handler这个block回调给我们
         - (void)loadValuesAsynchronouslyForKeys:(NSArray<NSString *> *)keys completionHandler:(nullable void (^)(void))handler;
         */
        
        [self.AVAssetButton addTarget:self action:@selector(assetButtonClick) forControlEvents:UIControlEventTouchUpInside];

        //AVMediaSelectionGroup
        
        // 表示AVAsset中的备用媒体呈现方式，一个资源可能包含备用媒体呈现方式，比如音频、视频、或者文本轨道
        //AVMediaSelectionOption
        //AVAssetImageGenerator
        
        //[[[ForwardMessage alloc]init]sayHello];
        //[ForwardMessage sayGodbey];
        
        [ShowNSLog showLog];
        NSString * imageName = [ShowNSLog showLogWithReturn];
        NSLog(@"imageName==%@",imageName);
        
        UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FrameWorkTest.bundle/zhouzhou.jpg"]];
        image.frame = CGRectMake(137, 400, 100, 100);
        [self.view addSubview:image];
        
// 测试
//        NSArray * array = @[@2,@3,@7,@5,@9,@4,@6,@1,@8];
//        NSMutableArray * data  = [NSMutableArray arrayWithArray:array];
//        [self quickSortDataArray:data withStartIndex:0 andEndIndex:data.count - 1];
//        NSLog(@"=======%@",data);


        
        
}

#pragma mark --
#pragma mark -- AVAsset 理解
-(void)assetButtonClick{
        
        // AVAsynchronousKeyValueLoading 协议理解
        AVAssetManager * assetManager  =  [[AVAssetManager alloc]init];
        [assetManager getAssetMessage];
        [assetManager getAVMetadataItemMessage];
        [assetManager CMTimeCalculate];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
        
        if ([segue.identifier isEqualToString:@"mediaPlayerController"]) {
                
            mediaPlayController * destination = segue.destinationViewController;
            destination.MovieURL = [NSURL URLWithString:@"http://pic.ibaotu.com/00/34/48/06n888piCANy.mp4"];
        }
}


-(IBAction)unwindSegue:(UIStoryboardSegue *)sender{
        
        NSLog(@"unwindSegue %@", sender);
}


/**
 快速排序方法
 @param array       源数组
 @param startIndex  开始Index
 @param endIndex    结束Index
 */
-(void)quickSortDataArray:(NSMutableArray *)array withStartIndex:(NSInteger)startIndex andEndIndex:(NSInteger)endIndex{
        
        //只是一个基本的判断，如果数组长度为0或1时返回。
        if (startIndex >= endIndex) {
                
                return ;
        }
        
        NSInteger i = startIndex;
        NSInteger j = endIndex;
        
        //记录比较基准数
        NSInteger key = [array[i] integerValue];
        
        while (i < j) {
                /**** 首先从右边j开始查找比基准数小的值 ***/
                while (i < j && [array[j] integerValue] >= key) {//如果比基准数大，继续查找
                        j--;
                }
                //如果比基准数小，则将查找到的小值调换到i的位置
                array[i] = array[j];
                NSLog(@"第一次打印时候的数组：%@",array);
                
                /**** 当在右边查找到一个比基准数小的值时，就从i开始往后找比基准数大的值 ***/
                while (i < j && [array[i] integerValue] <= key) {//如果比基准数小，继续查找
                        i++;
                }
                //如果比基准数大，则将查找到的大值调换到j的位置
                array[j] = array[i];
                NSLog(@"第二次打印时候的数组：%@",array);
        }
        
        //将基准数放到正确位置
        array[i] = @(key);
        NSLog(@"放回基准数时候的数组：%@",array);
        
        /**** 递归排序 ***/
        //排序基准数左边的
        [self quickSortDataArray:array withStartIndex:startIndex andEndIndex:i - 1];
        //排序基准数右边的
        [self quickSortDataArray:array withStartIndex:i + 1 andEndIndex:endIndex];
}


- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

@end
