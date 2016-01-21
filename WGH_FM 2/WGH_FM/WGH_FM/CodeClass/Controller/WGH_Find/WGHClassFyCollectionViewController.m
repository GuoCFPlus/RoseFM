//
//  WGHClassFyCollectionViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/13.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHClassFyCollectionViewController.h"

@interface WGHClassFyCollectionViewController ()
@property(strong,nonatomic)NSMutableArray *dataArray;

@property(strong,nonatomic)NSMutableArray *titlesArray;

@property(strong,nonatomic)WGHCollectionReusableView *headerView;

@end

@implementation WGHClassFyCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    
    if (self = [super initWithCollectionViewLayout:layout]) {
        
        self.navigationItem.title = @"分类";
        
        UIImage *image = [UIImage imageNamed:@"wgh_navigationbar_xiangxia"];
        //image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
        
    }
    
    return self;
}

- (void)returnAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestShowClassFyData];
    self.titlesArray = [NSMutableArray arrayWithCapacity:25];
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.900 green:0.900 blue:0.900 alpha:1.000];
    
    self.collectionView.userInteractionEnabled = YES;
    // Register cell classes
    [self.collectionView registerClass:[WGHClassFyCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    //注册 header
    [self.collectionView registerClass:[WGHCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier];
    self.collectionView.allowsMultipleSelection = YES;//默认为NO,是否可以多选
    
}

- (void)requestShowClassFyData {
    
    [[WGHNetWorking shareAcquireNetworkState] acquireCurrentNetworkState:^(int result) {
        if (result != 0) {
            __weak typeof(self) weak = self;
            [[WGHRequestData shareRequestData] requestClassFyListDataWithURL:[NSString stringWithFormat:WGH_FenLeiURL] block:^(NSMutableArray *array) {
                weak.dataArray = [NSMutableArray arrayWithArray:array];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.collectionView reloadData];
                    [self requestOneCalssFyTitleNames];
                });
            }];
        }else {
            [[WGHNetWorking shareAcquireNetworkState] showPrompt];
        }
        
    }];
}

//#define WGH_OneItemTitleURL @"http://mobile.ximalaya.com/mobile/discovery/v1/category/tagsWithoutCover?categoryId=%d&contentType=album&device=iPhone"
- (void)requestOneCalssFyTitleNames {
    
    for (int i = 0; i < self.dataArray.count; i++) {
        WGHClassFyModel *model = self.dataArray[i];
        
        [[WGHRequestData shareRequestData] requestOneClassFyTitleNamesWithIDURL:[NSString stringWithFormat:WGH_OneItemTitleURL,[model.ID intValue]] block:^(NSMutableDictionary *dictinoary) {
            [self.titlesArray addObject:dictinoary];
        }];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth)/2-5, kGap_50);
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);//分别为上、左、下、右
}
//每个item中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

// 区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// item 数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count-5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    WGHClassFyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    WGHClassFyModel *model = self.dataArray[indexPath.row+5];
    cell.model = model;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WGHOneClassFyListViewController *oneVC = [WGHOneClassFyListViewController new];
    WGHClassFyModel *model = self.dataArray[indexPath.row+5];
    oneVC.model = model;
    
    for (NSDictionary *dic in self.titlesArray) {
        for (NSNumber *ID in dic.allKeys) {
            if ([model.ID isEqualToNumber:ID]) {
                oneVC.titlesArray = dic[ID];
            }
        }
    }
    
    [self.navigationController pushViewController:oneVC animated:YES];
    
}


#define kBigImgWidth (kScreenWidth-kGap_30)/2
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    self.headerView = [[WGHCollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigImgWidth)];
    self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    WGHClassFyModel *model1 = self.dataArray[self.headerView.firstImgView.tag-100];
    [self.headerView.firstImgView sd_setImageWithURL:[NSURL URLWithString:model1.coverPath]];
    
    WGHClassFyModel *model2 = self.dataArray[self.headerView.secondImgView.tag-100];
    [self.headerView.secondImgView sd_setImageWithURL:[NSURL URLWithString:model2.coverPath]];
    
    WGHClassFyModel *model3 = self.dataArray[self.headerView.thirdImgView.tag-100];
    [self.headerView.thirdImgView sd_setImageWithURL:[NSURL URLWithString:model3.coverPath]];
    
    WGHClassFyModel *model4 = self.dataArray[self.headerView.fourthImgView.tag-100];
    [self.headerView.fourthImgView sd_setImageWithURL:[NSURL URLWithString:model4.coverPath]];
    
    WGHClassFyModel *model5 = self.dataArray[self.headerView.fifthImgView.tag-100];
    [self.headerView.fifthImgView sd_setImageWithURL:[NSURL URLWithString:model5.coverPath]];
    
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
    UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
    UITapGestureRecognizer *singleTap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
    [self.headerView.firstImgView addGestureRecognizer:singleTap1];
    [self.headerView.secondImgView addGestureRecognizer:singleTap2];
    [self.headerView.thirdImgView addGestureRecognizer:singleTap3];
    [self.headerView.fourthImgView addGestureRecognizer:singleTap4];
    [self.headerView.fifthImgView addGestureRecognizer:singleTap5];
    
    
    return self.headerView;
}

- (void)buttonpress:(UITapGestureRecognizer *)gestureRecognizer {

    WGHOneClassFyListViewController *oneVC = [WGHOneClassFyListViewController new];

    UIView *viewClicked=[gestureRecognizer view];
    for (int i = 0; i < 5; i++) {
        UIImageView *imgView = [self.headerView viewWithTag:100+i];
        if (viewClicked == imgView) {
            WGHClassFyModel *model = self.dataArray[i];
            oneVC.model = model;
            for (NSDictionary *dic in self.titlesArray) {
                for (NSNumber *ID in dic.allKeys) {
                    if ([model.ID isEqualToNumber:ID]) {
                        oneVC.titlesArray = dic[ID];
                    }
                }
            }
            break;
        }
    }
    
    [self.navigationController pushViewController:oneVC animated:YES];
}




//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={kScreenWidth,kBigImgWidth+kGap_10};
    return size;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
