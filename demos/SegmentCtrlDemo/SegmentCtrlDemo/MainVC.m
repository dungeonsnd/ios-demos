//
//  MainVC.m
//  SegmentCtrlDemo
//
//  Created by jeffery on 15/10/15.
//  Copyright © 2015年 jeffery. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@property (strong, nonatomic) UISegmentedControl *mySc;
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor =[UIColor whiteColor];
    
    // 创建一个UISegmentedControl
    NSArray *btnList = [NSArray arrayWithObjects:@"第一段",@"第二段",@"第三段", nil];
    UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:btnList];
    sc.selectedSegmentIndex = 0;
    
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] =[UIColor greenColor];
    textAttrs[NSFontAttributeName] =[UIFont systemFontOfSize:26];
    
    [sc setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    sc.frame = CGRectMake(40, 30, 340, 50);
    sc.tintColor = [UIColor redColor];
    

//    [sc setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} forState:UIControlStateSelected];
//    [sc setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    
    [sc addTarget:self action:@selector(onSelect:) forControlEvents:UIControlEventValueChanged];
    self.mySc = sc;
    [self.view addSubview:self.mySc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 选择UISegmentedControl触发
- (void)onSelect:(id)sender
{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    NSLog(@"selected=%ld", control.selectedSegmentIndex);
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
