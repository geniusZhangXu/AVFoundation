//
//  RuntimeMethodHelper.m
//  mediaPlay
//
//  Created by SKOTC on 2018/3/29.
//  Copyright © 2018年 CAOMEI. All rights reserved.
//

#import "RuntimeMethodHelper.h"

@implementation RuntimeMethodHelper


-(void)sayHello{
        
        NSLog(@" you  implementation RuntimeMethodHelper  method sayHello ");
        NSLog(@" RuntimeMethodHelper yes you say hello ");
        NSLog(@" %@ , %p ", self ,_cmd);
}

+(void)sayGodbey{
        
        
        NSLog(@" you  implementation RuntimeMethodHelper  method sayGodbey ");
        NSLog(@" RuntimeMethodHelper yes you say godbey ");
        NSLog(@" %@ , %p ", self ,_cmd);
}


@end
