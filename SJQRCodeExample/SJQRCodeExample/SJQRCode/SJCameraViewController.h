//
//  SJCameraViewController.h
// Copyright (c) 2011–2017 Alamofire Software Foundation
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol SJCameraControllerDelegate <NSObject>

/** 扫描二维码结果 */
- (void)cameraControllerDidDetectCodes:(NSString *)codesString;

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
