//
//  ViewController.m
//  demo_port_libevent
//
//  Created by jeffery on 15/8/25.
//  Copyright © 2015年 jeffery. All rights reserved.
//

#import "ViewController.h"


#include "dependencies/event2/dns.h"
#include "dependencies/event2/listener.h"
#include "dependencies/event2/bufferevent.h"
#include "dependencies/event2/buffer.h"


int startClient()
{
    NSLog(@"Enter startClient ");
    
    return 0;
}


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"Enter viewDidLoad ");
    startClient();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
