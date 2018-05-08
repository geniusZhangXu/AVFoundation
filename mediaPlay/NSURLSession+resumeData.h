//
//  NSURLSession+resumeData.h
//  mediaPlay
//
//  Created by SKOTC on 2018/5/4.
//  Copyright © 2018年 CAOMEI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSession (resumeData)

- (NSURLSessionDownloadTask *)downloadTaskWithCorrectResumeData:(NSData *)resumeData;

@end
