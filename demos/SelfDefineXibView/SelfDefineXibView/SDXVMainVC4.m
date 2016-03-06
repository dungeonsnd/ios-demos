//
//  SDXVMainVC4.m
//  SelfDefineXibView
//
//  Created by jeffery on 16/3/6.
//  Copyright © 2016年 jeffery. All rights reserved.
//

#import "SDXVMainVC4.h"

#import "SDXVCustom.h"

@interface SDXVMainVC4 ()

@end

@implementation SDXVMainVC4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    // 1) 使用加载xib的方式

    UIView *v =[[NSBundle mainBundle]loadNibNamed:@"SDXVCustomXib" owner:self options:nil][0];
    // 尺寸设置最好的方式待研究。
//    CGSize screenSize = [UIScreen mainScreen].bounds.size;
//    [v setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height/2.0f)];
    [self.view addSubview:v];

    
    // 2) 使用关联类的方式，没有加载成功。应该不能这么用。
    /*
    SDXVCustom *v =[[SDXVCustom alloc]init];
    [self.view addSubview:v];
     */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
