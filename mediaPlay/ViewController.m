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

#import "AVAssetManager.h"

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
        
        
}

#pragma mark --
#pragma mark -- AVAsset 理解
-(void)assetButtonClick{
        
        // AVAsynchronousKeyValueLoading 协议理解
        [[[AVAssetManager alloc]init]  getAssetMessage];
        [[[AVAssetManager alloc]init]  getAVMetadataItemMessage];
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


- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}


@end
