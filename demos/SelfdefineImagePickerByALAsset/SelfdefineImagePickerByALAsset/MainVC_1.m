//
//  MainVC.m
//  SelfdefineImagePickerByALAsset
//
//  Created by mxw on 16/4/23.
//  Copyright © 2016年 mtzijin. All rights reserved.
//

#import "MainVC.h"

@import AssetsLibrary;

@interface MainVC () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property  (nonatomic, strong)  ALAssetsLibrary *assetsLibrary;
@property  (nonatomic, strong)  NSMutableArray *imageGroup;
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    
    __weak typeof(self) weakSelf =self;
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        __strong typeof(weakSelf) strongSelf =weakSelf;
        
        NSLog(@"listGroupBlock, numberOfAssets=%ld, name=%@ \n",
              (long)[group numberOfAssets],
              [group valueForProperty: ALAssetsGroupPropertyName]);
        
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        if ([group numberOfAssets] > 0)
        {
            [strongSelf.imageGroup addObject:group];
        }
        else
        {
            [strongSelf.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:listGroupBlock
                                    failureBlock:^(NSError *error) {
        NSLog(@"Group not found!\n");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ALAssetsLibrary *)assetsLibrary
{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (NSMutableArray *)imageGroup
{
    if (!_imageGroup) {
        _imageGroup = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _imageGroup;
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imageGroup count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"CollectionCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:((40 * indexPath.row) / 255.0) green:((50 * indexPath.row)/255.0) blue:((60 * indexPath.row)/255.0) alpha:1.0f];
    
    ALAssetsGroup *group = [self.imageGroup objectAtIndex:indexPath.row];
    UIImage *postImage = [UIImage imageWithCGImage:[group posterImage]];
    
    UIImageView *imgView =[[UIImageView alloc]initWithImage:postImage];
    [cell.contentView addSubview:imgView];
    
    return cell;
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w =self.view.frame.size.width/4-50;
    CGFloat h =w;
    return CGSizeMake(w, h);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
