//
//  MainVC.m
//  TestPresentVC
//
//  Created by mxw on 16/4/13.
//  Copyright © 2016年 mtzijin. All rights reserved.
//

#import "MainVC.h"
#import <MobileCoreServices/UTCoreTypes.h>

#import "VC1.h"
#import "VC2.h"

@interface MainVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishTakePic:) name:@"dismiss" object:nil];
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"dismiss" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)finishTakePic:(NSNotification*) notification{
//    VC2 *vc2 =[[VC2 alloc]init];
//    [self presentViewController:vc2 animated:NO completion:nil];
    NSLog(@"finishTakePic");
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)timercb:(NSTimer*)timer{
    UIImagePickerController *cameraUI =timer.userInfo;
    [cameraUI takePicture];
}

- (IBAction)btnClick:(id)sender {
//    VC1 *vc1 =[[VC1 alloc]init];
//    [self presentViewController:vc1 animated:NO completion:nil];

    [self startCameraControllerFromViewController:self usingDelegate:self];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [[picker parentViewController] dismissViewControllerAnimated:NO completion:nil];
}
// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        // Save the new image (original or edited) to the Camera Roll
//        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
        [self saveToSandbox:imageToSave];
    }
    
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
        NSString *moviePath = [[info objectForKey: UIImagePickerControllerMediaURL] path];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (
                                                 moviePath, nil, nil, nil);
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    VC2 *vc2 =[[VC2 alloc]init];
    vc2.image =originalImage;
    [self presentViewController:vc2 animated:NO completion:nil];
}

- (void) saveToSandbox:(UIImage*) img{
    NSData *data = UIImageJPEGRepresentation(img, 1.0);
    NSString *fileName = @"cap.jpg";
  
    NSString * rootPath = NSTemporaryDirectory();
    NSString *path = [rootPath stringByAppendingPathComponent:fileName];
    [data writeToFile:path atomically:YES];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate
{
    
    // here, check the device is available  or not
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)|| (controller == nil))
        return NO;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    
    cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    
//    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timercb:) userInfo:cameraUI repeats:NO];
    return YES;
}
@end
