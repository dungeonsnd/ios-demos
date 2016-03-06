//
//  SDXVMainVC.m
//  SelfDefineXibView
//
//  Created by jeffery on 16/3/5.
//  Copyright © 2016年 jeffery. All rights reserved.
//

/*
默认cell.
 
 */


#import "SDXVMainVC.h"

@interface SDXVMainVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblAccount;

@end

@implementation SDXVMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tblAccount.dataSource =self;
    self.tblAccount.delegate =self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId=@"cellId";
    UITableViewCell *cell =[self.tblAccount dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    cell.textLabel.text=@"textLabel";
    cell.detailTextLabel.text=@"detailTextLabel";
    NSLog(@"cell:%@",cell);
    
    return cell;
}

@end
