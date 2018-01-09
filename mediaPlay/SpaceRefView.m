//
//  SpaceRefView.m
//  mediaPlay
//
//  Created by SKOTC on 2017/12/28.
//  Copyright © 2017年 CAOMEI. All rights reserved.
//

#import "SpaceRefView.h"

@implementation SpaceRefView


-(void)drawRect:(CGRect)rect{

        /*
           颜色空间的创建
         */
        // 我们最常用的就是RGB色彩  显示三色
        CGColorSpaceRef rgbSpaceRef  = CGColorSpaceCreateDeviceRGB();
        
        // 这个是灰度色彩
        // CGColorSpaceRef graySpaceRef = CGColorSpaceCreateDeviceGray();
        
        // 印刷四色 CMYK色彩
        // CGColorSpaceRef cmykSpaceRef = CGColorSpaceCreateDeviceCMYK();
        
        /*
           const CGFloat *components :数组 每四个一组 表示一个颜色 ｛r,g,b,a ,r,g,b,a｝
           const CGFloat *locations  :表示渐变的开始位置
         
           可以像下面这样写
           CGFloat components[8] = {1.0,0.0,0.0,1.0,1.0,1.0,1.0,1.0};
           CGFloat locations[2] = {0.0,1.0};
        */

        UIColor * strokeColor = [UIColor colorWithWhite:0.06 alpha:1.0f];
        
        // 上面的也可以直接写成如下形式：
        UIColor * gradientLightColor = [UIColor colorWithRed:0.101 green:0.100 blue:0.103 alpha:1.000];
        UIColor * gradientDarkColor  = [UIColor colorWithRed:0.237 green:0.242 blue:0.242 alpha:1.000];
        
        //
        NSArray * gradientColors = @[(id)gradientDarkColor.CGColor,(id)gradientLightColor.CGColor];
        CGFloat   locations[] ={0.0,1.0};
        
        // gradientColors 这个是OC的对象
        // 仔细看创建时候的参数可以看到这里需要的是CFArrayRef cg_nullable colors
        // CFArrayRef 对象 利用 __bridge的知识，把NSArray对象转化成 CFArrayRef
        CGGradientRef grandRef = CGGradientCreateWithColors(rgbSpaceRef, (__bridge CFArrayRef)gradientColors, locations);
        
        
        // 获取图形上下文 Graphics 绘制
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        
        // 渐变区域裁剪
        // CGContextClipToRect(context, CGRectMake(0, 360, 200, 100));
        // CGRect rect[5] = {CGRectMake(0, 0, 100, 100),CGRectMake(100, 100, 100, 100),CGRectMake(200, 0, 100, 100),CGRectMake(0, 200, 100, 100),CGRectMake(200, 200, 100, 100)};
        // CGContextClipToRects(context, rect, 5);
        
        /*
         
          这里也可以理解一下 CGRectInset 和 CGRectOffset
          CGRect CGRectInset(CGRect rect, CGFloat dx, CGFloat dy)  以rect为核心，dx 和dy 缩小相应的值
          CGRect CGRectOffset(CGRect rect, CGFloat dx, CGFloat dy) 以rect左上角为基点，向X轴和Y轴偏移dx和dy像素。
         
         */
        
        // 创建这个rect的目的是找到一个比View的rectX.Y缩小2.0个像素的rect
        CGRect insetRect = CGRectInset(rect, 2.0, 2.0);
        
        // 先给整个context设置填充色
        CGContextSetFillColorWithColor(contextRef, strokeColor.CGColor);
        
        // 填充指定矩形中的椭圆  Ellipse 椭圆
        // 给我们指定的rect绘制一个内切椭圆
        CGContextFillEllipseInRect(contextRef, insetRect);
        
        // X 坐标加 rect 宽度的值
        CGFloat midX = CGRectGetMidX(insetRect);
        CGFloat midY = CGRectGetMidY(insetRect);
        
        // 根据中心点，半径，起始的弧度，最后的弧度，是否顺时针画一个圆弧
        // CG_EXTERN void CGContextAddArc(CGContextRef cg_nullable c, CGFloat x, CGFloat y,CGFloat radius, CGFloat startAngle, CGFloat endAngle, int clockwise)
        // 参数分别是 context 中心点  半径  起始的弧度 结束的弧度 是否顺时针
        CGContextAddArc(contextRef, midX, midY, CGRectGetWidth(insetRect) / 2, 0, M_PI * 2, 1);
        // 设置阴影
        CGContextSetShadowWithColor(contextRef, CGSizeMake(0.0f, 0.5f), 2.0f, [UIColor darkGrayColor].CGColor);
        // 直接在图形上下文中渲染路径
        CGContextFillPath(contextRef);
        
        // 在画一个比前面小一点的圆弧
        CGContextAddArc(contextRef, midX, midY, (CGRectGetWidth(insetRect) - 6) / 2, 0, M_PI * 2, 1);
        
        // 裁剪
        // CGContextClip   裁剪当前View path 的区域
        // CGContextEOClip 这个
        CGContextClip(contextRef);
        
        CGPoint startPoint = CGPointMake(midX, CGRectGetMaxY(insetRect));
        CGPoint endPoint = CGPointMake(midX, CGRectGetMinY(insetRect));
        
        /*
         CGContextDrawRadialGradient
         //下面再看一个颜色渐变的圆
         //参数1：图形上下文
         //参数2：渐变色
         //参数3：开始中心点
         //参数4：开始半径
         //参数5：结束中心点
         //参数6：结束半径
         //参数7：渲染模式
         CGContextDrawRadialGradient(context, gradient, CGPointMake(400, 100), 0.0, CGPointMake(350, 100), 30, kCGGradientDrawsBeforeStartLocation);
       
         */
        
        // gradient渐变颜色,startPoint开始渐变的起始位置,endPoint结束坐标,options开始坐标之前or开始之后开始渐变
        CGContextDrawLinearGradient(contextRef, grandRef, startPoint, endPoint, 0);
        
        CGGradientRelease(grandRef);
        CGColorSpaceRelease(rgbSpaceRef);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
