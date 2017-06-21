//
//  ViewController.m
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

#import "SJViewController.h"
#import "SJScanningView.h"
#import "SJCameraViewController.h"
#import "UIAlertView+SJAddtions.h"

#define kIsAuthorizedString @"请在iOS - 设置 － 隐私 － 相机 中打开相机权限"
#define kiOS8 [[UIDevice currentDevice].systemVersion integerValue]

@interface SJViewController ()<SJCameraControllerDelegate,SJScanningViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIView *preview;
@property (nonatomic, assign)   BOOL   isLoad;
@property (nonatomic, strong) SJScanningView *scanningView;
@property (nonatomic, strong) SJCameraViewController *cameraController;
@property (nonatomic, strong) UIImagePickerController *pickerController;

@end

@implementation SJViewController

#pragma mark - Properts

- (SJScanningView *)scanningView {
    if (_scanningView == nil) {
        _scanningView = [[SJScanningView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _scanningView.scanningDelegate = self;
    }
    return _scanningView;
}

- (UIView *)preview {
    if (!_preview) {
        _preview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _preview;
}

- (SJCameraViewController *)cameraController {
    if (!_cameraController) {
        _cameraController = [[SJCameraViewController alloc] init];
        _cameraController.delegate = self;
    }
    return _cameraController;
}

- (UIImagePickerController *)pickerController {
    if (!_pickerController) {
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _pickerController.delegate = self;
        _pickerController.allowsEditing = NO;
    }
    return _pickerController;
}

- (void)setIsCenter:(BOOL)isCenter {
    _isCenter = isCenter;
    if (_isCenter == YES) {
        self.cameraController.rectrectOfInterest = scanningRect;
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoad = YES;
    self.isCenter = YES;
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self isCameraIsAuthorized]) {
        if (self.isLoad == YES) {
            [self setupView];
        }
    } else {
        UIAlertView *alert  =  [UIAlertView alertViewTitle:@"相机权限提示" message:kIsAuthorizedString  delegate:self cancelButtonTitle:@"知道了"];
        alert.tag = 1;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.cameraController = nil;
    self.preview = nil;
    self.scanningView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - SetUp View

/** 建立视图 */
- (void)setupView {
    [self.scanningView scanning];
    [self.view addSubview:self.preview];
    [self.view addSubview:self.scanningView];
    [self.cameraController showCaptureOnView:self.preview];
}

#pragma mark - The Camera is Authorized

/** 是否授权 */
- (BOOL)isCameraIsAuthorized {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusDenied){
        return NO;
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    return YES;
}

#pragma mark - SJScanningViewDelegate BarBUttonItem 点击事件

/** 按钮的点击事件 */
- (void)clickBarButtonItemSJButtonType:(SJButtonType)type {
    if (type == SJButtonTypeReturn) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (type == SJButtonTypeTorch) {
        [self setTorchMode];
    } else if (type == SJButtonTypeAlbum) {
        [self openImagePickerController];
    }
}

#pragma mark - Configuration Torch

/** 配置手电筒 */
- (void)setTorchMode {
    if ([self.cameraController cameraHasTorch]) {
        [self configurationTorch];
    } else {
        [UIAlertView alertViewTitle:@"温馨提示！" message:@"您的闪光灯无法开启，请检查" delegate:self cancelButtonTitle:@"知道了"];
    }
}

#pragma mark - Torch Click


- (void)configurationTorch {
    UIButton *button = [self.scanningView viewWithTag:SJButtonTypeTorch];
    button.selected = !button.selected;
    if (button.selected) {
        [self.cameraController setTorchMode:AVCaptureTorchModeOn];
    } else {
        [self.cameraController setTorchMode:AVCaptureTorchModeOff];
    }
}

#pragma mark - Open imagePickController

/** 打开相册 */
- (void)openImagePickerController {
    [self.cameraController stopSession];
    [self presentViewController:self.pickerController animated:YES completion:nil];
}

#pragma mark - SJCameraControllerDelegate

/** codesString 扫描二维码返回的结果 */
- (void)didDetectCodes:(NSString *)codesString {
    [self.scanningView removeScanningAnimations];
    if (self.successBlock) {
        self.successBlock(codesString);
    }
}

#pragma mark - UIImagePickerControllerDelegate

/** alertMessageString 读取相册中二维码相册的结果*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info; {
    UIImage *pickerImage= [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *resultString = nil;
    if (kiOS8 >= 8.0) {
        resultString = [self.cameraController readAlbumQRCodeImage:pickerImage];
        if (self.successBlock) {
            self.successBlock(resultString);
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        //self.isLoad = NO;
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - StatusBarStyle

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    [self.cameraController stopSession];
    self.cameraController = nil;
    self.preview = nil;
    self.scanningView = nil;
}

@end
