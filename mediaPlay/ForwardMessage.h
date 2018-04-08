//
//  ForwardMessage.h
//  mediaPlay
//
//  Created by SKOTC on 2018/3/29.
//  Copyright © 2018年 CAOMEI. All rights reserved.
//


#pragma mark --
#pragma mark -- 下面是我们解读的Runtime头文件
/*
 方法
 typedef struct objc_method * Method;
 变量
 typedef struct objc_ivar *Ivar;
 类别
 typedef struct objc_category *Category;
 属性
 typedef struct objc_property *objc_property_t;
 
 接下来就是这个类的结构体对象
 通过下面的结构体的内容，就知道我们针对一个类包含的的基本信息
 Use `Class` instead of `struct objc_class *`
 
 struct objc_class {
 Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
 
 #if !__OBJC2__
 Class _Nullable super_class                              OBJC2_UNAVAILABLE; 指向父类
 const char * _Nonnull name                               OBJC2_UNAVAILABLE; 类名
 long version                                             OBJC2_UNAVAILABLE; 版本 类的版本信息，初始化默认为0，
 下面有函数class_setVersion
 class_getVersion可以对它进行进行修改和读
 long info                                                OBJC2_UNAVAILABLE; 标识
 long instance_size                                       OBJC2_UNAVAILABLE; 类的实例变量的大小，包括继承的父类的。
 struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE; 变量列表
 struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;  方法列表
 struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE; 指向最近使用的方法的指针
 struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE; 协议列表
 #endif
 
 } OBJC2_UNAVAILABLE;
 
 
 Defines a method 方法的描述
 struct objc_method_description {
 SEL _Nullable name;     < The name of the method 方法名称
 char * _Nullable types; < The types of the method arguments 方法的参数类型
 };
 
 Defines a property attribute  属性描述
 typedef struct {
 const char * _Nonnull name;           The name of the attribute  属性名称
 const char * _Nonnull value;          The value of the attribute (usually empty)  属性值
 } objc_property_attribute_t;
 
 
 下面是runtime的方法解析
 
 
 
 
 
 */



#import <Foundation/Foundation.h>
#import "RuntimeMethodHelper.h"

@interface ForwardMessage : NSObject

-(void)sayHello;
+(void)sayGodbey;

@end
