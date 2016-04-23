//
//  MainVC.m
//  SelfdefineImagePickerByALAsset
//
//  Created by mxw on 16/4/23.
//  Copyright © 2016年 mtzijin. All rights reserved.
//

#import "MainVC.h"

#import "LargePhotoVC.h"

@import AssetsLibrary;

@interface MainVC () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property  (nonatomic, strong)  ALAssetsLibrary *assetsLibrary;
@property  (nonatomic, strong)  NSMutableDictionary *groupsDic; // @{@"groupURL":@["photoURL","photoURL"]}
@property  (nonatomic, strong)  NSMutableArray *groups; // @["groupURL","groupURL"]
@property  (nonatomic, strong)  NSMutableArray *photos; // @["photoURL","photoURL"]
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    
    __block NSMutableDictionary *groupsDic =[[NSMutableDictionary alloc]init];
    __block NSMutableArray *photos =[[NSMutableArray alloc]init];
    
    __weak typeof(self) weakSelf =self;
    ALAssetsLibraryGroupsEnumerationResultsBlock enumerateBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        __strong typeof(weakSelf) strongSelf =weakSelf;
        
        if ([group numberOfAssets] > 0)
        {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
            NSURL *groupURL =[group valueForProperty: ALAssetsGroupPropertyURL];
            [strongSelf.groups addObject:groupURL];
            NSLog(@"enumerateBlock, numberOfAssetsInThisGroup=%ld, groupName=%@, groupURL=%@ \n",
                  (long)[group numberOfAssets],
                  [group valueForProperty: ALAssetsGroupPropertyName],
                  groupURL);
            
            __block NSMutableArray *arr =[[NSMutableArray alloc]init];
            
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *asset,
                                                                                NSUInteger index,
                                                                                BOOL *stop) {
                
                NSURL *photoUrl =[asset valueForProperty:ALAssetPropertyAssetURL];
                if (asset) {
                    NSLog(@"add photo, photoURL=%@ \n", photoUrl);
                    [arr addObject:photoUrl];
                    [photos addObject:photoUrl];
                }
            }];
            
            [groupsDic setObject:arr forKey:groupURL];
        }
        else
        {
            strongSelf.groupsDic = groupsDic;
            strongSelf.photos = photos;
            [strongSelf.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:enumerateBlock
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

- (NSMutableDictionary *)groupsDic
{
    if (!_groupsDic) {
        _groupsDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _groupsDic;
}

- (NSMutableArray *)groups
{
    if (!_groups) {
        _groups = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _groups;
}
- (NSMutableArray *)_photos
{
    if (!_photos) {
        _photos = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _photos;
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSString *groupURL =[self.groups objectAtIndex:section];
//    return [[self.groupsDic objectForKey:groupURL] count];
    
    return [self.photos count];
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
    __block UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:(180.0/255.0) green:(180.0/255.0) blue:(220.0/255.0) alpha:1.0f];
    
    NSURL *photoUrl =[self.photos objectAtIndex:indexPath.row];
    [self.assetsLibrary assetForURL:photoUrl resultBlock:^(ALAsset *asset) {
            UIImage *img = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
            
            UIImageView *imgView =[[UIImageView alloc]initWithImage:img];
            [cell.contentView addSubview:imgView];
    } failureBlock:^(NSError *error) {
    }];
    
    
    return cell;
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w =self.view.frame.size.width/2-15;
    CGFloat h =w;
    return CGSizeMake(w, h);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor cyanColor];

    NSURL *photoUrl =[self.photos objectAtIndex:indexPath.row];
    [self.assetsLibrary assetForURL:photoUrl resultBlock:^(ALAsset *asset) {
        UIImage *img = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        
        LargePhotoVC *vc =[[LargePhotoVC alloc]init];
        vc.image =img;
        [self presentViewController:vc animated:YES completion:nil];
        
    } failureBlock:^(NSError *error) {
    }];
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
