//
//  AVAssetManager.m
//  mediaPlay
//
//  Created by SKOTC on 2018/1/16.
//  Copyright © 2018年 CAOMEI. All rights reserved.
//

#import "AVAssetManager.h"

#define YOUTUBE_URL @"http://www.youtube.com/watch?v=6dNryy5elc8"

@implementation AVAssetManager

-(instancetype)init
{
        self = [super init];
        if (self) {
                
                
        }
        return self;
}



-(void)getAssetMessage{
        
        NSString * path = [[NSBundle mainBundle]pathForResource:@"薛之谦-像风一样.mp3" ofType:nil];
        NSURL * url = [NSURL fileURLWithPath:path];
        
        AVAsset * asset = [AVAsset assetWithURL:url];
        NSArray * keys = @[@"duration"];
        [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        
                NSError * error;
                AVKeyValueStatus  status = [asset statusOfValueForKey:@"duration" error:&error];
                switch (status) {
                        case AVKeyValueStatusLoaded:
                                
                                // 要更新UI的操作需要回到主线程
                                NSLog(@"属性载入成功，你可以访问了");
                                NSLog(@"duration = %.2f",CMTimeGetSeconds(asset.duration));
                                break;
                                
                        case AVKeyValueStatusLoading:
                                NSLog(@"AVKeyValueStatusLoading");
                                break;
                                
                        case AVKeyValueStatusFailed:
                                NSLog(@"AVKeyValueStatusFailed");
                                break;
                                
                        case AVKeyValueStatusUnknown:
                                NSLog(@"AVKeyValueStatusUnknown");
                                break;
                        default:
                                break;
                }
        }];
}

-(void)getAVMetadataItemMessage{
        
        
        NSURL * url= [[NSBundle mainBundle]URLForResource:@"hubblecast" withExtension:@"m4v"];
//        NSURL * url = [NSURL URLWithString:YOUTUBE_URL];
        AVAsset * asset = [AVAsset assetWithURL:url];
        NSArray * keys  = @[@"availableMetadataFormats"];
        NSMutableArray * metaArray =[NSMutableArray array];
        
        // commonMetadata 从Common键空间获取元数据、这个属性会返回一个包括所有可用元数据的数组
        NSArray * commonMetaArray = [asset commonMetadata];
        NSLog(@"commonMetaArray = %@",commonMetaArray);
        
        //
        [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
                
                // availableMetadataFormats 这个属性会返回一个字符串
                // 其中定义了资源中包含的所有元数据格式
                for (NSString * format in asset.availableMetadataFormats) {
                    
                    // metadataForFormat 方法 这个方法包含一个用于定义元数据格式的NSString对象并返回一个包含所有先关元数据信息的NSArray
                    [metaArray addObjectsFromArray:[asset metadataForFormat:format]];
                }
                
                //
                NSLog(@"metaArray = %@",metaArray);
                // 使用 AVMetadataItem
                for (AVMetadataItem * item in metaArray) {
                        
                    /*
                     * TEXT： 歌词作者
                       TENC： 编码
                       WXXX： URL链接(URL)
                       TCOP： 版权(Copyright)
                       TOPE： 原艺术家
                       TCOM： 作曲家
                       TDAT： 日期
                       TPE3： 指挥者
                       TPE2： 乐队
                       TPE1： 艺术家相当于ID3v1的Artist
                       TPE4： 翻译（记录员、修改员）
                       TYER： 即ID3v1的Year
                       USLT： 歌词
                       TSIZ： 大小
                       TALB： 专辑相当于ID3v1的Album
                       TIT1： 内容组描述
                       TIT2： 标题相当于ID3v1的Title
                       TIT3： 副标题
                       TCON： 流派（风格）相当于ID3v1的Genre
                       AENC： 音频加密技术
                       TSSE： 编码使用的软件（硬件设置）
                       TBPM： 每分钟节拍数 COMM： 注释相当于ID3v1的Comment
                       TDLY： 播放列表返录
                       TRCK： 音轨（曲号）相当于ID3v1的Track
                       TFLT： 文件类型
                       TIME： 时间
                       TKEY： 最初关键字
                       TLAN： 语言
                       TLEN： 长度
                       TMED： 媒体类型
                       TOAL： 原唱片集
                       TOFN： 原文件名
                       TOLY： 原歌词作者
                       TORY： 最初发行年份
                       TOWM： 文件所有者（许可证者）
                       TPOS： 作品集部分
                       TPUB： 发行人
                       TRDA： 录制日期
                       TRSN： Intenet电台名称
                       TRSO： Intenet电台所有者
                       UFID： 唯一的文件标识符
                       TSRC： ISRC（国际的标准记录代码）
                     */
                        
                    NSLog(@"%@ : %@",item.key,item.value);
                }
                
        }];
        
        
        // 字母的处理
        // AVMediaSelectionGroup
        // AVMediaSelectionOption
        /*
          availableMediaCharacteristicsWithMediaSelectionOptions 这个Asset的属性会返回一个字符串数组
          这些字符串用于表示保存在资源中的可用选项的媒体特性
         
          请求到上面的媒体特性之后，需要调用Asset的mediaSelectionGroupForMediaCharacteristic:(媒体特性)
          得到一个包含AVMediaSelectionOption的容器AVMediaSelectionGroup
         
          遍历这个容器的option属性，你就能得到AVMediaSelectionOption对象
         
         */
        
        NSArray * array = asset.availableMediaCharacteristicsWithMediaSelectionOptions;
        for (NSString * string in array) {
                
                AVMediaSelectionGroup * group = [asset mediaSelectionGroupForMediaCharacteristic:string];
                NSLog(@"[%@]",string);
                
                for (AVMediaSelectionOption * option in group.options) {
                        
                        NSLog(@"Option = %@",option.displayName);
                }
        }
}

#pragma mark --
#pragma mark -- CMTime的简单的使用
-(void)CMTimeCalculate{
        
        CMTime timeO = CMTimeMake(1,10);
        CMTime timeT = CMTimeMake(1,5);
        
        // 加
        CMTime timeA = CMTimeAdd(timeO,timeT);
        CMTimeShow(timeA);
        
        //减
        CMTime timeS = CMTimeSubtract(timeO,timeT);
        CMTimeShow(timeS);
        
        //乘 整形
        CMTime timeB = CMTimeMake(1,10);
        CMTime timeI = CMTimeMultiply(timeB,5);
        CMTimeShow(timeI);
        
        //乘 浮点型
        CMTime timeF = CMTimeMultiplyByFloat64(timeB,5.6);
        CMTimeShow(timeF);
        
        // 比较  1是大于  0是相等  -1是小于
        int timeC = CMTimeCompare(timeO,timeT);
        NSLog(@"比较得到大的是%d",timeC); // -1
        
        //求绝对值
        CMTime timeAB = CMTimeAbsoluteValue(timeS);
        CMTimeShow(timeAB);
}




@end
