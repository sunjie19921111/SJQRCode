//
//  SJQRCodeController.m
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

#import "SJQRCodeController.h"
#import "SJScanningView.h"
#import "SJCameraViewController.h"
#import "UIAlertView+SJAddtions.h"

typedef void(^successMessageBlock)(NSString *messageString);

#define kIsAuthorizedString @"请在iOS - 设置 － 隐私 － 相机 中打开相机权限"
#define kiOS8 [[UIDevice currentDevice].systemVersion integerValue]

@interface SJQRCodeController  ()<SJCameraControllerDelegate,SJScanningViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIView *preview;
@property (nonatomic, strong) SJScanningView *scanningView;
@property (nonatomic, strong) SJCameraViewController *cameraController;
@property (nonatomic, strong) UIImagePickerController *pickerController;
@property (nonatomic, copy) successMessageBlock block;

@end

@implementation SJQRCodeController

- (SJScanningView *)scanningView {
    if (_scanningView == nil) {
        _scanningView = [[SJScanningView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _scanningView.scanningDelegate = self;
    }
    return _scanningView;
}

- (UIView *)preview {
    if (!_preview) {
        _preview = [[UIView alloc] initWithFrame:self.view.bounds];
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

#pragma mark - Life Cycle

+ (instancetype)QRCodeSuccessMessageBlock:(void (^)(NSString *))block {
    SJQRCodeController *QRCodeController = [[SJQRCodeController alloc] init];
    QRCodeController.block = block;
    return QRCodeController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self isCameraIsAuthorized]) {
        [self setupView];
    } else {
        UIAlertView *alert  =  [UIAlertView alertViewTitle:@"相机权限提示" message:kIsAuthorizedString  delegate:self cancelButtonTitle:@"知道了"];
        alert.tag = 886;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SetUp View

- (void)setupView {
    [self.view addSubview:self.preview];
    [self.view addSubview:self.scanningView];
    [self.cameraController showCaptureOnView:self.preview];
    [self.scanningView scanning];
}

#pragma mark - The Camera is Authorized

- (BOOL)isCameraIsAuthorized {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusDenied){
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    return YES;
}

#pragma mark - SJScanningViewDelegate BarButtonItem Click Event

- (void)clickBarButtonItemSJButtonType:(SJSCanningViewButton)btn {
    if (btn == SJSCanningViewButtonExit) {
        [self.cameraController stopSession];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (btn == SJSCanningViewButtonTorch) {
        [self setTorchMode];
    } else if (btn == SJSCanningViewButtonAlbum) {
        [self openImagePickerController];
    }
}

#pragma mark - Configuration Torch

- (void)setTorchMode {
    if ([self.cameraController cameraHasTorch]) {
        [self configurationTorch];
    } else {
        return;
    }
}

#pragma mark - Torch Click

- (void)configurationTorch {
    UIButton *button = [self.scanningView viewWithTag:SJSCanningViewButtonTorch];
    button.selected = !button.selected;
    if (button.selected) {
        [self.cameraController setTorchMode:AVCaptureTorchModeOn];
    } else {
        [self.cameraController setTorchMode:AVCaptureTorchModeOff];
    }
}

#pragma mark - Open imagePickController

- (void)openImagePickerController {
    [self presentViewController:self.pickerController animated:YES completion:nil];
}

#pragma mark - SJCameraControllerDelegate

- (void)cameraControllerDidDetectCodes:(NSString *)codesString {
    [self.scanningView removeScanningAnimations];
    if (self.block) {
        self.block(codesString);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info; {
    UIImage *pickerImage= [info objectForKey:UIImagePickerControllerOriginalImage];
    if (kiOS8 >= 8.0) {
      NSString *resultString = [self.cameraController readAlbumQRCodeImage:pickerImage];
      if (self.block) {
            [self dismissViewControllerAnimated:NO completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            self.block(resultString);
          
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 886) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - StatusBarStyle

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
