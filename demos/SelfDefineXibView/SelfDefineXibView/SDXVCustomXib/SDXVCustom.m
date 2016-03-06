//
//  SDXVCustom.m
//  SelfDefineXibView
//
//  Created by jeffery on 16/3/6.
//  Copyright © 2016年 jeffery. All rights reserved.
//

#import "SDXVCustom.h"

@interface SDXVCustom()
@property (weak, nonatomic) IBOutlet UILabel *lbl;

@end


@implementation SDXVCustom

- (void)awakeFromNib{
    self.lbl.backgroundColor =[UIColor redColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
