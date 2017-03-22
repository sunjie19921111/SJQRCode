//
//  ViewController.m
//  SJQRCodeExample
//
//  Created by sxmaps on 2017/3/16.
//  Copyright © 2017年 sxmaps. All rights reserved.
//

#import "ViewController.h"
#import "SJQRCode.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickButton {
    SJViewController *viewController = [[SJViewController alloc] init];
    /** successString 扫描成功返回来的数据 */
    viewController.successBlock = ^(NSString *successString) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        NSLog(@"successBlock=%@",successString);
        
        [UIAlertView alertViewTitle:@"tip" message:successString delegate:self cancelButtonTitle:@"取消"];
    };
    
    [self presentViewController:viewController animated:YES completion:nil];
}


@end
