//
//  ViewController.m
//  LabelImage
//
//  Created by jeffery on 15/10/16.
//  Copyright © 2015年 jeffery. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *img = [UIImage imageNamed:@"128x128_2"];
    
    UILabel *myLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 150, img.size.width,img.size.height)];
    myLabel.text =@"这是测试标签";
    myLabel.font =[UIFont systemFontOfSize:52];
    myLabel.minimumScaleFactor = 2.0f;
    myLabel.textAlignment =NSTextAlignmentCenter;
    myLabel.adjustsFontSizeToFitWidth = YES;
    myLabel.textColor =[UIColor redColor];
    
    UIGraphicsBeginImageContext( img.size );
    [img drawInRect:CGRectMake(0,0,img.size.width,img.size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    myLabel.backgroundColor = [UIColor colorWithPatternImage:newImage];
    
    [self.view addSubview:myLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
