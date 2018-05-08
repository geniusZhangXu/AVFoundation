//
//  URLSessionManager.h
//  mediaPlay
//
//  Created by SKOTC on 2018/4/25.
//  Copyright © 2018年 CAOMEI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLSession+resumeData.h"

// NOTE: 要是这个block声明的后面没有添加void的时候将会报警告
typedef void(^CompletionHandlerType)(void);

@interface URLSessionManager : NSObject

+(URLSessionManager * )shareURLSessionManager;
-(void)startDownloadWithBackgroundSessionAndFileUrl:(NSString * )fileUrl;
-(void)pauseDownloadWithBackgroundSession;
-(void)cintinueDownload;
-(NSURLSession *)downLoadSession;
-(void)addCompletionHandler:(CompletionHandlerType)handler forSession:(NSString *)identifier;

/*
  NSURLSession 默认是挂起的状态，要是需要网络请求需要去开启，
  下面这个属性sharedSession就是获取全局的NSURLSession对象。在iPhone的所有app共用一个全局session。
  @property (class, readonly, strong) NSURLSession * sharedSession;
 */


/*
 * Customization of NSURLSession occurs during creation of a new session.
 * If you only need to use the convenience routines with custom
 * configuration options it is not necessary（必要的） to specify（特殊的） a delegate.
 * If you do specify a delegate, the delegate will be retained（保留） until after
 * the delegate has been sent the URLSession:didBecomeInvalidWithError: message.
   代理一直会被保留，知道代理接收到URLSession:didBecomeInvalidWithError:消息
 
   下面两个是利用NSURLSessionConfiguration对象得到NSURLSession的方法，区别在于代理的设置
   + (NSURLSession *)sessionWithConfiguration:(NSURLSessionConfiguration *)configuration;
   + (NSURLSession *)sessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(nullable id <NSURLSessionDelegate>)delegate delegateQueue:(nullable NSOperationQueue *)queue;
 
 */


/*
 * 下面这三个都是只读属性，意义明确，不需要在解释
 * @property (readonly, retain) NSOperationQueue *delegateQueue;
 * @property (nullable, readonly, retain) id <NSURLSessionDelegate> delegate;
 * @property (readonly, copy) NSURLSessionConfiguration *configuration;
*/


/*
 * The sessionDescription property is available for the developer to
 * provide a descriptive label for the session.
 * 该方法是给session添加一个描述信息
 * @property (nullable, copy) NSString *sessionDescription;
 */


/* -finishTasksAndInvalidate returns immediately and existing tasks will be allowed
 * to run to completion.  New tasks may not be created.  The session
 * will continue to make delegate callbacks until URLSession:didBecomeInvalidWithError:
 * has been issued.
 *
 * -finishTasksAndInvalidate and -invalidateAndCancel do not
 * have any effect on the shared session singleton.
 *
 * When invalidating a background session, it is not safe to create another background
 * session with the same identifier until URLSession:didBecomeInvalidWithError: has
 * been issued.
 
   这个方法是任务完成之后调用会释放session
   这里涉及到的是session和代理之间相互的强引用可能会造成内存泄漏的问题，了解一下！
   - (void)finishTasksAndInvalidate;
 */


/* -invalidateAndCancel acts as -finishTasksAndInvalidate, but issues
 * -cancel to all outstanding tasks for this session.  Note task
 * cancellation is subject to the state of the task, and some tasks may
 * have already have completed at the time they are sent -cancel.
 
   这个是取消任务释放session 和前面的任务完成之后是有区别的，上面的注释又给我们解释说让我们注意任务的状态
   可能会给一些结束的任务发送cancel消息
   - (void)invalidateAndCancel;
 
   NOTE:当对 session invalidate 后，就不能再创建新的 task 了，两个方法的不同之处是，- finishTasksAndInvalidate会等到正在执行的 task 执行完成，调用完所有回调或 delegate 后，释放对 delegate 的强引用，而- invalidateAndCancel方法则是直接取消所有正在执行的 task。
 
 */


/*
 清空所有的 cookie、缓存、证书等，传入的 completionHandler 在上述操作完成后执行。
 empty all cookies, cache and credential stores, removes disk files, issues -flushWithCompletionHandler:. Invokes completionHandler() on the delegate queue if not nil.
 - (void)resetWithCompletionHandler:(void (^)(void))completionHandler;
 */


/*
 将内存中的 cookie、证书等写到硬盘，之后的请求会使用新的 TCP 连接，传入的 completionHandler 在上述操作完成后执行。
 storage to disk 存储到磁盘
 flush storage to disk and clear transient network caches.  Invokes completionHandler() on the delegate queue if not nil.
 - (void)flushWithCompletionHandler:(void (^)(void))completionHandler;
 */


/* 获取 session 中的 task，在获取完 task 列表后会执行传入的 completionHandler 参数，而 task 列表则作为 block 的参数传入。*/
/* invokes completionHandler with outstanding data, upload and download tasks.
   - (void)getTasksWithCompletionHandler:(void (^)(NSArray<NSURLSessionDataTask *> *dataTasks, NSArray<NSURLSessionUploadTask *> *uploadTasks, NSArray<NSURLSessionDownloadTask *> *downloadTasks))completionHandler;
 */

/* invokes completionHandler with all outstanding tasks.
   - (void)getAllTasksWithCompletionHandler:(void (^)(NSArray<__kindof NSURLSessionTask *> *tasks))completionHandler API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));
 */

/*
 * NSURLSessionTask objects are always created in a suspended state (suspend 和 pause 表示暂停 挂起状态) and
 * must be sent the -resume message before they will execute.
 */

/* Creates a data task with the given request.  The request may have a body stream.
 - (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request;
 */

/* Creates a data task to retrieve the contents of the given URL.
 - (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url;
 */

/* Creates an upload task with the given request.  The body of the request will be created from the file referenced by fileURL
 - (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL;
 */

/* Creates an upload task with the given request.  The body of the request is provided from the bodyData.
 - (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromData:(NSData *)bodyData;
 */


/* Creates an upload task with the given request.  The previously set body stream of the request (if any) is ignored and the URLSession:task:needNewBodyStream: delegate will be called when the body payload is required.
 - (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request;
 */


/* Creates a download task with the given request.
 - (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request;
 */


/* Creates a download task to download the contents of the given URL.
 - (NSURLSessionDownloadTask *)downloadTaskWithURL:(NSURL *)url;
 */

/* Creates a download task with the resume data.  If the download cannot be successfully resumed, URLSession:task:didCompleteWithError: will be called.
   - (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData;
 */

/* Creates a bidirectional stream (双向) task to a given host and port.
 - (NSURLSessionStreamTask *)streamTaskWithHostName:(NSString *)hostname port:(NSInteger)port API_AVAILABLE(macos(10.11), ios(9.0), tvos(9.0)) __WATCHOS_PROHIBITED;
 */

/* Creates a bidirectional stream task with an NSNetService to identify the endpoint.
 * The NSNetService will be resolved before any IO completes.
 - (NSURLSessionStreamTask *)streamTaskWithNetService:(NSNetService *)service API_AVAILABLE(macos(10.11), ios(9.0), tvos(9.0)) __WATCHOS_PROHIBITED;
 */





//NSURLSessionConfiguration
/*
下面是三种配置
 
defaultSessionConfiguration：创建默认配置的对象，使用硬盘持久化的全局缓存、credential 和 cookie 存储对象。
@property (class, readonly, strong) NSURLSessionConfiguration *defaultSessionConfiguration;
 
和默认配置类似，除了所有会话相关的数据都被存储在内容中。把它想象成“私人”会话
@property (class, readonly, strong) NSURLSessionConfiguration *ephemeralSessionConfiguration;
 
 backgroundSessionConfiguration：允许会话在后台执行上传和下载任务。即使 app 本身被暂停或终止了，传输都会继续
 
 Returns a session configuration object that allows HTTP and HTTPS uploads or downloads to be performed in the background.
 //+ (NSURLSessionConfiguration *)backgroundSessionConfigurationWithIdentifier:(NSString *)identifier API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
 
*/


/*
   后台会话configuration的identifier
   identifier for the background session configuration
   @property (nullable, readonly, copy) NSString *identifier;
 */


/*
   缓存策略
   default cache policy for requests
   @property NSURLRequestCachePolicy requestCachePolicy;
 */


/*
 下面两个都是超时设置
 第一个是request添加Data的时间限制
 第二个是请求资源的时间限制
 default timeout for requests.  This will cause a timeout if no data is transmitted for the given timeout value, and is reset whenever data is transmitted. */
// @property NSTimeInterval timeoutIntervalForRequest;

/* default timeout for requests.  This will cause a timeout if a resource is not able to be retrieved within a given timeout. */
// @property NSTimeInterval timeoutIntervalForResource;


/*
   网络服务类型
   type of service for requests.
   @property NSURLRequestNetworkServiceType networkServiceType;
 */


/*
   bool 类型设置是否在蜂窝网络也能使用
   allow request to route over cellular.
   @property BOOL allowsCellularAccess;
 */

/*
 * Causes tasks to wait for network connectivity to become available,
 rather than （而不是） immediately ( [ɪ'midɪətli] ) failing with an error (such as NSURLErrorNotConnectedToInternet)
 * when it is not. When waiting for connectivity, the timeoutIntervalForRequest
 * property does not apply, but the timeoutIntervalForResource property does.
 *
 * Unsatisfactory connectivity (that requires waiting) includes cases where the
 * device has limited or insufficient connectivity for a task (e.g., only has a
 * cellular connection but the allowsCellularAccess property is NO, or requires
 * a VPN connection in order to reach the desired host).
 *
 * Default value is NO. Ignored by background sessions, as background sessions
 * always wait for connectivity.
 
    这个值看着上面一大串解释的，仔细读一读就知道是在网络有问题的情况下，session是否立即失效  默认是NO
   @property BOOL waitsForConnectivity API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0));
 */


/* allows background tasks to be scheduled at the discretion of the system for optimal performance.
   A Boolean value that determines whether background tasks can be scheduled at the discretion of the system for optimal performance.
   @property (getter=isDiscretionary) BOOL discretionary API_AVAILABLE(macos(10.10), ios(7.0), watchos(2.0), tvos(9.0));
 */


/* The identifier of the shared data container into which files in background sessions should be downloaded.
 * App extensions wishing to use background sessions *must* set this property to a valid container identifier, or
 * all transfers in that session will fail with NSURLErrorBackgroundSessionRequiresSharedContainer.
 
   它给NSURLSession使用的共享容器（用于缓存分享内容）指定了一个名称，这个容器也是扩展载体应用的一部分
   @property (nullable, copy) NSString *sharedContainerIdentifier API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));

 */

/*

 * Allows the app to be resumed or launched in the background when tasks in background sessions complete
 * or when auth is required. This only applies to configurations created with +backgroundSessionConfigurationWithIdentifier:
 * and the default value is YES.
 
  是另一个新的属性，该属性指定该会话是否应该从后台启动。
  @property BOOL sessionSendsLaunchEvents API_AVAILABLE(ios(7.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos);

 */

/* The proxy dictionary, as described by <CFNetwork/CFHTTPStream.h>
   指定了会话连接中的代理服务器
   @property (nullable, copy) NSDictionary *connectionProxyDictionary;
 */


/*
   设置 TLS 协议允许的最大最小版本
   The minimum allowable versions of the TLS protocol, from <Security/SecureTransport.h> */
/* The maximum allowable versions of the TLS protocol, from <Security/SecureTransport.h>
   @property SSLProtocol TLSMinimumSupportedProtocol;
   @property SSLProtocol TLSMaximumSupportedProtocol;
 */



/*
   Allow the use of HTTP pipelining
   也出现在NSMutableURLRequest，它可以被用于开启HTTP管道，这可以显着降低请求的加载时间，但是由于没有被服务器广泛支持，默认是禁用的。
 @property BOOL HTTPShouldUsePipelining;
 */


/* Allow the session to set cookies on requests
   指定了请求是否应该使用会话HTTPCookieStorage的cookie。
   @property BOOL HTTPShouldSetCookies;
 */


/* Policy for accepting cookies.  This overrides the policy otherwise specified by the cookie storage.
   决定了该会话应该接受从服务器发出的cookie的条件。
   @property NSHTTPCookieAcceptPolicy HTTPCookieAcceptPolicy;
 
 */


/* Specifies additional headers which will be set on outgoing requests.
 Note that these headers are added to the request only if not already present.
 指定了一组默认的可以设置出站请求的数据头。
 @property (nullable, copy) NSDictionary *HTTPAdditionalHeaders;
 */

/* The maximum number of simultanous persistent connections per host
   @property NSInteger HTTPMaximumConnectionsPerHost;
 */


/* The cookie storage object to use, or nil to indicate that no cookies should be handled
   是被会话使用的cookie存储。默认情况下，NSHTTPCookieShorage的+ sharedHTTPCookieStorage会被使用，这与NSURLConnection是相同的。
   @property (nullable, retain) NSHTTPCookieStorage *HTTPCookieStorage;
 */


/* The credential storage object, or nil to indicate that no credential storage is to be used
   @property (nullable, retain) NSURLCredentialStorage *URLCredentialStorage;
 */


/* The URL resource cache, or nil to indicate that no caching is to be performed
   @property (nullable, retain) NSURLCache *URLCache;
 */


/* Enable extended background idle mode for any tcp sockets created.    Enabling this mode asks the system to keep the socket open
 *  and delay reclaiming it when the process moves to the background (see https://developer.apple.com/library/ios/technotes/tn2277/_index.html)
 
 @property BOOL shouldUseExtendedBackgroundIdleMode API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));

 */

/* An optional array of Class objects which subclass NSURLProtocol.
 The Class will be sent +canInitWithRequest: when determining if
 an instance of the class can be used for a given URL scheme.
 You should not use +[NSURLProtocol registerClass:], as that
 method will register your class with the default session rather
 than with an instance of NSURLSession.
 Custom NSURLProtocol subclasses are not available to background
 sessions.
 是注册NSURLProtocol类的特定会话数组
 @property (nullable, copy) NSArray<Class> *protocolClasses;
 */


/*
 multipath service type to use for connections.  The default is NSURLSessionMultipathServiceTypeNone
 TCP连接方式
 @property NSURLSessionMultipathServiceType multipathServiceType API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(macos, watchos, tvos);
 */



/*
* NSURLSessionDelegate specifies the methods that a session delegate
* may respond to.  There are both session specific messages (for
* example, connection based auth) as well as task based messages.
*/

/*
 * Messages related to the URL session as a whole
 @protocol NSURLSessionDelegate <NSObject>
 @optional
 */

/* The last message a session receives.  A session will only become
 * invalid because of a systemic error or when it has been
 * explicitly（明显） invalidated, in which case the error parameter will be nil.
 会话失效
 通知URL会话该会话已失效。
 如果通过调用finishTasksAndInvalidate方法使会话失效，则会话将一直等待，直到会话中的最终任务完成或失败，然后再调用此委托方法。如果您调用invalidateAndCancel方法，
 会话将立即调用此委托方法。
 对于每一个完成的后台Task调用该Session的Delegate中的URLSession:downloadTask:didFinishDownloadingToURL:（成功的话）
 和URLSession:task:didCompleteWithError:（成功或者失败都会调用）方法做处理，以上的回调代码块可以在这里调用
 - (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error;

 */

/* If implemented, when a connection level authentication challenge
 * has occurred, this delegate will be given the opportunity to
 * provide authentication credentials to the underlying
 * connection. Some types of authentication will apply to more than
 * one request on a given connection to a server (SSL Server Trust
 * challenges).  If this delegate message is not implemented, the
 * behavior will be to use the default handling, which may involve user
 * interaction.
 
  如果服务器要求验证客户端身份或向客户端提供其证书用于验证时，则会调用
  在苹果开发者文档中有这样的说明
  If the initial handshake with the server requires a connection-level challenge (such as an SSL client certificate), NSURLSession calls either the URLSession:task:didReceiveChallenge:completionHandler: or URLSession:didReceiveChallenge:completionHandler: delegate method.
 
 响应来自远程服务器的会话级别认证请求，从代理请求凭据。
 这种方法在两种情况下被调用：
 1、远程服务器请求客户端证书或Windows NT LAN Manager（NTLM）身份验证时，允许您的应用程序提供适当的凭据
 2、当会话首先建立与使用SSL或TLS的远程服务器的连接时，允许您的应用程序验证服务器的证书链
 如果您未实现此方法，则会话会调用其委托的URLSession：task：didReceiveChallenge：completionHandler：方法。
 注：此方法仅处理NSURLAuthenticationMethodNTLM，NSURLAuthenticationMethodNegotiate，NSURLAuthenticationMethodClientCertificate和NSURLAuthenticationMethodServerTrust身份验证类型。对于所有其他认证方案，会话仅调用URLSession：task：didReceiveChallenge：completionHandler：方法。
 
  - (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
  completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler;

 */

/* If an application has received an
 * -application:handleEventsForBackgroundURLSession:completionHandler:
 * message, the session delegate will receive this message to indicate
 * that all messages previously enqueued for this session have been
 * delivered.  At this time it is safe to invoke the previously stored
 * completion handler, or to begin any internal updates that will
 * result in invoking the completion handler.
 
 如果一个应用程序收到了
 -application:handleEventsForBackgroundURLSession:completionHandler:
 消息,session委托将收到此消息指示所有消息之前进行入队这个会话交付。这个时候是安全调用先前存储完成处理器,或开始任何内部更新将导致调用完成处理器。
 
 告诉委托所有session里的消息都已发送。
 这个方法在我们写后台下载的Demo中我们是会遇到的。
 - (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session API_AVAILABLE(ios(7.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos);
*/

/*
 下面是Task解析
 NSURLSessionTask是一个抽象子类，它有三个子类：NSURLSessionDataTask，NSURLSessionUploadTask和NSURLSessionDownloadTask。这三个类封装了现代应用程序的三个基本网络任务：获取数据，比如JSON或XML，以及上传和下载文件。
*/

/*
@interface NSURLSessionTask : NSObject <NSCopying, NSProgressReporting>
@property (readonly)                 NSUInteger    taskIdentifier;    an identifier for this task, assigned by and unique to the owning session
@property (nullable, readonly, copy) NSURLRequest  *originalRequest;  may be nil if this is a stream task
@property (nullable, readonly, copy) NSURLRequest  *currentRequest;   may differ from originalRequest due to http server redirection
// 服务器对当前活动请求的响应
@property (nullable, readonly, copy) NSURLResponse *response;         may be nil if no response has been received

 * NSProgress object which represents the task progress.
 * It can be used for task progress tracking.  进度
 @property (readonly, strong) NSProgress *progress API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0));


 网络负载应该开始的最早日期
 对于从后台NSURLSession实例创建的任务，此属性表示网络负载不应该在此日期之前开始。 设置此属性并不能保证加载将从指定的日期开始，而只是它不会马上开始。 如果未指定，则不使用启动延迟。
 此属性对从非后台会话创建的任务没有影响。
 * Start the network load for this task no earlier than the specified date. If
 * not specified, no start delay is used.
 * 只适用于后台NSURLSession
 * Only applies to tasks created from background NSURLSession instances; has no
 * effect for tasks created from other session types.
 @property (nullable, copy) NSDate * earliestBeginDate API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0));


 
 下面这两个属性其实是比较重要的，两个解释分贝如下：
 1、客户期望发送的字节数的期待上限。
 为此属性设置的值应考虑HTTP头和正文数据或正文流的大小。如果未指定值，则系统将使用NSURLSessionTransferSizeUnknown。该属性由系统用来优化URL会话任务的调度。强烈建议开发人员尽可能提供近似的上限或确切的字节数，而不是接受默认值。
 2、客户期望接收的字节数的期待上限。
 为此属性设置的值应考虑HTTP响应头和响应主体的大小。如果未指定值，则系统将使用NSURLSessionTransferSizeUnknown。该属性由系统用来优化URL会话任务的调度。强烈建议开发人员尽可能提供近似的上限或确切的字节数，而不是接受默认值。
 * The number of bytes that the client expects (a best-guess upper-bound) will
 * be sent and received by this task. These values are used by system scheduling
 * policy. If unspecified, NSURLSessionTransferSizeUnknown is used.
 
 @property int64_t countOfBytesClientExpectsToSend API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0));
 @property int64_t countOfBytesClientExpectsToReceive API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0));


 * Byte count properties may be zero if no body is expected,
 * or NSURLSessionTransferSizeUnknown if it is not possible 
 * to know how many bytes will be transferred.

// 实际发送和接受的字节
number of body bytes already received
@property (readonly) int64_t countOfBytesReceived;
number of body bytes already sent
@property (readonly) int64_t countOfBytesSent;

 
//预计发生的数据，和 Content-Length of the HTTP request 有关
number of body bytes we expect to send, derived from the Content-Length of the HTTP request
@property (readonly) int64_t countOfBytesExpectedToSend;
//预计接收，通常来自HTTP响应的内容长度标题。
number of byte bytes we expect to receive, usually derived from the Content-Length header of an HTTP response.
@property (readonly) int64_t countOfBytesExpectedToReceive;

该任务描述
 * The taskDescription property is available for the developer to
 * provide a descriptive label for the task.
@property (nullable, copy) NSString *taskDescription;

 -cancel returns immediately, but marks a task as being canceled.
 * The task will signal -URLSession:task:didCompleteWithError: with an
 * error value of { NSURLErrorDomain, NSURLErrorCancelled }.  In some 
 * cases, the task may signal other work before it acknowledges the 
 * cancelation.  -cancel may be sent to a task that has been suspended.
 将任务标记为取消
- (void)cancel;

 
 当前任务的状态
 * The current state of the task within the session.
 @property (readonly) NSURLSessionTaskState state;

 错误
 * The error, if any, delivered via -URLSession:task:didCompleteWithError:
 * This property will be nil in the event that no error occured.
 @property (nullable, readonly, copy) NSError *error;

 暂停/恢复
 * Suspending a task will prevent the NSURLSession from continuing to
 * load data.  There may still be delegate calls made on behalf of
 * this task (for instance, to report data received while suspending)
 * but no further transmissions will be made on behalf of the task
 * until -resume is sent.  The timeout timer associated with the task
 * will be disabled while a task is suspended. -suspend and -resume are
 * nestable.
 - (void)suspend;
 - (void)resume;

 
 任务优先级
 * Sets a scaling factor for the priority of the task. The scaling factor is a
 * value between 0.0 and 1.0 (inclusive), where 0.0 is considered the lowest
 * priority and 1.0 is considered the highest.
 *
 * The priority is a hint and not a hard requirement of task performance. The
 * priority of a task may be changed using this API at any time, but not all
 * protocols support this; in these cases, the last priority that took effect
 * will be used.
 *
 * If no priority is specified, the task will operate with the default priority
 * as defined by the constant NSURLSessionTaskPriorityDefault. Two additional
 * priority levels are provided: NSURLSessionTaskPriorityLow and
 * NSURLSessionTaskPriorityHigh, but use is not restricted to these.
 @property float priority API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));

@end
 
下面就是前面说的优先级的值
FOUNDATION_EXPORT const float NSURLSessionTaskPriorityDefault API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT const float NSURLSessionTaskPriorityLow API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));
FOUNDATION_EXPORT const float NSURLSessionTaskPriorityHigh API_AVAILABLE(macos(10.10), ios(8.0), watchos(2.0), tvos(9.0));

/*
 * An NSURLSessionDataTask does not provide any additional
 * functionality over an NSURLSessionTask and its presence is merely
 * to provide lexical differentiation from download and upload tasks.

 @interface NSURLSessionDataTask : NSURLSessionTask
 @end

 @interface NSURLSessionUploadTask : NSURLSessionDataTask
 @end

 * NSURLSessionDownloadTask is a task that represents a download to
 * local storage.（本地存储）
 @interface NSURLSessionDownloadTask : NSURLSessionTask

 
 * 取消下载 但取消的下载资源我们还能继续下载（恢复数据以供以后使用）。只有满足以下条件时才能恢复下载：
 1、请求资源后，资源并未发生变化
 2、该任务是一个HTTP或HTTPS GET请求
 3、服务器在其响应中提供ETag或Last-Modified标头（或两者都有）
 4、服务器支持字节范围请求
 5、系统为响应磁盘空间压力而未删除临时文件
 
 * Cancel the download (and calls the superclass -cancel).  If
 * conditions will allow for resuming the download in the future, the
 * callback will be called with an opaque data blob, which may be used
 * with -downloadTaskWithResumeData: to attempt to resume the download.
 * If resume data cannot be created, the completion handler will be
 * called with nil resumeData.
 
- (void)cancelByProducingResumeData:(void (^)(NSData * _Nullable resumeData))completionHandler;
*/

/*
 @interface NSURLSessionStreamTask : NSURLSessionTask
 
 异步地从流中读取若干个字节，并在完成时调用处理程序。
 读取minBytes或最多maxBytes字节，并在会话委托队列中调用数据或错误的完成处理程序。如果发生错误，任何未完成的读取也将失败，并且新的读取请求将立即出错。
 * Read minBytes, or at most maxBytes bytes and invoke the completion
 * handler on the sessions delegate queue with the data or an error.
 * If an error occurs(发生), any outstanding（未完成） reads will also fail, and new
 * read requests will error out immediately.
 
 - (void)readDataOfMinLength:(NSUInteger)minBytes maxLength:(NSUInteger)maxBytes timeout:(NSTimeInterval)timeout completionHandler:(void (^) (NSData * _Nullable data, BOOL atEOF, NSError * _Nullable error))completionHandler;
 
 将指定的数据异步写入流，并在完成时调用处理程序
 * Write the data completely to the underlying socket.  If all the
 * bytes have not been written by the timeout, a timeout error will
 * occur.  Note that invocation（调用） of the completion handler does not
 * guarantee （确保） that the remote side has received all the bytes, only
 * that they have been written to the kernel.
 - (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout completionHandler:(void (^) (NSError * _Nullable error))completionHandler;
 
 获取流
 完成所有已排队的读取和写入，然后调用URLSession：streamTask：didBecomeInputStream：outputStream：delegate消息。
 收到该消息时，任务对象被视为已完成，并且不会再收到任何委托消息。
 * -captureStreams completes any already enqueued（队列） reads
 * and writes, and then invokes the
 * URLSession:streamTask:didBecomeInputStream:outputStream: delegate
 * message. When that message is received, the task object is
 * considered completed and will not receive any more delegate
 * messages.
 - (void)captureStreams;

 
 排队请求以关闭底层Socket的写入结束。 所有未完成的IO将在Socket的写入端关闭之前完成。
 但是，服务器可能会继续将字节写回到客户端，因此最佳做法是从服务器继续读取，直到你收到EOF。
 * Enqueue a request to close the write end of the underlying socket.
 * All outstanding IO will complete before the write side of the
 * socket is closed.  The server, however, may continue to write bytes
 * back to the client, so best practice is to continue reading from
 * the server until you receive EOF.
 - (void)closeWrite;

 
 排队请求以关闭底层Socket的读取端。 所有未完成的IO将在读取端关闭之前完成。 你可以继续写入服务器。
 * Enqueue a request to close the read side of the underlying socket.
 * All outstanding IO will complete before the read side is closed.
 * You may continue writing to the server.
 - (void)closeRead;

 开始加密握手。 握手在所有待处理IO完成后开始。 TLS认证回调被发送到会话-URLSession：task：didReceiveChallenge：completionHandler：
 * Begin encrypted handshake.  The hanshake begins after all pending
 * IO has completed.  TLS authentication callbacks are sent to the
 * session's -URLSession:task:didReceiveChallenge:completionHandler:
 - (void)startSecureConnection;

 完成所有挂起的安全IO后，干净地关闭安全连接。
 * Cleanly close a secure connection after all pending secure IO has
 * completed.

 - (void)stopSecureConnection;
*/

/*
 * Messages related to the operation of a specific task.
   @protocol NSURLSessionTaskDelegate <NSURLSessionDelegate>
   @optional
*/

/*
 * Sent when the system is ready to begin work for a task with a delayed start
 * time set (using the earliestBeginDate property). The completionHandler must
 * be invoked in order for loading to proceed. The disposition provided to the
 * completion handler continues the load with the original request provided to
 * the task, replaces the request with the specified task, or cancels the task.
 * If this delegate is not implemented, loading will proceed with the original
 * request.
 *
 * Recommendation: only implement this delegate if tasks that have the
 * earliestBeginDate property set may become stale and require alteration prior
 * to starting the network load.
 *
 * If a new request is specified, the allowsCellularAccess property from the
 * new request will not be used; the allowsCellularAccess property from the
 * original request will continue to be used.
 *
 * Canceling the task is equivalent to calling the task's cancel method; the
 * URLSession:task:didCompleteWithError: task delegate will be called with error
 * NSURLErrorCancelled.
 
 告诉代理现在将开始加载延迟的URL会话任务。
 当具有延迟开始时间的后台会话任务（由earliestBeginDate属性设置）准备就绪时，将调用此方法。只有在等待网络负载时请求可能变陈旧并需要被新请求替换时，才应实现此委托方法。
 为了继续加载，委托人必须调用完成处理程序，并传递一个处理方式来指示任务应该如何进行。传递NSURLSessionDelayedRequestCancel处置等效于直接调用任务的取消。
 
   - (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   willBeginDelayedRequest:(NSURLRequest *)request
   completionHandler:(void (^)(NSURLSessionDelayedRequestDisposition disposition, NSURLRequest * _Nullable newRequest))completionHandler
   API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0));
 
 */


/* 告诉代理，在开始网络加载之前，任务正在等待，直到合适的连接可用。
 如果NSURLSessionConfiguration的waitsForConnectivity属性为true并且没有足够的连接，则调用此方法。 代表可以利用这个机会来更新用户界面;
 例如通过呈现离线模式或仅限蜂窝模式。
 此方法最多只能在每个任务中调用一次，并且仅在连接最初不可用时调用。 它永远不会被调用后台会话，因为这些会话会忽略waitsForConnectivity。

 * Sent when a task cannot start the network loading process because the current
 * network connectivity is not available or sufficient for the task's request.
 *
 * This delegate will be called at most one time per task, and is only called if
 * the waitsForConnectivity property in the NSURLSessionConfiguration has been
 * set to YES.
 *
 * This delegate callback will never be called for background sessions, because
 * the waitForConnectivity property is ignored by those sessions.
 
 - (void)URLSession:(NSURLSession *)session taskIsWaitingForConnectivity:(NSURLSessionTask *)task
 API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0));

 
 告诉委托远程服务器请求HTTP重定向。
 此方法仅适用于默认和临时会话中的任务。 后台会话中的任务会自动遵循重定向。
 * An HTTP request is attempting to perform a redirection to a different
 * URL. You must invoke the completion routine to allow the
 * redirection, allow the redirection with a modified request, or
 * pass nil to the completionHandler to cause the body of the redirection
 * response to be delivered as the payload of this request. The default
 * is to follow redirections.
 *
 * For tasks in background sessions, redirections will always be followed and this method will not be called.
 
  - (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
  willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
  completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler;

 
 
 响应来自远程服务器的认证请求，从代理请求凭证。
 该方法处理任务级别的身份验证挑战。 NSURLSessionDelegate协议还提供了会话级别的身份验证委托方法。所调用的方法取决于身份验证挑战的类型：
 对于会话级挑战-NSURLAuthenticationMethodNTLM，NSURLAuthenticationMethodNegotiate，NSURLAuthenticationMethodClientCertificate或NSURLAuthenticationMethodServerTrust - NSURLSession对象调用会话委托的URLSession：didReceiveChallenge：completionHandler：方法。如果您的应用程序未提供会话委托方法，则NSURLSession对象会调用任务委托人的URLSession：task：didReceiveChallenge：completionHandler：方法来处理该挑战。
 对于非会话级挑战（所有其他挑战），NSURLSession对象调用会话委托的URLSession：task：didReceiveChallenge：completionHandler：方法来处理挑战。如果您的应用程序提供会话委托，并且您需要处理身份验证，那么您必须在任务级别处理身份验证，或者提供明确调用每会话处理程序的任务级别处理程序。会话委托的URLSession：didReceiveChallenge：completionHandler：方法不针对非会话级别的挑战进行调用。
 
 * The task has received a request specific authentication challenge.
 * If this delegate is not implemented, the session specific authentication challenge
 * will *NOT* be called and the behavior will be the same as using the default handling
 * disposition.
 
 
 - (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler;
 
 NOTE:注意区分上面的方法 这个是NSURLSessionDelegate代理方法
 - (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler;

 
 
 当任务需要新的请求主体流发送到远程服务器时，告诉委托。
 这种委托方法在两种情况下被调用：
 1、如果使用uploadTaskWithStreamedRequest创建任务，则提供初始请求正文流：
 2、如果任务因身份验证质询或其他可恢复的服务器错误需要重新发送包含正文流的请求，则提供替换请求正文流。
 注：如果代码使用文件URL或NSData对象提供请求主体，则不需要实现此功能。

 * Sent if a task requires a new, unopened body stream.  This may be
 * necessary when authentication has failed for any request that
 * involves a body stream.

 - (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * _Nullable bodyStream))completionHandler;

 
 定期通知代理向服务器发送主体内容的进度。(上传进度)
 * Sent periodically to notify the delegate of upload progress.  This
 * information is also available as properties of the task.
 
  - (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
    didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
    totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;

 告诉代理该会话完成了该任务的收集指标
 * Sent when complete statistics information has been collected for the task.
 
  - (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
    didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics
    API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

 告诉代理该任务完成传输数据
 * Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 
 - (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
    didCompleteWithError:(nullable NSError *)error;
*/


/*
 @protocol NSURLSessionDataDelegate <NSURLSessionTaskDelegate>
 @optional

 * The task has received a response and no further messages will be
 * received until the completion block is called. The disposition
 * allows you to cancel a request or to turn a data task into a
 * download task. This delegate message is optional - if you do not
 * implement it, you can get the response as a property of the task.
 *
 * This method will not be called for background upload tasks (which cannot be converted to download tasks).
 
 - (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler;

 
 告诉代理数据任务已更改为下载任务。
 当委托的URLSession：dataTask：didReceiveResponse：completionHandler：方法决定将数据请求的处置更改为下载时，会话将调用此委托方法为你提供新的下载任务。 在此调用之后，会话委托不会收到与原始数据任务相关的其他委托方法调用。
 * Notification that a data task has become a download task.  No
 * future messages will be sent to the data task.
 
 - (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask;


 
 
 告诉委托数据任务已更改为流任务
 当委托的URLSession：dataTask：didReceiveResponse：completionHandler：方法决定将处置从数据请求更改为流时，会话将调用此委托方法为你提供新的流任务。 在此调用之后，会话委托不会收到与原始数据任务相关的其他委托方法调用。
 
 对于pipelined的请求，流任务将只允许读取，并且对象将立即发送委托消息URLSession：writeClosedForStreamTask :. 通过在其NSURLSessionConfiguration对象上设置HTTPShouldUsePipelining属性，或通过在NSURLRequest对象上设置HTTPShouldUsePipelining属性来为各个请求设置会话中的所有请求，可以禁用管道传输。
 
 * Notification that a data task has become a bidirectional stream
 * task.  No future messages will be sent to the data task.  The newly
 * created streamTask will carry the original request and response as
 * properties.
 *
 * For requests that were pipelined, the stream object will only allow
 * reading, and the object will immediately issue a
 * -URLSession:writeClosedForStream:.  Pipelining can be disabled for
 * all requests in a session, or by the NSURLRequest
 * HTTPShouldUsePipelining property.
 *
 * The underlying connection is no longer considered part of the HTTP
 * connection cache and won't count against the total number of
 * connections per host.
 
  - (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
  didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask;

 
 告诉代理该数据任务已经收到了一些预期的数据。
 由于NSData对象通常是由许多不同的数据对象拼凑而成的，因此尽可能使用NSData的enumerateByteRangesUsingBlock：方法遍历数据，而不是使用bytes方法（将NSData对象平化为单个内存块）。
 此委托方法可能被多次调用，并且每次调用仅提供自上次调用后收到的数据。 如果需要，该应用负责积累这些数据。

 * Sent when data is available for the delegate to consume.  It is
 * assumed that the delegate will retain and not copy the data.  As
 * the data may be discontiguous, you should use
 * [NSData enumerateByteRangesUsingBlock:] to access it.
 
 - (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data;

 
 
 
 询问委托数据（或上传）任务是否应将响应存储在缓存中。
 会话在任务完成接收所有预期数据后调用此委托方法。如果未实现此方法，则默认行为是使用会话配置对象中指定的缓存策略。
 此方法的主要目的是防止特定URL的缓存或修改与URL响应关联的userInfo字典。
 只有在处理请求的NSURLProtocol决定缓存响应时才调用此方法。通常，只有满足以下所有条件时才会缓存响应：
 1、请求是针对HTTP或HTTPS URL（或你自己的支持缓存的自定义网络协议）。
 2、请求成功（状态码在200-299范围内）。
 3、提供的响应来自服务器，而不是缓存。
 4、会话配置的缓存策略允许缓存。
 5、提供的NSURLRequest对象的缓存策略（如果适用）允许缓存。
 6、服务器响应中的缓存相关头（如果存在）允许缓存。
 7、响应大小足够小，可以合理地放入缓存中。 （例如，如果您提供磁盘缓存，则响应不得超过磁盘缓存大小的5％。）
 注：如果委托实现此方法，则它必须调用completionHandler完成处理程序;否则，应用程序会泄漏内存。
 
 * Invoke the completion routine with a valid NSCachedURLResponse to
 * allow the resulting data to be cached, or pass nil to prevent
 * caching. Note that there is no guarantee that caching will be
 * attempted for a given resource, and you should not rely on this
 * message to receive the resource data.

 - (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler;

*/



/* 下载代理
 * Messages related to the operation of a task that writes data to a
 * file and notifies the delegate upon completion.
   @protocol NSURLSessionDownloadDelegate <NSURLSessionTaskDelegate>


 下载完成
 * Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location;

 
@optional
下载进度
Sent periodically to notify the delegate of download progress.
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
        didWriteData:(int64_t)bytesWritten
        totalBytesWritten:(int64_t)totalBytesWritten
        totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

 
 下载任务已经恢复下载。
 
 参数：filrOffest:
 如果文件的缓存策略或上次修改日期阻止重新使用现有内容，则该值为零。否则，该值是一个整数，表示磁盘上不需要再次检索的字节数。
 如果可恢复的下载任务被取消或失败，可以请求resumeData对象，该对象将提供足够的信息以重新开始下载。
 稍后，你可以调用downloadTaskWithResumeData：或downloadTaskWithResumeData：completionHandler：使用该数据。
 当你调用这些方法时，你会得到一个新的下载任务。只要恢复该任务，会话就会使用该新任务调用其委托的
 URLSession：downloadTask：didResumeAtOffset：expectedTotalBytes：方法，以指示恢复下载。
 
 * Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
        didResumeAtOffset:(int64_t)fileOffset
        expectedTotalBytes:(int64_t)expectedTotalBytes;

*/

/*
 

 @protocol NSURLSessionStreamDelegate <NSURLSessionTaskDelegate>
 @optional

 告诉委托底层Socket的读取面已经关闭。
 即使当前过程没有读取，也可以调用此方法。 此方法并不表示流达到end-of-file（EOF），从而不能读取更多数据。
 
 * Indicates that the read side of a connection has been closed.  Any
 * outstanding（未解决） reads complete, but future reads will immediately fail.
 * This may be sent even when no reads are in progress. However, when
 * this delegate message is received, there may still be bytes
 * available.  You only know that no more bytes are available when you
 * are able to read until EOF.
- (void)URLSession:(NSURLSession *)session readClosedForStreamTask:(NSURLSessionStreamTask *)streamTask;

 上面读这个就是写的说明
 告诉委托底层套接字的写入端已关闭。
 即使当前过程没有写入，也可以调用此方法。
 * Indicates(表明) that the write side of a connection has been closed.
 * Any outstanding writes complete, but future writes will immediately
 * fail.

- (void)URLSession:(NSURLSession *)session writeClosedForStreamTask:(NSURLSessionStreamTask *)streamTask;

 
 告诉委托流已经检测到通往主机更好的路由  下面的例子是WiFi可用了
 * A notification that the system has determined that a better route
 * to the host has been detected (eg, a wi-fi interface becoming
 * available.)  This is a hint to the delegate that it may be
 * desirable to create a new task for subsequent（随后） work.  Note that
 * there is no guarantee that the future task will be able to connect
 * to the host, so callers should should be prepared for failure of
 * reads and writes over any new interface.
- (void)URLSession:(NSURLSession *)session betterRouteDiscoveredForStreamTask:(NSURLSessionStreamTask *)streamTask;

 告诉委托，流任务已完成，由于流任务调用captureStreams方法。
 此委托方法仅在流任务的所有入队读取和写入操作完成后才会调用。
 * The given task has been completed, and unopened NSInputStream and
 * NSOutputStream objects are created from the underlying 底层 network
 * connection.  This will only be invoked after all enqueued IO has
 * completed (including any necessary handshakes.)  The streamTask
 * will not receive any further delegate messages.
 *
- (void)URLSession:(NSURLSession *)session streamTask:(NSURLSessionStreamTask *)streamTask
        didBecomeInputStream:(NSInputStream *)inputStream
        outputStream:(NSOutputStream *)outputStream;

*/


/*
 * This class defines the performance（性能） metrics collected for a request/response transaction during the task execution.执行
 API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0))
 @interface NSURLSessionTaskTransactionMetrics : NSObject
 */


/*
   presents 礼物复数  表现
 * Represents 代表 the transaction request.
   @property (copy, readonly) NSURLRequest *request;
 */


/*
   如果发生错误并且没有生成响应，则可以为nil
 * Represents the transaction response. Can be nil if error occurred and no response was generated.
   @property (nullable, copy, readonly) NSURLResponse *response;
 */


/*
 * fetchStartDate returns the time when the user agent started fetching the resource, whether or not the resource was retrieved from the server or local resources.
 * 用户代理开始获取资源的时间，无论是否从服务器或本地资源中检索资源。
 * The following metrics will be set to nil, if a persistent connection was used or the resource was retrieved from local resources:
 *
 *   domainLookupStartDate
 *   domainLookupEndDate
 *   connectStartDate
 *   connectEndDate
 *   secureConnectionStartDate
 *   secureConnectionEndDate
 
     @property (nullable, copy, readonly) NSDate *fetchStartDate;
 */


/* 用户代理启动资源名称查找之前的时间。
 * domainLookupStartDate returns the time immediately before the user agent started the name lookup for the resource.
   @property (nullable, copy, readonly) NSDate *domainLookupStartDate;
 */


/* 名称查询完成后的时间。
 * domainLookupEndDate returns the time after the name lookup was completed.
   @property (nullable, copy, readonly) NSDate *domainLookupEndDate;
 */


/* 用户代理开始建立到服务器的连接之前的时间。
 * connectStartDate is the time immediately before the user agent started establishing the connection to the server.
 *
 * For example, this would correspond to the time immediately before the user agent started trying to establish the TCP connection.
   @property (nullable, copy, readonly) NSDate *connectStartDate;
 */


/* 如果使用加密连接，则secureConnectionStartDate是用户代理刚刚开始安全握手以保护当前连接之前的时间。如果未使用加密连接，则此属性设置为零。
 * If an encrypted 加密 connection was used, secureConnectionStartDate is the time immediately before the user agent 代理 started the
   security 安全 handshake to secure the current connection.
 *
 * For example, this would correspond to the time immediately before the user agent started the TLS handshake.
 *
 * If an encrypted connection was not used, this attribute is set to nil.
   @property (nullable, copy, readonly) NSDate *secureConnectionStartDate;
 */


/* 如果使用加密连接，则secureConnectionEndDate是安全握手完成后的时间。如果未使用加密连接，则此属性设置为零
 * If an encrypted connection was used, secureConnectionEndDate is the time immediately after the security handshake completed.
 *
 * If an encrypted connection was not used, this attribute is set to nil.
   @property (nullable, copy, readonly) NSDate *secureConnectionEndDate;
 */


/* 用户代理完成与服务器建立连接后的时间，包括完成与安全相关的握手和其他握手
 * connectEndDate is the time immediately after the user agent finished establishing the connection to the server, including completion of security-related and other handshakes.
   @property (nullable, copy, readonly) NSDate *connectEndDate;
 */


/* 用户代理开始请求源之前的时间，无论是从服务器还是从本地资源中检索资源。
 * requestStartDate is the time immediately before the user agent started requesting the source, regardless of whether the resource was retrieved from the server or local resources.
 *
 * For example, this would correspond to the time immediately before the user agent sent an HTTP GET request.
   @property (nullable, copy, readonly) NSDate *requestStartDate;
 */


/* 用户代理完成请求源后的时间，无论资源是从服务器还是从本地资源中检索
 * requestEndDate is the time immediately after the user agent finished requesting the source, regardless of whether the resource was retrieved from the server or local resources.
 *
 * For example, this would correspond to the time immediately after the user agent finished sending the last byte of the request.
   @property (nullable, copy, readonly) NSDate *requestEndDate;
 */


/* 用户代理刚收到服务器或本地资源响应的第一个字节后的时间。
 * responseStartDate is the time immediately after the user agent received the first byte of the response from the server or from local resources.
 *
 * For example, this would correspond to the time immediately after the user agent received the first byte of an HTTP response.
   @property (nullable, copy, readonly) NSDate *responseStartDate;
 */


/* 用户代理收到资源的最后一个字节后的时间。
 * responseEndDate is the time immediately after the user agent received the last byte of the resource.
   @property (nullable, copy, readonly) NSDate *responseEndDate;
 */


/* 用于获取资源的网络协议，由ALPN协议ID标识序列[RFC7301]标识。如果配置了代理并建立了隧道连接，则此属性将返回隧道协议的值。
 * The network protocol used to fetch the resource, as identified by the ALPN Protocol ID Identification Sequence [RFC7301].
 * E.g., h2, http/1.1, spdy/3.1.
 *
 * When a proxy is configured AND a tunnel connection is established, then this attribute returns the value for the tunneled protocol.
 *
 * For example:
 * If no proxy were used, and HTTP/2 was negotiated, then h2 would be returned.
 * If HTTP/1.1 were used to the proxy, and the tunneled connection was HTTP/2, then h2 would be returned.
 * If HTTP/1.1 were used to the proxy, and there were no tunnel, then http/1.1 would be returned.
 
   @property (nullable, copy, readonly) NSString *networkProtocolName;
 *
 */


/* 如果使用代理连接来获取资源，则此属性设置为YES。
 * This property is set to YES if a proxy connection was used to fetch the resource.
 
   @property (assign, readonly, getter=isProxyConnection) BOOL proxyConnection;
 */


/* 如果使用持续连接来获取资源，则此属性设置为YES
 * This property is set to YES if a persistent connection was used to fetch the resource.
 
   @property (assign, readonly, getter=isReusedConnection) BOOL reusedConnection;
 */


/* 指示资源是否已从本地缓存中加载，推送或检索。
 * Indicates whether the resource was loaded, pushed or retrieved from the local cache.
 
   @property (assign, readonly) NSURLSessionTaskMetricsResourceFetchType resourceFetchType;
 */

// -(instancetype)init;



/* API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0))
   @interface NSURLSessionTaskMetrics : NSObject
 */

/* 包含为在任务执行期间创建的每个请求/响应事务收集的度量标准。
 * transactionMetrics array contains the metrics collected for every request/response transaction created during the task execution.
   @property (copy, readonly) NSArray<NSURLSessionTaskTransactionMetrics *> *transactionMetrics;
 */

/* 从任务创建时间到任务完成时间的时间间隔。
 * Interval from the task creation time to the task completion time.
 * Task creation time is the time when the task was instantiated.
 * Task completion time is the time when the task is about to change its internal state to completed.
 
   @property (copy, readonly) NSDateInterval *taskInterval;

 */

/* 记录的重定向的数量。
 * redirectCount is the number of redirects that were recorded.
 
   @property (assign, readonly) NSUInteger redirectCount;
 */


//-(instancetype)init;


@end
