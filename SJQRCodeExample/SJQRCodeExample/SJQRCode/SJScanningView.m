//
//  SJScanningView.m
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

#import "SJScanningView.h"

#define kSJQRCodeTipString              @"将二维码/条形码放入框内，即可自动扫描"
#define kSJQRCodeUnRestrictedTipString  @"请在%@的\"设置-隐私-相机\"选项中，\r允许%@访问你的相机。"

static const CGFloat kSJQRCodeRectPaddingX = 55;
static const CGFloat kBtnWidth = 44;
static const CGFloat kBtnTopMargin = 20;
static const CGFloat kBtnMargin = 10;

static CGRect scanningRect;

@interface SJScanningView ()

/** 是否授权 */
@property (nonatomic, assign) BOOL isRestrict;
@property (nonatomic, assign) CGRect cleanRect;
@property (nonatomic, assign) CGRect scanningRect;
@property (nonatomic, strong) UILabel *QRCodeTipLabel;
@property (nonatomic, strong) UIImageView *scanningImageView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preViewLayer;

@end

@implementation SJScanningView

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
        self.cleanRect = CGRectMake(kSJQRCodeRectPaddingX, 110, CGRectGetWidth(frame) - kSJQRCodeRectPaddingX * 2, CGRectGetWidth(frame) - kSJQRCodeRectPaddingX * 2);
    }
    return self;
}

#pragma mark - Propertys

- (UIImageView *)scanningImageView {
    if (!_scanningImageView) {
        _scanningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 130, CGRectGetWidth(self.bounds) - 110, 3)];
        _scanningImageView.backgroundColor = [UIColor greenColor];
        scanningRect  = _scanningImageView.frame;
    }
    return _scanningImageView;
}

- (UILabel *)QRCodeTipLabel {
    if (!_QRCodeTipLabel) {
        _QRCodeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.cleanRect) + 30, CGRectGetWidth(self.bounds) - 20, 20)];
        _QRCodeTipLabel.font = [UIFont systemFontOfSize:12];
        _QRCodeTipLabel.backgroundColor = [UIColor clearColor];
        _QRCodeTipLabel.textAlignment = NSTextAlignmentCenter;
        _QRCodeTipLabel.textColor = [UIColor whiteColor];
        _QRCodeTipLabel.numberOfLines = 0;
    }
    return _QRCodeTipLabel;
}

#pragma mark - Public Event

- (void)setupView {
    self.isRestrict = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
    
    [self addSubview:self.scanningImageView];
    [self addSubview:self.QRCodeTipLabel];
    [self QRCodeQRCodeTipLabelString];
    [self drawBarBottomItems];
}

- (AVCaptureSession *)session {
    return self.preViewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session {
    self.preViewLayer.session = session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    return (AVCaptureVideoPreviewLayer *)self.layer;
}

#pragma mark - According authorized and unauthorized show different tip string

- (void )QRCodeQRCodeTipLabelString {
    if (self.isRestrict) {
        self.QRCodeTipLabel.text = kSJQRCodeTipString;
    } else {
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        self.QRCodeTipLabel.text = [NSString stringWithFormat:kSJQRCodeUnRestrictedTipString,[UIDevice currentDevice].model,appName];;
    }
}

- (void)scanning {
    self.scanningImageView.frame = scanningRect;
    CGRect animatationRect = scanningRect;
    animatationRect.origin.y += CGRectGetWidth(self.bounds) - CGRectGetMinX(animatationRect) * 2 - CGRectGetHeight(animatationRect);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:1.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatCount:FLT_MAX];
    [UIView setAnimationRepeatAutoreverses:NO];

    self.scanningImageView.frame = animatationRect;
    [UIView commitAnimations];
}

#pragma mark - Remove ScaningImageViAnimations

- (void)removeScanningAnimations {
    [self.scanningImageView.layer removeAllAnimations];
};

#pragma mark - Setup BarBottomItem

- (void)drawBarBottomItems {

    UIButton *exitBtn = [self createButtonNormalImage:[UIImage imageNamed:@"SJQRCode.bundle/qrcode_scan_back_nor"] selectImage:[UIImage imageNamed:@"SJQRCode.bundle/qrcode_scan_back_nor"] scanningViewButton:SJSCanningViewButtonExit];
    UIButton *torchBtn = [self createButtonNormalImage:[UIImage imageNamed:@"SJQRCode.bundle/qrcode_scan_torch_nor"] selectImage:[UIImage imageNamed:@"SJQRCode.bundle/qrcode_scan_torch_nor"] scanningViewButton:SJSCanningViewButtonTorch];
    UIButton *albumBtn = [self createButtonNormalImage:[UIImage imageNamed:@"SJQRCode.bundle/qrcode_scan_pic_nor"] selectImage:[UIImage imageNamed:@"SJQRCode.bundle/qrcode_scan_pic_nor"] scanningViewButton:SJSCanningViewButtonAlbum];
    
    [self addSubview:exitBtn];
    [self addSubview:torchBtn];
    [self addSubview:albumBtn];
}

- (UIButton *)createButtonNormalImage:(UIImage *)normalImage selectImage:(UIImage *)selectImage scanningViewButton:(SJSCanningViewButton)btnTag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = btnTag;
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectImage forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (btnTag == SJSCanningViewButtonExit) {
        button.frame = CGRectMake(kBtnMargin, kBtnTopMargin, kBtnWidth, kBtnWidth);
    }else if (btnTag == SJSCanningViewButtonTorch) {
        button.frame = CGRectMake(CGRectGetWidth(self.bounds) - kBtnMargin - kBtnWidth, kBtnTopMargin, kBtnWidth, kBtnWidth);
    }else if (btnTag == SJSCanningViewButtonAlbum) {
        button.frame = CGRectMake(CGRectGetWidth(self.bounds) - (kBtnMargin + kBtnWidth) * 2, kBtnTopMargin, kBtnWidth, kBtnWidth);
    }
    
    return button;
}

#pragma mark - Button Action

- (void)clickButton:(UIButton *)btn {
    [self.scanningDelegate scanningViewClickBarButtonItem:btn.tag];
}

- (void)drawRect:(CGRect)rect {
  
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, self.backgroundColor.CGColor);
    CGContextFillRect(contextRef, rect);
    CGRect clearRect;
    CGFloat paddingX = kSJQRCodeRectPaddingX;
    CGFloat tipLabelPadding = 30.0f;
    clearRect = CGRectMake(paddingX, 130, CGRectGetWidth(rect) - paddingX * 2, CGRectGetWidth(rect) - paddingX * 2);
    self.cleanRect = clearRect;
    
    CGRect QRCodeTipLabelFrame = self.QRCodeTipLabel.frame;
    QRCodeTipLabelFrame.origin.y = CGRectGetMaxY(self.cleanRect) + tipLabelPadding;
    self.QRCodeTipLabel.frame = QRCodeTipLabelFrame;
    
    CGContextClearRect(contextRef, self.cleanRect);
    CGContextSaveGState(contextRef);
    
    UIImage *topLeftImage = [UIImage imageNamed:@"SJQRCode.bundle/ScanQR1"];
    UIImage *topRightImage = [UIImage imageNamed:@"SJQRCode.bundle/ScanQR2"];
    UIImage *bottomLeftImage = [UIImage imageNamed:@"SJQRCode.bundle/ScanQR3"];
    UIImage *bottomRightImage = [UIImage imageNamed:@"SJQRCode.bundle/ScanQR4"];
    
    [topLeftImage drawInRect:CGRectMake(_cleanRect.origin.x, _cleanRect.origin.y, topLeftImage.size.width, topLeftImage.size.height)];
    [topRightImage drawInRect:CGRectMake(CGRectGetMaxX(_cleanRect) - topRightImage.size.width, _cleanRect.origin.y, topRightImage.size.width, topRightImage.size.height)];
    [bottomLeftImage drawInRect:CGRectMake(_cleanRect.origin.x, CGRectGetMaxY(_cleanRect) - bottomLeftImage.size.height, bottomLeftImage.size.width, bottomLeftImage.size.height)];
    [bottomRightImage drawInRect:CGRectMake(CGRectGetMaxX(_cleanRect) - bottomRightImage.size.width, CGRectGetMaxY(_cleanRect) - bottomRightImage.size.height, bottomRightImage.size.width, bottomRightImage.size.height)];
    
    CGFloat padding = 0.5;
    CGContextMoveToPoint(contextRef, CGRectGetMinX(_cleanRect) - padding, CGRectGetMinY(_cleanRect) - padding);
    CGContextAddLineToPoint(contextRef, CGRectGetMaxX(_cleanRect) + padding, CGRectGetMinY(_cleanRect) + padding);
    CGContextAddLineToPoint(contextRef, CGRectGetMaxX(_cleanRect) + padding, CGRectGetMaxY(_cleanRect) + padding);
    CGContextAddLineToPoint(contextRef, CGRectGetMinX(_cleanRect) - padding, CGRectGetMaxY(_cleanRect) + padding);
    CGContextAddLineToPoint(contextRef, CGRectGetMinX(_cleanRect) - padding, CGRectGetMinY(_cleanRect) - padding);
    CGContextSetLineWidth(contextRef, padding);
    CGContextSetStrokeColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    CGContextStrokePath(contextRef);
}
@end
