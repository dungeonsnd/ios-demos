//
//  ViewController.m
//  StaticLibDemo
//
//  Created by jeffery on 15/9/24.
//  Copyright © 2015年 jeffery. All rights reserved.
//

#import "ViewController.h"


#import "lib/include/MyStatic/MyStatic.h"


@interface ViewController ()

// 下面这两个属性删除之后，运行时会崩溃。不知道是什么原因。
// 这两个属性是原来加的，重名了。我改了名字也不行，所以重新添加了两个链接。但是不能删除原来的这两个链接了。
@property (weak, nonatomic) IBOutlet UITextField *text0;
@property (weak, nonatomic) IBOutlet UITextField *text1;

- (IBAction)btn0:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *tf0;
@property (weak, nonatomic) IBOutlet UITextField *tf1;

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (IBAction)btn0:(UIButton *)sender {
    
    MyStatic * obj =[[MyStatic alloc]init];
    long rsl =(long)([obj add:3 B:2]);
    NSLog(@"%d+%d=%ld", 3, 2, rsl );
    self.tf0.text =[NSString stringWithFormat:@"%d+%d=%ld", 3, 2, rsl ];
    
    self.tf1.text=@"starting";
    int rt =[obj main_loop];
    self.tf1.text =[NSString stringWithFormat:@"starting result:%d",rt];
}
@end
