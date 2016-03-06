//
//  SDXVMainVC2.m
//  SelfDefineXibView
//
//  Created by jeffery on 16/3/5.
//  Copyright © 2016年 jeffery. All rights reserved.
//

/*
 使用 xib及类来自定义cell.
 */

#import "SDXVMainVC2.h"
#import "SDXVCustomCell.h"

@interface SDXVMainVC2 () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSString *cellId;
@end

@implementation SDXVMainVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource =self;
    self.tableView.delegate =self;
    
    self.cellId =@"cellId";
    [self.tableView registerNib:[UINib nibWithNibName:@"SDXVCustomCell" bundle: nil] forCellReuseIdentifier:self.cellId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SDXVCustomCell *cell =[self.tableView dequeueReusableCellWithIdentifier:self.cellId];
    
    cell.textLabel.text=@"textLabel";
    cell.detailTextLabel.text=@"detailTextLabel";
    NSLog(@"cell:%@",cell);
    
    return cell;
}

@end
