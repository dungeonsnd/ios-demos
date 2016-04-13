//
//  VC2.m
//  TestPresentVC
//
//  Created by mxw on 16/4/13.
//  Copyright © 2016年 mtzijin. All rights reserved.
//

#import "VC2.h"

@interface VC2 ()

@end

@implementation VC2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBtnProjection:(id)sender {
//    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dismiss" object:self userInfo:nil];
}

@end
