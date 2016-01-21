//
//  WGHFindMainTableViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/14.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHFindMainTableViewController.h"

@interface WGHFindMainTableViewController ()
@property(strong,nonatomic)NSMutableArray *scrollArray;

@property(strong,nonatomic)NSMutableArray *dataArray;
@property(assign,nonatomic)int pageId;

@property(strong,nonatomic)DCPicScrollView *picView;

@end

static NSString *const ShowListCell = @"ShowListCell";
@implementation WGHFindMainTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    if (self = [super initWithStyle:style]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"蔷薇FM" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        
        UIImage *rightBarImage = [UIImage imageNamed:@"wgh_navigationbar_fenlei"];
        rightBarImage = [rightBarImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightBarImage style:UIBarButtonItemStylePlain target:self action:@selector(changeClassfyListAction)];
        
    }
    return self;
}

// 跳转分类列表界面
- (void)changeClassfyListAction {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    WGHClassFyCollectionViewController *classFyVC = [[WGHClassFyCollectionViewController alloc] initWithCollectionViewLayout:layout];
    classFyVC.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
    UINavigationController *classFyNC = [[UINavigationController alloc] initWithRootViewController:classFyVC];
    [classFyNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont,nil]];
    classFyNC.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000];
    classFyNC.navigationBar.alpha = 0;
    [self presentViewController:classFyNC animated:YES completion:nil];
    
}
// 请求主界面 轮播图 数据
- (void)requestScrollData {
    
    __weak typeof(self) weak = self;
    [[WGHRequestData shareRequestData] requestRecommendScrollWithURL:[NSString stringWithFormat:WGH_RecommendScrollURL] block:^(NSMutableArray *array) {
        weak.scrollArray = [NSMutableArray arrayWithArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 多走就多走吧
            [self setupScrolldemo];
        });
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.tableView registerClass:[WGHShowListTableViewCell class] forCellReuseIdentifier:ShowListCell];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.dataArray = [NSMutableArray array];
        self.pageId = 1;
        // 请求数据
        [self requestData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        self.pageId++;
        // 请求数据
        [self requestData];
    }];
    
}

// 请求数据
- (void)requestData {
    
    [[WGHNetWorking shareAcquireNetworkState] acquireCurrentNetworkState:^(int result) {
        if (result != 0) {
            // 请求轮播图数据
            [self requestScrollData];
            // 请求主数据
            [self requestMainData];
            
        }else {
            // 无网络状态下,  弹窗提示
            [[WGHNetWorking shareAcquireNetworkState] showPrompt];
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
- (void)requestMainData {
    
    __weak typeof(self) weak = self;
    [[WGHRequestData shareRequestData] requestListParsenDataWithURL:[NSString stringWithFormat:WGH_EditorsrRecommendURL,weak.pageId] block:^(NSMutableArray *array) {
        [self.dataArray addObjectsFromArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 回到主线程刷新
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
    
}

- (void)setupScrolldemo {
    
    //网络加载
    NSMutableArray *UrlStringArray = [NSMutableArray array];
    for (int i = 0; i < self.scrollArray.count; i++) {
        WGHRecommendSrollModel *model = self.scrollArray[i];
        [UrlStringArray addObject:model.pic];
        
    }
    //显示顺序和数组顺序一致
    //设置图片url数组,和滚动视图位置
    self.picView = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenWidth/5*2) WithImageUrls:UrlStringArray];
    //占位图片,你可以在下载图片失败处修改占位图片
    self.picView.placeImage = [UIImage imageNamed:@"scrollDownFail"];
    //图片被点击事件,当前第几张图片被点击了,和数组顺序一致
    [self.picView setImageViewDidTapAtIndex:^(NSInteger index) {
        
    }];
    //default is 2.0f,如果小于0.5不自动播放
    self.picView.AutoScrollDelay = 3.0f;
    
    self.tableView.tableHeaderView = self.picView;
    //下载失败重复下载次数,默认不重复,
    [[DCWebImageManager shareManager] setDownloadImageRepeatCount:1];
    //图片下载失败会调用该block(如果设置了重复下载次数,则会在重复下载完后,假如还没下载成功,就会调用该block)
    //error错误信息
    //url下载失败的imageurl
    [[DCWebImageManager shareManager] setDownLoadImageError:^(NSError *error, NSString *url) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
// 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
// 返回 区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// 注册cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WGHShowListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShowListCell forIndexPath:indexPath];
    WGHShowListModel *showListModel = self.dataArray[indexPath.row];
    
    cell.showListModel = showListModel;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 跳转专辑界面
    WGHAlbumListTableViewController *albumListVC = [[WGHAlbumListTableViewController alloc] init];
    WGHShowListModel *showListModel = self.dataArray[indexPath.row];
    albumListVC.showListModel = showListModel;
    UINavigationController *albumListNC = [[UINavigationController alloc] initWithRootViewController:albumListVC];
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
