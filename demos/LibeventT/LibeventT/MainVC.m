//
//  MainVC.m
//  LibeventT
//
//  Created by dungeonsnd on 16/3/31.
//  Copyright © 2016年 jeffery. All rights reserved.
//

#import "MainVC.h"
#import "USFNetworkTool.h"

@interface MainVC ()
@property (weak, nonatomic) IBOutlet UITextView *labelLog;
@property (weak, nonatomic) IBOutlet UITextField *textFieldHost;

@property (weak, nonatomic) IBOutlet UITextField *textFieldTimerSec;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHostTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLogTop;

@end

@implementation MainVC

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(usfnt:)
                                                 name:@"usfnt"
                                               object:nil];
    
    self.textFieldHost.text =@"server2.en.trademessenger.com";
    self.textFieldTimerSec.text =@"15";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}


-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc{
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"usfnt" object:nil];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
//    self.constraintLogTop.priority =250;
    self.constraintHostTop.priority =750;
    [self.view layoutIfNeeded];
}
- (void)keyboardWillHide:(NSNotification*)notification
{
//    self.constraintLogTop.priority =750;
    self.constraintHostTop.priority =250;
    [self.view layoutIfNeeded];
}

- (void)usfnt:(NSNotification *)notification{
    NSDictionary *userInfo =[[notification userInfo] mutableCopy];
    NSLog(@" %@ ==> %@", [userInfo objectForKey:@"cmd"], [userInfo objectForKey:@"msg"]);
    NSString *txt =[self.labelLog text];
    txt =[txt stringByAppendingFormat:@"%@\n\n", [userInfo objectForKey:@"msg"]];
    [self.labelLog setText:txt];
    [self.labelLog scrollRangeToVisible:NSMakeRange(txt.length, 1)];
}


- (IBAction)onBtnReset:(id)sender {
    
    int timerSec =[self.textFieldTimerSec.text intValue];
    [[USFNetworkTool sharedInstance] resettimer:timerSec];
    
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示"
                                                   message:@"设置心跳间隔成功"
                                                  delegate:self
                                         cancelButtonTitle:@"ok"
                                         otherButtonTitles:nil];
    [alert show];
}

- (IBAction)onBtnConnect:(id)sender {
    
    //    NSString *host =@"221.6.35.109";
    [[USFNetworkTool sharedInstance] startLoop:self.textFieldHost.text port:443];
    
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示"
                                                   message:@"开始连接..."
                                                  delegate:self
                                         cancelButtonTitle:@"ok"
                                         otherButtonTitles:nil];
    [alert show];
}

@end
