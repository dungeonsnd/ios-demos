//
//  SDXVCustomView.m
//  SelfDefineXibView
//
//  Created by jeffery on 16/3/5.
//  Copyright © 2016年 jeffery. All rights reserved.
//

#import "SDXVCustomView.h"

@interface SDXVCustomView()
@property (weak, nonatomic) IBOutlet UILabel *lbl;

@end

@implementation SDXVCustomView

- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    NSLog(@"initWithFrame");
    [self loadRefXib];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    NSLog(@"initWithCoder");
    [self loadRefXib];
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"awakeFromNib");
    
}

- (void)loadRefXib{
    UIView* v =[[NSBundle mainBundle]loadNibNamed:@"SDXVRefXib" owner:self options:nil][0];
    v.frame = self.bounds;
    [self addSubview:v];
    [self.lbl setBackgroundColor:[UIColor redColor]];
    
}

- (void)drawRect:(CGRect)rect {
    //NSLog(@"drawRect");
}

@end
