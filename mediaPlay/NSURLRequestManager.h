//
//  NSURLRequestManager.h
//  mediaPlay
//
//  Created by SKOTC on 2018/4/27.
//  Copyright © 2018年 CAOMEI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequestManager : NSObject

//@interface NSURLRequest : NSObject <NSSecureCoding, NSCopying, NSMutableCopying>
//{
//@private
//   NSURLRequestInternal *_internal;
//}

/*!
 @method requestWithURL:
 @abstract Allocates and initializes an NSURLRequest with the given
 URL.
 @discussion Default values are used for cache policy
 (NSURLRequestUseProtocolCachePolicy) and timeout interval (60
 seconds).
 @param URL The URL for the request.
 @result A newly-created and autoreleased NSURLRequest instance.
 
 这个方法就不用解释了
 */
//+ (instancetype)requestWithURL:(NSURL *)URL;


/*!
 @property supportsSecureCoding
 @abstract Indicates that NSURLRequest implements the NSSecureCoding protocol.
 @result A BOOL value set to YES.
 
 只读属性，表明NSURLRequest是否实现了NSSecureCoding协议，这个属性后面可以测试一下
 */
//@property (class, readonly) BOOL supportsSecureCoding;


/*!
 @method requestWithURL:cachePolicy:timeoutInterval:
 @abstract Allocates and initializes a NSURLRequest with the given
 URL and cache policy.
 @param URL The URL for the request.
 @param cachePolicy The cache policy for the request.
 @param timeoutInterval The timeout interval for the request. See the
 commentary for the <tt>timeoutInterval</tt> for more information on
 timeout intervals.
 @result A newly-created and autoreleased NSURLRequest instance.
 
 这个是类方法的初始化方法，参数就是缓存策略和超时时间
 
 这里引入了这个NSURLRequestCachePolicy缓存策略的枚举类型
 
 typedef NS_ENUM(NSUInteger, NSURLRequestCachePolicy)
 {
         默认缓存策略
         NSURLRequestUseProtocolCachePolicy = 0,
 
         URL应该加载源端数据，不使用本地缓存数据
         NSURLRequestReloadIgnoringLocalCacheData = 1,
 
         本地缓存数据、代理和其他中介都要忽视他们的缓存，直接加载源数据
         NSURLRequestReloadIgnoringLocalAndRemoteCacheData = 4, // Unimplemented
 
         从服务端加载数据，完全忽略缓存。和NSURLRequestReloadIgnoringLocalCacheData一样
         NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData,
 
         使用缓存数据，忽略其过期时间；只有在没有缓存版本的时候才从源端加载数据
         NSURLRequestReturnCacheDataElseLoad = 2,
 
         只使用cache数据，如果不存在cache，就请求失败，不再去请求数据  用于没有建立网络连接离线模式
         NSURLRequestReturnCacheDataDontLoad = 3,
 
         指定如果已存的缓存数据被提供它的源段确认为有效则允许使用缓存数据响应请求，否则从源段加载数据。
         NSURLRequestReloadRevalidatingCacheData = 5, // Unimplemented
 };
 
 
 */
//+ (instancetype)requestWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval;




/*!
 @method initWithURL:
 @abstract Initializes an NSURLRequest with the given URL.
 @discussion Default values are used for cache policy
 (NSURLRequestUseProtocolCachePolicy) and timeout interval (60
 seconds).
 @param URL The URL for the request.
 @result An initialized NSURLRequest.
 
 这个也是初始化的方法，和上面方法的区别是  缓存策略参数   和  请求超时时间被默认设置
 缓存策略 NSURLRequestUseProtocolCachePolicy
 超时时间 60秒
 
 */
//- (instancetype)initWithURL:(NSURL *)URL;


/*!
 @method initWithURL:
 @abstract Initializes an NSURLRequest with the given URL and
 cache policy.
 @discussion This is the designated initializer for the
 NSURLRequest class.
 @param URL The URL for the request.
 @param cachePolicy The cache policy for the request.
 @param timeoutInterval The timeout interval for the request. See the
 commentary for the <tt>timeoutInterval</tt> for more information on
 timeout intervals.
 @result An initialized NSURLRequest.
 
 当我们看到这个  NS_DESIGNATED_INITIALIZER  就知道这个方法的含义了
 不知道有多少人理解这个宏定义的
 去了解一下NS_DESIGNATED_INITIALIZER 和 NS_UNAVAILABLE 两个宏 算一点点小知识吧
 */
//- (instancetype)initWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval NS_DESIGNATED_INITIALIZER;



// 下面是一些 readonly 的属性  了解一下

/*!
 @abstract Returns the URL of the receiver.
 @result The URL of the receiver.
 
 
 没什么说的了，URL
 @property (nullable, readonly, copy) NSURL *URL;
 
 
 */


/*!
 @abstract Returns the cache policy of the receiver.
 @result The cache policy of the receiver.
 
 缓存策略
 @property (readonly) NSURLRequestCachePolicy cachePolicy;
 */


/*!
 @abstract Returns the timeout interval of the receiver.
 @discussion The timeout interval specifies the limit on the idle
 interval alloted to a request in the process of loading. The "idle
 interval" is defined as the period of time that has passed since the
 last instance of load activity occurred for a request that is in the
 process of loading. Hence, when an instance of load activity occurs
 (e.g. bytes are received from the network for a request), the idle
 interval for a request is reset to 0. If the idle interval ever
 becomes greater than or equal to the timeout interval, the request
 is considered to have timed out. This timeout interval is measured
 in seconds.
 @result The timeout interval of the receiver.
 
 请求超时时间
 @property (readonly) NSTimeInterval timeoutInterval;
 
 */


/*!
 @abstract The main document URL associated with this load.
 @discussion This URL is used for the cookie "same domain as main
 document" policy. There may also be other future uses.
 See setMainDocumentURL:
 NOTE: In the current implementation, this value is unused by the
 framework. A fully functional version of this method will be available
 in the future.
 @result The main document URL.
 
 主文档地址 这个地址用来存放缓存
 */
//@property (nullable, readonly, copy) NSURL *mainDocumentURL;

/*!
 @abstract Returns the NSURLRequestNetworkServiceType associated with this request.
 @discussion  This will return NSURLNetworkServiceTypeDefault for requests that have
 not explicitly set a networkServiceType (using the setNetworkServiceType method).
 @result The NSURLRequestNetworkServiceType associated with this request.
 
 获取网络请求的服务类型 枚举如下
 */
//@property (readonly) NSURLRequestNetworkServiceType networkServiceType API_AVAILABLE(macos(10.7), ios(4.0), watchos(2.0), tvos(9.0));

/*!
 @abstract returns whether a connection created with this request is allowed to use
 the built in cellular radios (if present).
 @result YES if the receiver is allowed to use the built in cellular radios to
 satify the request, NO otherwise.
 
 //获取是否允许使用服务商蜂窝网络
 */
//@property (readonly) BOOL allowsCellularAccess  API_AVAILABLE(macos(10.8), ios(6.0), watchos(2.0), tvos(9.0));






// 关于NSMutableURLRequest属性的介绍我们就省略了，和前面NSURLRequest没什么区别，自己理解

// @interface NSURLRequest (NSHTTPURLRequest)

/*!
 
 @abstract Returns the HTTP request method of the receiver.
 @result the HTTP request method of the receiver.
 
 HTTP请求方式  POST GET 等
 */
//@property (nullable, readonly, copy) NSString *HTTPMethod;

/*!
 @abstract Returns a dictionary containing all the HTTP header fields
 of the receiver.
 @result a dictionary containing all the HTTP header fields of the
 receiver.
 
 得到一个字典数据，设置的 HTTP请求头的键值数据
 */
//@property (nullable, readonly, copy) NSDictionary<NSString *, NSString *> *allHTTPHeaderFields;

/*!
 @method valueForHTTPHeaderField:
 @abstract Returns the value which corresponds to the given header
 field. Note that, in keeping with the HTTP RFC, HTTP header field
 names are case-insensitive.
 @param field the header field name to use for the lookup
 (case-insensitive).
 @result the value associated with the given header field, or nil if
 there is no value associated with the given header field.
 
 设置http请求头中的字段值，这个我们待会在看看一些Demo代码和AF的源码比较一下
 */
//- (nullable NSString *)valueForHTTPHeaderField:(NSString *)field;


/*!
 @abstract Returns the request body data of the receiver.
 @discussion This data is sent as the message body of the request, as
 in done in an HTTP POST request.
 @result The request body data of the receiver.
 
 请求体
 */
//@property (nullable, readonly, copy) NSData *HTTPBody;

/*!
 @abstract Returns the request body stream of the receiver
 if any has been set
 @discussion The stream is returned for examination only; it is
 not safe for the caller to manipulate the stream in any way.  Also
 note that the HTTPBodyStream and HTTPBody are mutually exclusive - only
 one can be set on a given request.  Also note that the body stream is
 preserved across copies, but is LOST when the request is coded via the
 NSCoding protocol
 @result The request body stream of the receiver.
 
 http请求体的输入流
 */
//@property (nullable, readonly, retain) NSInputStream *HTTPBodyStream;

/*!
 @abstract Determine whether default cookie handling will happen for
 this request.
 @discussion NOTE: This value is not used prior to 10.3
 @result YES if cookies will be sent with and set for this request;
 otherwise NO.
 
 设置发送请求时是否发送cookie数据
 */
//@property (readonly) BOOL HTTPShouldHandleCookies;

/*!
 @abstract Reports whether the receiver is not expected to wait for the
 previous response before transmitting.
 @result YES if the receiver should transmit before the previous response
 is received.  NO if the receiver should wait for the previous response
 before transmitting.
 
 
 设置的请求时是否按顺序收发 默认禁用 在某些服务器中设为YES可以提高网络性能
 */
//@property (readonly) BOOL HTTPShouldUsePipelining API_AVAILABLE(macos(10.7), ios(4.0), watchos(2.0), tvos(9.0));


/*!
 @method setValue:forHTTPHeaderField:
 @abstract Sets the value of the given HTTP header field.
 @discussion If a value was previously set for the given header
 field, that value is replaced with the given value. Note that, in
 keeping with the HTTP RFC, HTTP header field names are
 case-insensitive.
 @param value the header field value.
 @param field the header field name (case-insensitive).
 
 //设置http请求头中的字段值
 */
//- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(NSString *)field;

/*!
 @method addValue:forHTTPHeaderField:
 @abstract Adds an HTTP header field in the current header
 dictionary.
 @discussion This method provides a way to add values to header
 fields incrementally. If a value was previously set for the given
 header field, the given value is appended to the previously-existing
 value. The appropriate field delimiter, a comma in the case of HTTP,
 is added by the implementation, and should not be added to the given
 value by the caller. Note that, in keeping with the HTTP RFC, HTTP
 header field names are case-insensitive.
 @param value the header field value.
 @param field the header field name (case-insensitive).
 
 //向http请求头中添加一个字段
 */
//- (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field;


 /*
 请求头类容一般就这些
 Host: 目标服务器的网络地址
 Accept: 让服务端知道客户端所能接收的数据类型，如text/html
 Content-Type: body中的数据类型，如application/json; charset=UTF-8
 Accept-Language: 客户端的语言环境，如zh-cn
 Accept-Encoding: 客户端支持的数据压缩格式，如gzip
 User-Agent: 客户端的软件环境，我们可以更改该字段为自己客户端的名字，比如QQ music v1.11，比如浏览器Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/600.8.9 (KHTML, like Gecko) Maxthon/4.5.2
 Connection: keep-alive，该字段是从HTTP 1.1才开始有的，用来告诉服务端这是一个持久连接，“请服务端不要在发出响应后立即断开TCP连接”。关于该字段的更多解释将在后面的HTTP版本简介中展开。
 Content-Length: body的长度，如果body为空则该字段值为0。该字段一般在POST请求中才会有。

 
 */



//NSHTTPCookieStorage


@end
