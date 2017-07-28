//
//  ViewController.m
//  SJQRCodeExample
//
//  Created by sxmaps on 2017/3/16.
//  Copyright © 2017年 sxmaps. All rights reserved.
//

#import "ViewController.h"
#import "SJQRCode.h"
#import "UIAlertView+SJAddtions.h"

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
    SJQRCodeController *qq =  [SJQRCodeController QRCodeSuccessMessageBlock:^(NSString *messageString) {
       NSLog(@"%@",messageString);
   }];
    [self presentViewController:qq animated:YES completion:nil];
}


@end
