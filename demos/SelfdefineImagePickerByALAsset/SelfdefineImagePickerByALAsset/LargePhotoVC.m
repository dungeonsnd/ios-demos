//
//  LargePhotoVC.m
//  SelfdefineImagePickerByALAsset
//
//  Created by mxw on 16/4/23.
//  Copyright © 2016年 mtzijin. All rights reserved.
//

#import "LargePhotoVC.h"

@interface LargePhotoVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation LargePhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *recg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToClose:)];
    [self.imgView addGestureRecognizer:recg];
    
    self.imgView.image =self.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapToClose:(id)recg {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
