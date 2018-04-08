//
//  AVPlayerViewControllerManager.h
//  mediaPlay
//
//  Created by SKOTC on 2018/2/28.
//  Copyright © 2018年 CAOMEI. All rights reserved.
//

/*
File:  AVPlayerViewController.h
Framework:  AVKit
Copyright © 2014-2017 Apple Inc. All rights reserved.
导入库头文件
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
//AVPlayerViewController有这个代理，这个代理方法就在下面
@protocol AVPlayerViewControllerDelegate;

@class           AVPlayerViewController
这个摘要说明了AVPlayerViewController这个控制器的基本特征
@abstract        AVPlayerViewController is a subclass of UIViewController that can be used to display the visual content of an AVPlayer object and the standard playback controls.

// 8.0之后有的AVPlayerViewController
API_AVAILABLE(ios(8.0))
@interface AVPlayerViewController : UIViewController
 
// 简单的播放器AVPlayer属性
@property        player
@abstract        The player from which to source the media content for the view controller.
@property (nonatomic, strong, nullable) AVPlayer *player;

// 是否展示添加在上面的子控件
@property        showsPlaybackControls
@abstract        Whether or not the receiver shows playback controls. Default is YES.
@discussion        Clients can set this property to NO when they don't want to have any playback controls on top of the visual content (e.g. for a game splash screen).
@property (nonatomic) BOOL showsPlaybackControls;

// 这个属性字面意思是视频重力  其实它是用来确定在承载层的范围内视频可以拉伸或者缩放的程度
// 具体的在下面@discussion部分有讨论，我们再总结一下它三个值分别代表的含义
// AVLayerVideoGravityResizeAspect 会在承载层的范围内缩放视频的大小来保持视频的原始比例宽高，默认值
// AVLayerVideoGravityResizeAspectFill 保留视频的宽高比，并且通过缩放填满整个播放界面
// AVLayerVideoGravityResize 会将视频内容拉伸匹配承载层的范围，一般不常用，因为会把图片扭曲导致变形
@property        videoGravity
@abstract        A string defining how the video is displayed within an AVPlayerLayer bounds rect.
@discussion      Options are AVLayerVideoGravityResizeAspect, AVLayerVideoGravityResizeAspectFill and AVLayerVideoGravityResize. AVLayerVideoGravityResizeAspect is default.
 See <AVFoundation/AVAnimation.h> for a description of these options.
@property (nonatomic, copy) NSString *videoGravity;

// 通过这个bool类型的值确定视频是否已经准备好展示
@property        readyForDisplay
@abstract        Boolean indicating that the first video frame has been made ready for display for the current item of the associated AVPlayer.
@property (nonatomic, readonly, getter = isReadyForDisplay) BOOL readyForDisplay;

// 视频的尺寸
@property        videoBounds
@abstract        The current size and position of the video image as displayed within the receiver's view's bounds.
@property (nonatomic, readonly) CGRect videoBounds;

// 有自定义的控件可以添加在这里UIView上
@property        contentOverlayView
@abstract        Use the content overlay view to add additional custom views between the video content and the controls.
@property (nonatomic, readonly, nullable) UIView *contentOverlayView;

// 是否允许使用画中画播放模式，这个画中画播放在下面会写Demo  9.0之后的属性
@property        allowsPictureInPicturePlayback
@abstract        Whether or not the receiver allows Picture in Picture playback. Default is YES.
@property (nonatomic) BOOL allowsPictureInPicturePlayback API_AVAILABLE(ios(9.0));

// 10.0之后的属性
@property        updatesNowPlayingInfoCenter
@abstract        Whether or not the now playing info center should be updated. Default is YES.
@property (nonatomic) BOOL updatesNowPlayingInfoCenter API_AVAILABLE(ios(10.0));

// 理解摘要的意思是是否允许点击播放之后自动全屏播放视频  默认值是NO
@property        entersFullScreenWhenPlaybackBegins
@abstract        Whether or not the receiver automatically enters full screen when the play button is tapped. Default is NO.
@discussion      If YES, the receiver will show a user interface tailored to this behavior.
@property (nonatomic) BOOL entersFullScreenWhenPlaybackBegins API_AVAILABLE(ios(11.0));

// 也是理解摘要，是否允许退出全屏播放在播放结束之后
@property        exitsFullScreenWhenPlaybackEnds
@abstract        Whether or not the receiver automatically exits full screen when playback ends. Default is NO.
@discussion      If multiple player items have been enqueued, the receiver exits fullscreen once no more items are remaining in the queue.
@property (nonatomic) BOOL exitsFullScreenWhenPlaybackEnds API_AVAILABLE(ios(11.0));

 
// AVPlayerViewControllerDelegate代理
@property        delegate
@abstract        The receiver's delegate.
@property (nonatomic, weak, nullable) id <AVPlayerViewControllerDelegate> delegate API_AVAILABLE(ios(9.0));
@end


// 下面就是AVPlayerViewControllerDelegate代理方法  下面的代理方法都是optional可选的
@protocol        AVPlayerViewControllerDelegate
@abstract        A protocol for delegates of AVPlayerViewController.
@protocol AVPlayerViewControllerDelegate <NSObject>
@optional


@method          playerViewControllerWillStartPictureInPicture:
@param           playerViewController The player view controller.
@abstract        Delegate can implement this method to be notified when Picture in Picture will start.
// 即将开始画中画播放
- (void)playerViewControllerWillStartPictureInPicture:(AVPlayerViewController *)playerViewController;

 
@method          playerViewControllerDidStartPictureInPicture:
@param           playerViewController  The player view controller.
@abstract        Delegate can implement this method to be notified when Picture in Picture did start.
// 已经开始了画中画播放模式
- (void)playerViewControllerDidStartPictureInPicture:(AVPlayerViewController *)playerViewController;


@method          playerViewController:failedToStartPictureInPictureWithError:
@param           playerViewController  The player view controller.
@param           error An error describing why it failed.
@abstract        Delegate can implement this method to be notified when Picture in Picture failed to start.
// 这个摘要已经给我们说的比较清楚了，当画中画模式播放失败之后就会走这个代理方法
- (void)playerViewController:(AVPlayerViewController *)playerViewController failedToStartPictureInPictureWithError:(NSError *)error;


@method          playerViewControllerWillStopPictureInPicture:
@param           playerViewController The player view controller.
@abstract        Delegate can implement this method to be notified when Picture in Picture will stop.
// 画中画播放模式即将结束
- (void)playerViewControllerWillStopPictureInPicture:(AVPlayerViewController *)playerViewController;


@method          playerViewControllerDidStopPictureInPicture:
@param           playerViewController  The player view controller.
@abstract        Delegate can implement this method to be notified when Picture in Picture did stop.
// 画中画播放已经结束
- (void)playerViewControllerDidStopPictureInPicture:(AVPlayerViewController *)playerViewController;


@method          playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:
@param           playerViewController   The player view controller.
@abstract        Delegate can implement this method and return NO to prevent（阻止） player view controller from automatically being dismissed when Picture in Picture starts.
// 要是在画中画开始播放的时候 播放的底层控制器要是消失就返回NO
- (BOOL)playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:(AVPlayerViewController *)playerViewController;


@method          playerViewController:restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:
@param           playerViewController  The player view controller.
@param           completionHandler  The completion handler the delegate needs to call after restore.
@abstract        Delegate can implement this method to restore（恢复） the user interface（交互） before Picture in Picture stops.
//  画中画播放结束恢复用户交互
- (void)playerViewController:(AVPlayerViewController *)playerViewController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler;

@end
NS_ASSUME_NONNULL_END
*/
 
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerViewControllerManager : UIViewController



@end
