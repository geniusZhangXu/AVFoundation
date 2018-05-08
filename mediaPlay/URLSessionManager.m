//
//  URLSessionManager.m
//  mediaPlay
//
//  Created by SKOTC on 2018/4/25.
//  Copyright © 2018年 CAOMEI. All rights reserved.
//

#import "URLSessionManager.h"
#import <UserNotifications/UserNotifications.h>

@interface URLSessionManager()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSMutableDictionary *completionHandlerDictionary;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSURLSession *backgroundSession;
@property (strong, nonatomic) NSData *resumeData;

@end

@implementation URLSessionManager

static URLSessionManager * sessionManager = nil;
+(URLSessionManager * )shareURLSessionManager{
        
        if(!sessionManager){
                
            sessionManager = [[self alloc]init];
        }
        return sessionManager;
}



#pragma mark -- 开始下载
#pragma mark --
-(void)startDownloadWithBackgroundSessionAndFileUrl:(NSString * )fileUrl{
        
        self.backgroundSession = [self downLoadSession];
        NSURL * downloadUrl =  [NSURL URLWithString:fileUrl];
        NSURLRequest * request= [NSURLRequest requestWithURL:downloadUrl];
        // 先取消一次上次的任务
        [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {}];
        // 下载任务
        self.downloadTask = [self.backgroundSession downloadTaskWithRequest:request];
        // 开始下载
        [self.downloadTask  resume];
}


// 暂停下载
-(void)pauseDownloadWithBackgroundSession{
        // 暂停下载的时候
        __weak typeof(self)Wself = self;
        [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
           
                __strong typeof(Wself) Sself = Wself;
                Sself.resumeData = resumeData;
        }];
}

// 继续下载
-(void)cintinueDownload{
        
        if (self.resumeData) {
                
                // 系统版本大于10.0
                if (IS_IOS10ORLATER) {
                        
                        DBLong(@"downloadTask 走了downloadTaskWithCorrectResumeData")
                        self.downloadTask = [self.backgroundSession  downloadTaskWithCorrectResumeData:self.resumeData];
                }else{
                        // 继续下载
                        self.downloadTask = [self.backgroundSession downloadTaskWithResumeData:self.resumeData];
                }
                [self.downloadTask resume];
                self.resumeData = nil;
        }
}



#pragma mark --
#pragma mark --
-(NSURLSession *)downLoadSession{
        
        static NSURLSession * session = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                
                NSString * sessionIdentify = @"com.mediaPlay.Session";
                NSURLSessionConfiguration* sessionConfig = nil;
                // 这个方法是要在8.0版本之后有
                sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:sessionIdentify];
                session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        });
        return session;
}



#pragma mark --
#pragma mark --  NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
        
        NSString * locationString = [location path];
        NSString *finalLocation = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lufile",(unsigned long)downloadTask.taskIdentifier]];
        NSError *error;
        [[NSFileManager defaultManager] moveItemAtPath:locationString toPath:finalLocation error:&error];
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didResumeAtOffset:(int64_t)fileOffset
      expectedTotalBytes:(int64_t)expectedTotalBytes {
        
        NSLog(@"fileOffset:%lld expectedTotalBytes:%lld",fileOffset,expectedTotalBytes);
}


//
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
      totalBytesWritten:(int64_t)totalBytesWritten
      totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
        
       NSLog(@"downloadTask:%lu percent:%.2f%%",(unsigned long)downloadTask.taskIdentifier,(CGFloat)totalBytesWritten / totalBytesExpectedToWrite * 100);
}

/* 应用在后台，而且后台所有下载任务完成后，
 * 在所有其他NSURLSession和NSURLSessionDownloadTask委托方法执行完后回调，
 * 可以在该方法中做下载数据管理和UI刷新
 */
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
        NSLog(@"Background URL session %@ finished events.\n", session);
        if (session.configuration.identifier) {
                // 调用在 -application:handleEventsForBackgroundURLSession: 中保存的 handler
                [self callCompletionHandlerForSession:session.configuration.identifier];
        }
}

/* 在任务下载完成、下载失败
 * 或者是应用被杀掉后，重新启动应用并创建相关identifier的Session时调用
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
     didCompleteWithError:(nullable NSError *)error{
        
        if (error) {
                
                DBLong(error);
                // check if resume data are available
                if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
                        NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
                        //通过之前保存的resumeData，获取断点的NSURLSessionTask，调用resume恢复下载
                        self.resumeData = resumeData;
                }
        }else{
                
                [self sendLocationNotification];
        }
}



- (void)addCompletionHandler:(CompletionHandlerType)handler forSession:(NSString *)identifier {
        
        if ([self.completionHandlerDictionary objectForKey:identifier]) {
                
                NSLog(@"Error: Got multiple handlers for a single session identifier.  This should not happen.\n");
        }
        [self.completionHandlerDictionary setObject:handler forKey:identifier];
}

- (void)callCompletionHandlerForSession:(NSString *)identifier {
        
        CompletionHandlerType handler = [self.completionHandlerDictionary objectForKey:identifier];
        if (handler) {
                
                [self.completionHandlerDictionary removeObjectForKey: identifier];
                NSLog(@"Calling completion handler for session %@", identifier);
                handler();
        }
}



-(void)sendLocationNotification{
        
        UNUserNotificationCenter * notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc]init];
        content.title = @"下载完成";
        content.body = @"你在后台下载的内容已经下载完了";
        content.sound = [UNNotificationSound defaultSound];
        
        UNTimeIntervalNotificationTrigger * trigger  =[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
        //UNCalendarNotificationTrigger
        //UNLocationNotificationTrigger
        
        UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:@"Notification" content:content trigger:trigger];
        
        [notificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
           
                UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"下载完成" message:@"下载完成发送了本地推送" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [controller addAction:cancelAction];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:nil];
                
        }];
        
}

@end
