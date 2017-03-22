# SJQRCode
 A very simple, use the original qr code scanning of the library （一个非常简单，好用的原生态二维码扫描的库）
 
Support version（支持版本）：
1.Read the photo album of qr code only support ios8 over the system（读取相册中的二维码只支持ios8以上的系统）
2.Qr code and code support ios7 over the system（扫码二维码支持ios7以上的系统）

The content is introduced（内容介绍）：
QRCode (qr code scanning) using iOS system framework, implementation of qr code scanning, code is mainly divided into three module
（QRCode(二维码扫描) 使用iOS系统自带框架，实现二维码的的扫描，代码主要分为三个模块）
 1. SJCameraViewController Configure the camera attributes（配置相机属性） 
 2. SJScanningView Set up view（建立视图） 
 3. SJViewController Realize the function（实现功能）

1. SJCameraViewControlle introduced （SJCameraViewControlle简介）
   // Configuration and control the capture session （配置和控制捕捉会话）
  -(void)stopSession;
  -(void)startSession;
  -(BOOL)setupSession:(NSError **)error;

  //Set the resolution （设置分辨率）
  -(NSString *)sessionPreset;

  //The session configure input and output （配置输入和输出会话）
  -(BOOL)setupSessionInputs:(NSError **)error;
  -(BOOL)setupSessionOutputs:(NSError **)error;

  //The camera shows view （相机显示视图）
  -(void)showCaptureOnView:(UIView *)preview;

  //Read the qr code picture album （读取相册二维码的图片）
  -(NSString *)readAlbumQRCodeImage:(UIImage )imagePicker;

2. SJScanningView introduced （SJScanningView 简介）：

  //The animation of the scan line （扫描线段的动画）
  -(void)scanning; 
   //Remove the animation （移除动画）
  -(void)removeScanningAnimations;

3.SJViewController introduced (SJViewController 简介)
  //set up view (建立视图)
  -(void)setupView { [self.view addSubview:self.preview]; [self.view addSubview:self.scanningView];
  
  //To determine whether a camera (判断相机是否授权)
  -(BOOL)isCameraIsAuthorized { AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]; if(authStatus == AVAuthorizationStatusDenied){ return NO; } else if (authStatus == AVAuthorizationStatusAuthorized) { return YES; } return YES; }

  //The results of the scan the qr code (扫描二维码的结果)
  -(void)didDetectCodes:(NSArray *)codesArr 

  

 use (如何使用)：

1：Download this code making address (下载本代码 github地址)：https://github.com/sunjie19921111/SJQRCode
2: Put the SJQRCode in your project (把SJQRCode放进去你的工程)
3: The implementation code （实现代码）
   { 
      SJViewController *viewController = [[SJViewController alloc] init];
    //successString Scan successfully returns to the data (功返回来的数据)
    viewController.successBlock = ^(NSString *successString) {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:viewController animated:YES completion:nil];
    }
If you have questions, please leave a message.Or email, please everybody many help, thank you (如有问题，请留言。或者邮件，请大家多多指点，谢谢大家。)
