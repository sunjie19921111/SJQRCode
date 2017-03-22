//
//  UIAlertView+SJAddtions.m
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

#import "UIAlertView+SJAddtions.h"

@implementation UIAlertView (SJAddtions)

+ (UIAlertView *)alertViewTitle:(NSString *)title message:(NSString *)mess delegate:(id)delegate cancelButtonTitle:(NSString *)cancelBtn {
    UIAlertView *alert = [self alertViewTitle:title message:mess delegate:delegate cancelButtonTitle:cancelBtn otherButtonTitles:nil];
    return alert;
    
}

+ (UIAlertView *)alertViewTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelBtn otherButtonTitles:(NSString *)otherBtn {
    UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelBtn otherButtonTitles:otherBtn, nil];
    [alert show];
    return alert;
}

@end
