//
//  WGHBroadcastMainTableViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/14.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHBroadcastMainTableViewController.h"

#define kBgColorGray [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]
#define kLineHeight 20
#define kIconViewWidth kScreenWidth/4
#define kIconViewHeight (kIconViewWidth + kGap_10 + kLineHeight)
#define kHeaderHeight 50
#define kGap_5 5

@interface WGHBroadcastMainTableViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(strong,nonatomic)NSMutableArray *recommendDataArr;
@property(strong,nonatomic)NSMutableArray *topDataArr;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString * const recommendMainCellId = @"recommendMainCellId";
static NSString * const recommendCellId = @"recommendCellId";
static NSString * const topCellId = @"topCellId";

@implementation WGHBroadcastMainTableViewController


//头视图绘制
-(void)drawHeaderView{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kIconViewHeight+kGap_10)];
    headerView.backgroundColor = kBgColorGray;
    
    //本地台
    GD_BroadcastTypeView *localView = [[GD_BroadcastTypeView alloc]initWithFrame:CGRectMake(0, 0, kIconViewWidth, kIconViewHeight)];
    [localView.imgButton addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    localView.imgButton.tag = 101;
    [headerView addSubview:localView];
    
    //国家台
    GD_BroadcastTypeView *countryView = [[GD_BroadcastTypeView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(localView.frame), 0, kIconViewWidth, kIconViewHeight)];
    [countryView.imgButton setImage:[UIImage imageNamed:@"wgh_guangbo_guojia"] forState:UIControlStateNormal];
    countryView.nameLabel.text = @"国家台";
    [countryView.imgButton addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    countryView.imgButton.tag = 102;
    [headerView addSubview:countryView];
    
    //省市台
    GD_BroadcastTypeView *cityView = [[GD_BroadcastTypeView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(countryView.frame), 0, kIconViewWidth, kIconViewHeight)];
    [cityView.imgButton setImage:[UIImage imageNamed:@"wgh_guangbo_shengshi"] forState:UIControlStateNormal];
    cityView.nameLabel.text = @"省市台";
    [cityView.imgButton addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    cityView.imgButton.tag = 103;
    [headerView addSubview:cityView];
    
    
    //网络台
    GD_BroadcastTypeView *webView = [[GD_BroadcastTypeView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityView.frame), 0, kIconViewWidth, kIconViewHeight)];
    [webView.imgButton setImage:[UIImage imageNamed:@"wgh_guangbo_wangluo"] forState:UIControlStateNormal];
    webView.nameLabel.text = @"网络台";
    [webView.imgButton addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    webView.imgButton.tag = 104;
    [headerView addSubview:webView];
    
    self.tableView.tableHeaderView = headerView;
    
}

//头视图button点击事件
-(void)changePage:(UIButton *)sender{
    WGHBroadcastTypeTableViewController *typeVC = [[WGHBroadcastTypeTableViewController alloc]initWithStyle:UITableViewStylePlain];
    
    UINavigationController *typeNC = [[UINavigationController alloc] initWithRootViewController:typeVC];
    [typeNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont,nil]];
    typeNC.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000];
    typeNC.navigationBar.alpha = 0;
    
    
    switch (sender.tag) {
        case 101:
        {
            DLog(@"这是本地台");
            typeVC.radioType = @"2";
            typeVC.provinceCode = @"110000";
            typeVC.navigationItem.title = @"本地台";
            [self presentViewController:typeNC animated:YES completion:nil];
            break;
        }
        case 102:
        {
            DLog(@"这是国家台");
            typeVC.radioType = @"1";
            typeVC.provinceCode = @"110000";
            typeVC.navigationItem.title = @"国家台";
            [self presentViewController:typeNC animated:YES completion:nil];
            break;
        }
        case 103:
        {
            DLog(@"这是省市台");
            WGHBroadcastProvinceViewController *provinceVC = [[WGHBroadcastProvinceViewController alloc] init];
            
            UINavigationController *provinceNC = [[UINavigationController alloc] initWithRootViewController:provinceVC];
            [provinceNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont,nil]];
            provinceNC.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000];
            provinceNC.navigationBar.alpha = 0;
            provinceVC.navigationItem.title = @"省市台";
            [self presentViewController:provinceNC animated:YES completion:nil];
            break;
        }
        case 104:
        {
            DLog(@"这是网络台");
            typeVC.radioType = @"3";
            typeVC.provinceCode = @"110000";
            typeVC.navigationItem.title = @"网络台";
            [self presentViewController:typeNC animated:YES completion:nil];
            break;
        }
        default:
            DLog(@"出错了");
            break;
    }
    
}

// 请求主界面 推荐
- (void)requestRecommendData {
    
    __weak typeof(self) weak = self;
    [[WGHRequestData shareRequestData] requestClassBRDataWithURL:[NSString stringWithFormat:WGH_RecommendRadioURL] block:^(NSMutableArray *array) {
        weak.recommendDataArr = [NSMutableArray arrayWithArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 绘制视图
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
    }];
    
}

// 请求主界面 排行
- (void)requestTopData {
    
    __weak typeof(self) weak = self;
    [[WGHRequestData shareRequestData] requestClassBTDataWithURL:[NSString stringWithFormat:WGH_RecommendRadioURL] block:^(NSMutableArray *array) {
        weak.topDataArr = [NSMutableArray arrayWithArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 绘制视图
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    //头视图绘制
    [self drawHeaderView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:recommendMainCellId];
    [self.tableView registerClass:[GD_BroadcastTopViewCell class] forCellReuseIdentifier:topCellId];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 请求数据
        [self requestData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    

}

// 请求数据
- (void)requestData {
    
    [[WGHNetWorking shareAcquireNetworkState] acquireCurrentNetworkState:^(int result) {
        if (result != 0) {
            //添加推荐数据
            [self requestRecommendData];
            //添加排行榜数据
            [self requestTopData];
            
        }else {
            [[WGHNetWorking shareAcquireNetworkState] showPrompt];
            [self.tableView.mj_header endRefreshing];
        }
    }];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.recommendDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GD_BroadcastRecommendViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:recommendCellId forIndexPath:indexPath];
    GD_BroadcastTopRadioModel *model = self.recommendDataArr[indexPath.row];
    
    [cell.picPathImgView sd_setImageWithURL:[NSURL URLWithString:model.picPath] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.rnameLabel.text = model.rname;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 跳转播放界面
    WGHBroadcastPlayViewController *bpVC = [WGHBroadcastPlayViewController sharePlayerVC];
    
    bpVC.isRecommend = NO;
    bpVC.dataArray = self.recommendDataArr;
    bpVC.index = indexPath.row;
    
    UINavigationController *albumListNC = [[UINavigationController alloc] initWithRootViewController:bpVC];
    
    [albumListNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont,nil]];
    albumListNC.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000];
    albumListNC.navigationBar.alpha = 0;
    [self presentViewController:albumListNC animated:YES completion:nil];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else
    {
        return self.topDataArr.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return (kScreenWidth)/3+kGap_20;
    }
    else
    {
        return 80;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kGap_50)];
    headerView.backgroundColor = [UIColor whiteColor];
    //headerView.backgroundColor = [UIColor purpleColor];
    UIImageView *triangleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wgh_guangbo_triangle"]];
    triangleImgView.frame = CGRectMake(kGap_5, kGap_5, kGap_20, kGap_20);
    [headerView addSubview:triangleImgView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(triangleImgView.frame), kGap_5, kScreenWidth - kGap_20 - kGap_50, kGap_20)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    if (section == 0) {
        
        titleLabel.text = @"推荐电台";
        
    }
    else if(section == 1)
    {
        titleLabel.text = @"排行榜";
        
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        moreButton.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame), kGap_5, kGap_50, kGap_20);
        [moreButton setTitle:@"更多 >" forState:UIControlStateNormal];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
        moreButton.tintColor = [UIColor grayColor];
        [moreButton addTarget:self action:@selector(changePageRankMore) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:moreButton];
    }
    else
    {
        titleLabel.text = @"播放历史";
        
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        moreButton.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame), kGap_5, kGap_50, kGap_20);
        [moreButton setTitle:@"更多 >" forState:UIControlStateNormal];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
        moreButton.tintColor = [UIColor grayColor];
        [moreButton addTarget:self action:@selector(changePageMore) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:moreButton];
    }
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}

//排行榜更多点击事件
-(void)changePageRankMore{
    
    WGHBroadcastRankMoreTableViewController *rankMoreVC = [[WGHBroadcastRankMoreTableViewController alloc]initWithStyle:UITableViewStylePlain];
    
    UINavigationController *rankMoreNC = [[UINavigationController alloc] initWithRootViewController:rankMoreVC];
    [rankMoreNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont,nil]];
    rankMoreNC.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000];
    rankMoreNC.navigationBar.alpha = 0;
    [self presentViewController:rankMoreNC animated:YES completion:nil];
    
}

//播放历史更多点击事件
-(void)changePageMore{
    
    
    
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kGap_5)];
    if (section != 3) {
        footerView.backgroundColor = kBgColorGray;
    }
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //外cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendMainCellId forIndexPath:indexPath];
        //cell.backgroundColor = [UIColor orangeColor];
        //内collectionView
        
        UICollectionViewFlowLayout *allFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        allFlowLayout.itemSize = CGSizeMake((kScreenWidth-kGap_20)/3, (kScreenWidth-kGap_20)/3);
        allFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenWidth)/3) collectionViewLayout:allFlowLayout];
        self.collectionView.scrollEnabled = NO;
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [cell.contentView addSubview:self.collectionView];
        
        [self.collectionView registerClass:[GD_BroadcastRecommendViewCell class] forCellWithReuseIdentifier:recommendCellId];
        return cell;
    }
    else
    {
        
        GD_BroadcastTopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellId forIndexPath:indexPath];
        //cell.backgroundColor = [UIColor orangeColor];
        GD_BroadcastTopRadioModel *model = self.topDataArr[indexPath.row];
        if (model != nil) {
            [cell.radioCoverLargeImgView sd_setImageWithURL:[NSURL URLWithString:model.radioCoverLarge] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            cell.rnameLabel.text = model.rname;
            cell.programNameLabel.text = [NSString stringWithFormat:@"直播中：%@",model.programName];
            cell.radioPlayCountLabel.text = [NSString stringWithFormat:@"收听人数：%.1f万人",[model.radioPlayCount floatValue] /10000];
            [cell.playButton addTarget:self action:@selector(playBroadcast:) forControlEvents:UIControlEventTouchUpInside];
            cell.playButton.isPlay = YES;
            
        }
        return cell;
        
    }
}

//播放事件
-(void)playBroadcast:(GDButton *)sender{
    if (sender.isPlay == YES) {
        [sender setImage:[UIImage imageNamed:@"wgh_guangbo_stop"] forState:UIControlStateNormal];
        sender.isPlay = NO;
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"wgh_guangbo_play"] forState:UIControlStateNormal];
        sender.isPlay = YES;
    }
}

//排行榜cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 跳转播放界面
    WGHBroadcastPlayViewController *bpVC = [WGHBroadcastPlayViewController sharePlayerVC];
    
    bpVC.isRecommend = YES;
    bpVC.dataArray = self.topDataArr;
    bpVC.index = indexPath.row;
    
    UINavigationController *albumListNC = [[UINavigationController alloc] initWithRootViewController:bpVC];
    [albumListNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont,nil]];
    albumListNC.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000];
    albumListNC.navigationBar.alpha = 0;
    [self presentViewController:albumListNC animated:YES completion:nil];
    
    
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
