//
//  CMTimeReading.m
//  mediaPlay
//
//  Created by SKOTC on 2018/1/22.
//  Copyright © 2018年 CAOMEI. All rights reserved.
//


// 通篇解读 CMTime这个结构体

#import "CMTimeReading.h"
#import <Foundation/Foundation.h>

@implementation CMTimeReading


/*
 
下面是CMTime结构体的介绍，这个结构体是C的
typedef struct
{
CMTimeValue        value;                 @field value The value of the CMTime. value/timescale = seconds.
CMTimeScale        timescale;             @field timescale The timescale of the CMTime. value/timescale = seconds.
CMTimeFlags        flags;                 @field flags The flags, eg. kCMTimeFlags_Valid, kCMTimeFlags_PositiveInfinity, etc.
CMTimeEpoch        epoch;                 @field epoch Differentiates between equal timestamps（时间戳） that are actually different because
                                          of looping, multi-item sequencing, etc.
                                          Will be used during comparison: greater epochs happen after lesser ones.
                                          Additions/subtraction is only possible within a single epoch,
                                          however, since epoch length may be unknown/variable.
} CMTime;
 
解释上面的每一个结构体成员的含义：
 
 value:
 timescale: 上面这个两个参数通过源码中的解释value/timescale = seconds就能理解，CMTime是用分数形式表示的结构体，value表示分子  timescale 表示分母
 flags:     位掩码，表示时间的指定状态
 epoch:
 
上面的flags、epoch参数分别是CMTimeFlags、CMTimeEpoch类型
 
通过了解上面的CMTime结构体. 接下来掌握下面这些比较重要的函数:
 
1、CMTime的创建
@function        CMTimeMake
@abstract        Make a valid CMTime with value and timescale.  Epoch is implied to be 0.
@result                The resulting CMTime.

CM_EXPORT
CMTime CMTimeMake(
                  int64_t value,     @param value       Initializes the value field of the resulting CMTime.
                  int32_t timescale) @param timescale   Initializes the timescale field of the resulting CMTime.

CMTimeMake 这个函数的参数就和前面在介绍CMTime这个结构体的时候的参数 value 和 timescale 参数的意义是相同的。
 
2、CMTimeMakeWithEpoch

@function        CMTimeMakeWithEpoch
@abstract        Make a valid CMTime with value, scale and epoch.
@result          The resulting CMTime.

CM_EXPORT
CMTime CMTimeMakeWithEpoch(
                           int64_t value,      @param value Initializes the value field of the resulting CMTime.
                           int32_t timescale,  @param timescale Initializes the scale field of the resulting CMTime.
                           int64_t epoch)      @param epoch Initializes the epoch field of the resulting CMTime.
 
这个创建函数和前面的创建的函数的区别就是多了一个epoch参数
 
 
3、CMTimeMakeWithSeconds函数
@function        CMTimeMakeWithSeconds
@abstract        Make a CMTime from a Float64 number of seconds, and a preferred timescale.
@discussion      The epoch of the result will be zero.  If preferredTimescale is <= 0, the result
will be an invalid CMTime.  If the preferred timescale will cause an overflow, the
timescale will be halved repeatedly until the overflow goes away, or the timescale
is 1.  If it still overflows at that point, the result will be +/- infinity.  The
kCMTimeFlags_HasBeenRounded flag will be set if the result, when converted back to
seconds, is not exactly equal to the original seconds value.
@result                The resulting CMTime.
 
CM_EXPORT
CMTime CMTimeMakeWithSeconds(
                             Float64 seconds,
                             int32_t preferredTimescale)

CMTimeMakeWithSeconds 这个函数的参数也比较容易理解， second 就是直接是你设置的秒数， 后面的参数preferredTimescale是一个时标
举一个例子：
CMTimeMakeWithSeconds(0.5,NSEC_PER_SRC); 表示的就是0.5秒
 
NSEC_PER_SRC 这个我们再解释一下:
                             NSEC 纳秒
                             USEC 微秒
                             SEC  秒
                             PER  每
 
通过上面的解释， NSEC_PER_SRC 代表的含义也就清楚了，每一秒有多少毫秒 这个NSEC_PER_SRC表达就是一个时间标记

4、CMTimeGetSeconds 这个函数的作用就是把一个CMTime类型的结构体转化成秒数来使用
@function     CMTimeGetSeconds
@abstract     Converts a CMTime to seconds.
@discussion   If the CMTime is invalid or indefinite, NAN is returned.  If the CMTime is infinite, +/- __inf()
is returned.  If the CMTime is numeric, epoch is ignored, and time.value / time.timescale is
returned.     The division is done in Float64, so the fraction is not lost in the returned result.
@result       The resulting Float64 number of seconds.

CM_EXPORT
Float64 CMTimeGetSeconds(
                         CMTime time)

 
5、CMTime类型计算函数 CMTimeAdd
 
@function        CMTimeAdd
@abstract   Returns the sum of two CMTimes.
 
在官方的头文件中，下面内容解释了相加时候的规则
@discussion If the operands(操作数) both have the same timescale(时标，分母), the timescale of the result will be the same as
the operands' timescale.  If the operands have different timescales, the timescale of the result
will be the least common multiple of the operands' timescales.
(前面这句话解释的就是两个分数相加的规则，分母相同就取相同的分母，不同就取分母的最小公倍数)
If that LCM timescale is greater than kCMTimeMaxTimescale, the result timescale will be kCMTimeMaxTimescale,
and default rounding will be applied when converting the result to this timescale.
 
@result     The sum of the two CMTimes (addend1 + addend2).
 
CM_EXPORT
CMTime CMTimeAdd(
                 CMTime addend1,         @param addend1                        A CMTime to be added.
                 CMTime addend2)         @param addend2                        Another CMTime to be added.


EG:
 
 CMTime timeO = CMTimeMake(1,10); 1/10
 CMTime timeT = CMTimeMake(1,5);  1/5
 
 CMTime timeA = CMTimeAdd(timeO,timeT);
 CMTImeShow(timeA);
 //打印结果: {3/10 = 0.300}  这个结果也解释了前面的discussion
 

6、有了加的肯定会有减的 CMTimeSubtract

@function        CMTimeSubtract
@abstract   Returns the difference of two CMTimes.
@discussion If the operands both have the same timescale, the timescale of the result will be the same as
the operands' timescale.  If the operands have different timescales, the timescale of the result
will be the least common multiple of the operands' timescales.  If that LCM timescale is
greater than kCMTimeMaxTimescale, the result timescale will be kCMTimeMaxTimescale,
and default rounding will be applied when converting the result to this timescale.
@result     The difference of the two CMTimes (minuend - subtrahend).

CM_EXPORT
CMTime CMTimeSubtract(
                      CMTime minuend,      @param minuend         The CMTime from which the subtrahend will be subtracted.
                      CMTime subtrahend)   @param subtrahend      The CMTime that will be subtracted from the minuend. 
 
CMTime timeO = CMTimeMake(1,10); 1/10
CMTime timeT = CMTimeMake(1,5);  1/5
 
// 我们知道timeT是要比timeO大的，我们故意用小的减去大的看看结果:
CMTime timeA = CMTimeSubtract(timeO,timeT);
CMTimeShow(timeA);
 
打印结果： {-1/10 = -0.100} 这个结果也印证可前面discussion的一些结果
 
 
7、乘  CMTimeMultiply
 

@function   CMTimeMultiply
@abstract   Returns the product of a CMTime and a 32-bit integer.
@discussion The result will have the same timescale as the CMTime operand. If the result value overflows,
the result timescale will be repeatedly halved until the result value no longer overflows.
Again, default rounding will be applied when converting the result to this timescale.  If the
result value still overflows when timescale == 1, then the result will be either positive or
negative infinity, depending on the direction of the overflow.
 
@result     The product of the CMTime and the 32-bit integer.

CM_EXPORT
CMTime CMTimeMultiply(
                      CMTime time,            @param time              The CMTime that will be multiplied.
                      int32_t multiplier)     @param multiplier        The integer it will be multiplied by.
 

EG :
CMTime timeO = CMTimeMake(1,10); 1/10
CMTime timeM = CMTimeMultiply(timeO,5);
CMTimeShow(timeM);

这个结果是5/10 也就是我们小时候学的分数的乘法
需要注意的是这个CMTimeMultiply的第二个参数是一个32-bit integer类型，比如你要是乘 5.5 ,它会自动转化乘 5, 就因为传入的是32-bit integer类型

8、CMTimeMultiplyByFloat64
CMTime CMTimeMultiplyByFloat64(
CMTime time,                     @param time              The CMTime that will be multiplied.
Float64 multiplier)              @param multiplier        The Float64 it will be multiplied by.

CMTimeMultiplyByFloat64 就是 乘 浮点型
CMTime timeO = CMTimeMake(1,10); 1/10
CMTime timeM = CMTimeMultiplyByFloat64(timeO,5.5);
CMTimeShow(timeM);

打印日志: {560000000/1000000000 = 0.560}
 
 
9、比较 CMTimeCompare
@function   CMTimeCompare
@abstract   Returns the numerical relationship (-1 = less than, 1 = greater than, 0 = equal) of two CMTimes.
@discussion If the two CMTimes are numeric (ie. not invalid, infinite, or indefinite), and have
different epochs, it is considered that times in numerically larger epochs are always
greater than times in numerically smaller epochs.
 
CM_EXPORT
int32_t CMTimeCompare(
                      CMTime time1,       @param time1 First CMTime in comparison.
                      CMTime time2)       @param time2 Second CMTime in comparison.


 
CMTime timeO = CMTimeMake(1,10); 1/10
CMTime timeT = CMTimeMake(6,10); 6/10
CMTime timeC = CMTimeCompare(timeO,timeT);
CMTimeShow(timeC);

打印日志：-1    结果说明: 1是大于  0是相等  -1是小于
 
10、 求绝对值 CMTimeAbsoluteValue
@function   CMTimeAbsoluteValue
@abstract   Returns the absolute value of a CMTime.
@result     Same as the argument time, with sign inverted if negative.

CM_EXPORT
CMTime CMTimeAbsoluteValue(
                           CMTime time)   @param time A CMTime
 
 
有这样一个CMTime {-1/10 = -0.100}
求绝对值得到的是: {1/10 = 0.100}
 
*/

@end
