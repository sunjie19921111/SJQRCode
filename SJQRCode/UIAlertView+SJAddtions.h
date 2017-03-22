//
//  UIAlertView+SJAddtions.h
//  SJQRCode
//
//  Created by 中创 on 16/12/0.
//  Copyright © 2016年 Sunjie. All rights reserved.
//
// 项目还未完成，将继续更新。
//
//
// 初次封装代码，有不足的地方，请大神指教  邮箱：15220092519@163.com
//
//

#import <UIKit/UIKit.h>

@interface UIAlertView (SJAddtions)

+ (UIAlertView *)alertViewTitle:(NSString *)title message:(NSString *)mess delegate:(id)delegate cancelButtonTitle:(NSString *)cancelBtn;
+ (UIAlertView *)alertViewTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelBtn otherButtonTitles:(NSString *)otherBtn;

@end
