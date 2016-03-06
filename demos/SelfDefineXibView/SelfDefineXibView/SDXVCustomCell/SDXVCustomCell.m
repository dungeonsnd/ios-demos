//
//  SDXVCustomCell.m
//  SelfDefineXibView
//
//  Created by jeffery on 16/3/5.
//  Copyright © 2016年 jeffery. All rights reserved.
//

#import "SDXVCustomCell.h"

@implementation SDXVCustomCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor =[UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
