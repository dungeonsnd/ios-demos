//
//  VC1.m
//  TestPresentVC
//
//  Created by mxw on 16/4/13.
//  Copyright © 2016年 mtzijin. All rights reserved.
//

#import "VC1.h"
#import "VC2.h"

@interface VC1 () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@end

@implementation VC1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self imagePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTakePic:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.imagePicker takePicture];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    VC2 *vc2 =[[VC2 alloc]init];
    vc2.image =image;
    [self presentViewController:vc2 animated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
}




- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.delegate = self;
        _imagePicker.showsCameraControls = NO;
        _imagePicker.allowsEditing = NO;
        
        [_imagePicker.view addSubview:self.overlayView];
    }
    return _imagePicker;
}

@end
