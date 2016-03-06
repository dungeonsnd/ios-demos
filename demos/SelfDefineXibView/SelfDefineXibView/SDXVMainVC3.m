//
//  SDXVMainVC3.m
//  SelfDefineXibView
//
//  Created by jeffery on 16/3/5.
//  Copyright © 2016年 jeffery. All rights reserved.
//

/*
 
 * 自定义View，并且这个View中不需要使用xib
 新建一个类继承自View,不同时创建xib. 这时可以在引用的地方可以用
 initWithFrame 方式来创建。在代码中创建自定义View时仅会调用SDXVCustomView的 initWithFrame, 不会调用 awakeFromNib。
 
 
 
 或者，在引用的地方拖一个View到xib中，然后设置类为自己定义View的类名称。
 
 在 xib 中放置，不在代码中创建时仅会依次调用SDXVCustomView的 initWithCoder、awakeFromNib。
 
 
 
 
 * 自定义View，并且这个View中需要使用xib (注意，先有View再有xib，也就是View中加载这个xib)
 
 在自定义View类中使用下面的方式（xxx表示xib名称，不带扩展名）来获取xib对应的UIView对象，
 
 [[NSBundle mainBundle]loadNibNamed:@"xxx" owner:self options:nil][0];
 
 
 如果自定义View中需要连接xib的outlet或action时，xib中的File's Owner的Identity inspector中的Custom class->Class 要设置为需要连接到的类名，而First Responder下面的一栏的Identity inspector中的Custom class->Class默认即可。
 
*/


#import "SDXVMainVC3.h"
#import "SDXVCustomView.h"

@interface SDXVMainVC3 ()

@property (strong, nonatomic) SDXVCustomView* customViewFromCode;

@end

@implementation SDXVMainVC3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1) 不在 xib 中放置，只在下面代码中创建时仅会调用SDXVCustomView的 initWithFrame, 不会调用 awakeFromNib
    self.customViewFromCode =[[SDXVCustomView alloc]initWithFrame:CGRectMake(40, 40, 300, 300)];
    [self.view addSubview:self.customViewFromCode];

    
    // 2) 在 xib 中放置，不在代码中创建时仅会依次调用SDXVCustomView的 initWithCoder、awakeFromNib
    // 见xib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
