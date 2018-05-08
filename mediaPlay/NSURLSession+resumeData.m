//
//  NSURLSession+resumeData.m
//  mediaPlay
//
//  Created by SKOTC on 2018/5/4.
//  Copyright © 2018年 CAOMEI. All rights reserved.
//

// https://stackoverflow.com/questions/39346231/resume-nsurlsession-on-ios10/39347461#39347461
// https://forums.developer.apple.com/thread/63585
#import "NSURLSession+resumeData.h"


static NSData * correctRequestData(NSData *data) {
        if (!data) {
                return nil;
        }
        // return the same data if it's correct
        if ([NSKeyedUnarchiver unarchiveObjectWithData:data] != nil) {
                return data;
        }
        NSMutableDictionary *archive = [[NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:nil error:nil] mutableCopy];
        
        if (!archive) {
                return nil;
        }
        NSInteger k = 0;
        id objectss = archive[@"$objects"];
        while ([objectss[1] objectForKey:[NSString stringWithFormat:@"$%ld",k]] != nil) {
                k += 1;
        }
        NSInteger i = 0;
        while ([archive[@"$objects"][1] objectForKey:[NSString stringWithFormat:@"__nsurlrequest_proto_prop_obj_%ld",i]] != nil) {
                NSMutableArray *arr = archive[@"$objects"];
                NSMutableDictionary *dic = arr[1];
                id obj = [dic objectForKey:[NSString stringWithFormat:@"__nsurlrequest_proto_prop_obj_%ld",i]];
                if (obj) {
                        [dic setValue:obj forKey:[NSString stringWithFormat:@"$%ld",i+k]];
                        [dic removeObjectForKey:[NSString stringWithFormat:@"__nsurlrequest_proto_prop_obj_%ld",i]];
                        [arr replaceObjectAtIndex:1 withObject:dic];
                        archive[@"$objects"] = arr;
                }
                i++;
        }
        if ([archive[@"$objects"][1] objectForKey:@"__nsurlrequest_proto_props"] != nil) {
                
                NSMutableArray *arr = archive[@"$objects"];
                NSMutableDictionary *dic = arr[1];
                id obj = [dic objectForKey:@"__nsurlrequest_proto_props"];
                if (obj) {
                        
                        [dic setValue:obj forKey:[NSString stringWithFormat:@"$%ld",i+k]];
                        [dic removeObjectForKey:@"__nsurlrequest_proto_props"];
                        [arr replaceObjectAtIndex:1 withObject:dic];
                        archive[@"$objects"] = arr;
                }
        }
        // Rectify weird "NSKeyedArchiveRootObjectKey" top key to NSKeyedArchiveRootObjectKey = "root"
        if ([archive[@"$top"] objectForKey:@"NSKeyedArchiveRootObjectKey"] != nil) {
                [archive[@"$top"] setObject:archive[@"$top"][@"NSKeyedArchiveRootObjectKey"] forKey: NSKeyedArchiveRootObjectKey];
                [archive[@"$top"] removeObjectForKey:@"NSKeyedArchiveRootObjectKey"];
        }
        // Reencode archived object
        NSData *result = [NSPropertyListSerialization dataWithPropertyList:archive format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];
        return result;
}


/*
 理解一下下面的过程
 
 归档
 普通自定义对象和字节流之间的转换
 反归档
 字节流和普通自定义对象之间的转换
 
 序列化
 某些特定类型如（NSDictionary, NSArray, NSString, NSDate, NSNumber，NSData）的数据和字节流之间(通常将其保存为plist文件)的转换
 反序列化
 和序列化相反的过程
 */
static NSMutableDictionary * getResumeDictionary(NSData * data){
        
        NSMutableDictionary * resumeDictionary = nil;
        if (IS_IOS10ORLATER) {
                
                id root = nil;
                // 反归档
                id keyedUnarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
                @try {
                        root = [keyedUnarchiver decodeTopLevelObjectForKey:@"NSKeyedArchiveRootObjectKey" error:nil];
                        if (root == nil) {
                                root = [keyedUnarchiver decodeTopLevelObjectForKey:NSKeyedArchiveRootObjectKey error:nil];
                        }
                } @catch (NSException *exception) {
                        
                } @finally {
                        [keyedUnarchiver finishDecoding];
                        resumeDictionary = [root mutableCopy];
                }
        }
        
        if (resumeDictionary == nil) {
                
                /*
                 NSPropertyListSerialization读取Data
                 */
                resumeDictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:nil error:nil];
        }
        return  resumeDictionary;
}



static NSData * correctResumeData(NSData * data){
        
        NSString *kResumeCurrentRequest = @"NSURLSessionResumeCurrentRequest";
        NSString *kResumeOriginalRequest = @"NSURLSessionResumeOriginalRequest";
        if (data == nil) {
                return  nil;
        }
        //
        NSMutableDictionary *resumeDictionary = getResumeDictionary(data);
        if (resumeDictionary == nil) {
                return nil;
        }
        resumeDictionary[kResumeCurrentRequest] = correctRequestData(resumeDictionary[kResumeCurrentRequest]);
        resumeDictionary[kResumeOriginalRequest] = correctRequestData(resumeDictionary[kResumeOriginalRequest]);
        
        /*
           大家可以了解一下NSPropertyListSerialization
           这个类是用来把我们的数组或者字典来持久化
           这里简单做一个说明
           持久化一个字典或者数组，可以使用方法writeToFile:atomically:来写文件，但是有一个问题，这个方法只能把他们写成plist文件，这样别人就能看到你存储的信息了
           但使用这个类的话就是把它存储成加密的NSData的模式，相对来说会比较安全一点
           NSPropertyListXMLFormat_v1_0 这个参数是二进制编码参数
         */
        NSData *result = [NSPropertyListSerialization dataWithPropertyList:resumeDictionary format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
        return result;
        
}



@implementation NSURLSession (resumeData)

- (NSURLSessionDownloadTask *)downloadTaskWithCorrectResumeData:(NSData *)resumeData{
      
        NSString * resumeCurrentRequest = @"NSURLSessionResumeCurrentRequest";
        NSString * resumeOrignalRequest = @"NSURLSessionResumeOriginalRequest";
        
        NSData *cData = correctResumeData(resumeData);
        
        
        cData = cData ? cData:resumeData;
        NSURLSessionDownloadTask *task = [self downloadTaskWithResumeData:cData];
        NSMutableDictionary *resumeDic = getResumeDictionary(cData);
        if (resumeDic) {
                if (task.originalRequest == nil) {
                        NSData *originalReqData = resumeDic[resumeOrignalRequest];
                        NSURLRequest *originalRequest = [NSKeyedUnarchiver unarchiveObjectWithData:originalReqData ];
                        if (originalRequest) {
                                [task setValue:originalRequest forKey:@"originalRequest"];
                        }
                }
                
                if (task.currentRequest == nil) {
                        NSData *currentReqData = resumeDic[resumeCurrentRequest];
                        NSURLRequest *currentRequest = [NSKeyedUnarchiver unarchiveObjectWithData:currentReqData];
                        if (currentRequest) {
                                [task setValue:currentRequest forKey:@"currentRequest"];
                        }
                }
        }
        return task;
        
        
}

@end
