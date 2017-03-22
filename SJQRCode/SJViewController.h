//
//  ViewController.h
//  SJQRCode
//
//  Created by Sunjie on 16/11/15.
//  Copyright © 2016年 Sunjie. All rights reserved.
//
//
// 项目还未完成，将继续更新。
//
//
// 初次封装代码，有不足的地方，请大神指教  邮箱：15220092519@163.com
//
//


#import <UIKit/UIKit.h>

typedef void(^SJViewControllerSuccessBlock)(NSString *);

@interface SJViewController : UIViewController

/** 扫描成功回调block */
@property (nonatomic, copy) SJViewControllerSuccessBlock successBlock;

@end

