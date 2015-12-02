//
//  ViewController.m
//  IOSOpensslDemo
//
//  Created by mxw on 15/11/26.
//  Copyright © 2015年 mtzijin. All rights reserved.
//

#import "ViewController.h"
#import "WCrypto.h"

@interface ViewController ()
- (IBAction)onClickBtnEncrypt:(UIButton *)sender;
- (IBAction)onClickBtnDecrypt:(UIButton *)sender;

@property (nonatomic, strong) NSData * data;
@property (nonatomic, strong) NSData * iv;
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

- (IBAction)onClickBtnEncrypt:(UIButton *)sender {
    NSData* src = [@"abcdabcdabcdabcda" dataUsingEncoding:NSUTF8StringEncoding];
    [WCrypto encrypt:src
         blockSucess:^(NSData * result, NSData *iv){
             self.data =result;
             self.iv =iv;
             
             NSLog(@"iv:%@", iv);
             NSLog(@"加密结果:");
             Byte *testByte = (Byte *)[result bytes];
             for(int i=0;i<[result length];i++)
                 NSLog(@" 0x%02x",testByte[i]);
         }
     
        blockFailure:^(NSInteger reason){
            NSLog(@"failed.");
        }
     ];
}

- (IBAction)onClickBtnDecrypt:(UIButton *)sender {
    [WCrypto decrypt:self.data
                  iv:self.iv
         blockSucess:^(NSData * result){
             NSLog(@"解密结果:");
             NSString* aStr= [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
             NSLog(@"%@",aStr);
         }
     
        blockFailure:^(NSInteger reason){
            NSLog(@"failed.");
        }
     ];
}
@end






