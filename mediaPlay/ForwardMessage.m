//
//  ForwardMessage.m
//  mediaPlay
//
//  Created by SKOTC on 2018/3/29.
//  Copyright © 2018年 CAOMEI. All rights reserved.
//

#import "ForwardMessage.h"
#import <objc/runtime.h>

@interface ForwardMessage()
{
        RuntimeMethodHelper * _runtimeMethodHelper;
        NSString * _selfIvarName;
        ForwardMessage * _forwardMessage;
}
@end


@implementation ForwardMessage

- (instancetype)init
{
        self = [super init];
        if (self) {
                
                _runtimeMethodHelper = [[RuntimeMethodHelper alloc]init];
                _selfIvarName = @"";
        }
        return self;
}



void functionForSayHello(id self, SEL _cmd){
        
        NSLog(@"yes you say Hello! ");
}


Class functionForSayGodbey(id self, SEL _cmd){
        
        NSLog(@"yes you say Godbey! ");
        return [ForwardMessage class];
}



#pragma marlk  --
#pragma marlk  --  消息转发机制

/*
 这个方法处理的是实例方法
 resolve  解决 美  [rɪ'zɑlv]
 */
+(BOOL)resolveInstanceMethod:(SEL)sel{

        NSLog(@"resolveInstanceMethod");
        NSString * method = NSStringFromSelector(sel);
        if ([method isEqualToString:@"sayHello"]) {

            class_addMethod(self, @selector(sayHello), (IMP)functionForSayHello, "");
            return YES;
        }
        return [super resolveInstanceMethod:sel];
}


/*
 这个方法处理的是类方法
 */
//+(BOOL)resolveClassMethod:(SEL)sel{
//
//        NSLog(@"resolveClassMethod");
//        NSString * method = NSStringFromSelector(sel);
//        if ([method isEqualToString:@"sayGodbey"]) {
//                //objc_getMetaClass 这个方法是通过一个类名返回一个元类
//                Class forwardMessageClass = objc_getMetaClass("ForwardMessage");
//                class_addMethod(forwardMessageClass, @selector(sayGodbey), (IMP)functionForSayGodbey, "");
//                return YES;
//        }
//        return [super resolveClassMethod:sel];
//}


/*
    备用接受者
    动态方法解析无法完成消息的处理，就会走备用接受者，这个备用接受者只能是一个新的对象
    不能使self本身，否则就会出现无限循环，要是我们没有指定这个相应的对象来处理aSelector
    就 会调用父类的实现来返回结果，要是父类也没有这个方法的实现就会跑出异常
 */
-(id)forwardingTargetForSelector:(SEL)aSelector{

        NSLog(@"forwardingTargetForSelector");
        NSString * method = NSStringFromSelector(aSelector);
        if ([method isEqualToString:@"sayHello"]) {

                return _runtimeMethodHelper;
        }
        return [super forwardingTargetForSelector:aSelector];
}

#pragma mark --
#pragma mark -- 完整的消息转发机制
/* 要是动态方法解析和备用的接受者都没有处理这个消息，就会走完整的消息转发*/
/* 完整的消息转发机制*/
-(void)forwardInvocation:(NSInvocation *)anInvocation{

        NSLog(@"forwardInvocation");
        NSLog(@"确认需要转发的消息是%@",NSStringFromSelector(anInvocation.selector));
        NSLog(@"得到的方法签名%@",anInvocation.methodSignature);
        //要是RuntimeMethodHelper实现了anInvocation.selector的方法
        if ([RuntimeMethodHelper instanceMethodForSelector:anInvocation.selector]) {
                
                // 就让_runtimeMethodHelper调用实现
                // 当NSInvocation被调用，它会在运行时通过目标对象去寻找对应的方法，
                [anInvocation invokeWithTarget:_runtimeMethodHelper];
        }
}

/*必须重新这个方法，消息转发机制使用从这个方法中获取的信息来创建NSInvocation对象*/
/*按照这个理解，在我们调用完整的消息转发的时候是先走这个方法返回得到的NSMethodSignature对象 */
/*
  signature 签名。
 */
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
        
        
        NSLog(@"methodSignatureForSelector");
        NSLog(@"没实现需要转发的消息是%@",NSStringFromSelector(aSelector));
        NSMethodSignature * signature = [super methodSignatureForSelector:aSelector];
        if (!signature) {
            
                if ([RuntimeMethodHelper instanceMethodForSelector:aSelector]) {
                        
                        signature = [RuntimeMethodHelper instanceMethodSignatureForSelector:aSelector];
                        NSLog(@"创建的方法签名%@",signature);

                }
        }
        return signature;
}


#pragma mark --
#pragma mark -- 要是我们实现了这个方法，那么会走哪里呢？
-(void)sayHello{
        
        NSLog(@"你好、这荒唐的世界");
        [self understandRuntime];
}

#pragma mark --
#pragma mark -- 理解一下Runtime
-(void)understandRuntime{
        
        size_t size = class_getInstanceSize(self.class);
        NSLog(@"size_t %ld",size);
        
        Class class = object_getClass(self.class);
        NSLog(@"class %@",class);
        
        NSObject * object = [[NSObject alloc]init];
        Class classSetObject = object_setClass(object, self.class);
        NSLog(@"classSetObject %@",classSetObject);
        
        unsigned int count;
        Ivar * ivarList = class_copyIvarList(self.class, &count);
        
        for (unsigned int i =0; i<count; i++) {
                
                Ivar  ivar = ivarList[i];
                const char *ivarName = ivar_getName(ivar);
                NSLog(@"Ivar  %@",[NSString stringWithUTF8String:ivarName]);
                //2018-04-04 11:58:58.765610+0800 mediaPlay[3360:534535] Ivar  _runtimeMethodHelper
                //2018-04-04 11:58:58.765719+0800 mediaPlay[3360:534535] Ivar  _selfIvarName
        }
        
        //
        if (count>0){
                object_setIvar(self, ivarList[1], @"zhangxu");
                id ivarValue = object_getIvar(self, ivarList[1]);
                NSLog(@"变量值为:%@",ivarValue);
        }else{
                NSLog(@"没有读取到变量");
        }
        
        NSLog(@"object_isClass %d",object_isClass(object));
        NSLog(@"object_isClass %d",object_isClass(self));
        
        const char * className = object_getClassName(self);
        NSLog(@"className %@",[NSString stringWithUTF8String:className]);
}



@end
