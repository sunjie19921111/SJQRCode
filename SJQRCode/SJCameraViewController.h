//
//  SJCameraViewController.h
//  SJQRCode
//
//  Created by Sunjie on 16/11/15.
//  Copyright © 2016年 Sunjie. All rights reserved.
//
// 项目还未完成，将继续更新。
//
//
// 初次封装代码，有不足的地方，请大神指教  邮箱：15220092519@163.com
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol SJCameraControllerDelegate <NSObject>

/** 扫描二维码结果 */
- (void)didDetectCodes:(NSString *)codesString;

@end

FOUNDATION_EXPORT NSString *const SJCameraErrorDomain;
FOUNDATION_EXPORT NSString *const SJCameraErrorFailedToAddInput;

/** 会话的错误信息 */
typedef NS_ENUM(NSInteger, SJCameraErrorCode) {
    SJCameraErrorCodeFailedToAddInput = 98,
    SJCameraErrorCodeFailedToAddOutput    ,
};

@interface SJCameraViewController : NSObject

@property (nonatomic, assign) id <SJCameraControllerDelegate> delegate;
@property (nonatomic, strong) AVCaptureSession *captureSession;
/** 捕捉区域暂时未用到 */
@property (nonatomic, assign) CGRect rectrectOfInterest;
/** 检测手电筒是否能用 */
@property (nonatomic, assign) BOOL cameraHasTorch;
/** 手电筒模式 */
@property (nonatomic, assign) AVCaptureTorchMode torchMode;

/** 配置会话 */
- (void)startSession;
- (void)stopSession;
- (BOOL)setupSession:(NSError **)error;

/** 设置相机最大支持的分辨率 */
- (NSString *)sessionPreset;
/** 配置输入输出 */
- (BOOL)setupSessionInputs:(NSError **)error;
- (BOOL)setupSessionOutputs:(NSError **)error;

/** 设置相机显示的UIView */
- (void)showCaptureOnView:(UIView *)preview;
/** 读取相册里面二维码的信息 */
- (NSString *)readAlbumQRCodeImage:(UIImage *)imagePicker;

@end
