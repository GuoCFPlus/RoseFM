//
//  WGHOneClassFyListViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/14.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHOneClassFyListViewController.h"

@interface WGHOneClassFyListViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(strong,nonatomic)DCPicScrollView *picView;

@property(strong,nonatomic)UIScrollView *titlesScroll;

@property(strong,nonatomic)NSMutableArray *carouselPicData;

@property(strong,nonatomic)UIScrollView *mainScroll;

@property(strong,nonatomic)NSMutableArray *dataArray;
@property(assign,nonatomic)int pageId;
@end
static NSInteger indexNumber = -1;
static NSInteger indexButton = -1;
@implementation WGHOneClassFyListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = self.model.title;
        self.dataArray = [NSMutableArray array];
        self.pageId = 1;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Top" style:UIBarButtonItemStylePlain target:self action:@selector(returnTop)];
        
    }
    
    return self;
}

// 回到顶部 将其他的scrollView的scrollsToTop  置为NO;
- (void)returnTop {
    
    UITableView *tableView = nil;
    for (int i = 0; i < self.titlesArray.count; i++) {
        
        UITableView *mainTaleView = [self.mainScroll viewWithTag:100+i];
        int x = self.mainScroll.contentOffset.x/kScreenWidth;
        if (i == x) {
            tableView = mainTaleView;
        }else  {
            mainTaleView.scrollsToTop = NO;
        }
        
    }
    [tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

// 具体某个分类 的推荐
//#define WGH_OneItemURL @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=%d&contentType=album&device=iPhone&scale=2&version=4.3.26"   // 根据categoryId

// 具体某个类名下
//#define WGH_OneTagNameURL @"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=%d&device=iPhone&pageId=%d&pageSize=20&status=0&tagName=%@"  //拼接 categoryId  (tagName) 需要转码 在根据pageid 刷新数据


- (void)requestMainTableViewData:(NSInteger)tag tagName:(NSString *)tagName {
    
    // 请求网络状态
    [[WGHNetWorking shareAcquireNetworkState] acquireCurrentNetworkState:^(int result) {
        if (result != 0) {
            // 请求轮播图数据
            [self requestScrollData:tag];
            // 请求主数据
            [self requestMainData:tag tagName:tagName];
            
        }else {
            // 无网络状态下,  弹窗提示
            [[WGHNetWorking shareAcquireNetworkState] showPrompt];
            // 结束刷新
            UITableView *mainTaleView = [self.view viewWithTag:tag];
            [mainTaleView.mj_header endRefreshing];
            [mainTaleView.mj_footer endRefreshing];
        }
    }];
    
    
}

// 请求主界面 轮播图 数据
- (void)requestScrollData:(NSInteger)tag {
    
    __weak typeof(self) weak = self;
    [[WGHRequestData shareRequestData] requestRecommendScrollWithURL:[NSString stringWithFormat:WGH_OneItemURL,[self.model.ID intValue]] block:^(NSMutableArray *array) {
        weak.carouselPicData = [NSMutableArray arrayWithArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 绘制轮播图 数据
            [self setupScrolldemo:tag];
        });
    }];
    
}
// 解析数据
- (void)requestMainData:(NSInteger)tag tagName:(NSString *)tagName {
    
    UITableView *mainTaleView = [self.mainScroll viewWithTag:tag];
    
    __weak typeof(self) weak = self;
    NSString *url = [NSString stringWithFormat:WGH_OneTagNameURL,[self.model.ID intValue],self.pageId,tagName];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[WGHRequestData shareRequestData] requestListParsenDataWithURL:url block:^(NSMutableArray *array) {
        [weak.dataArray addObjectsFromArray:array];
//        NSLog(@"%ld",weak.dataArray.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 回到主线程刷新
            [mainTaleView reloadData];
            [mainTaleView.mj_header endRefreshing];
            [mainTaleView.mj_footer endRefreshing];
            self.pageId++;
        });
    }];
    
    
}
// 绘制  无限轮播图
- (void)setupScrolldemo:(NSInteger)tag {
    
    if (tag != 100) {
        return;
    }
    UITableView *mainTaleView = [self.view viewWithTag:tag];
    //网络加载
    
    NSMutableArray *UrlStringArray = [NSMutableArray array];
    for (int i = 0; i < self.carouselPicData.count; i++) {
        WGHRecommendSrollModel *model = self.carouselPicData[i];
        if (model.pic == nil) {
            continue;
        }
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
    mainTaleView.tableHeaderView = self.picView;
    //下载失败重复下载次数,默认不重复,
    [[DCWebImageManager shareManager] setDownloadImageRepeatCount:1];
    //图片下载失败会调用该block(如果设置了重复下载次数,则会在重复下载完后,假如还没下载成功,就会调用该block)
    //error错误信息
    //url下载失败的imageurl
    [[DCWebImageManager shareManager] setDownLoadImageError:^(NSError *error, NSString *url) {
        NSLog(@"%@",error);
    }];
}


#define kTitleWidth kScreenWidth/7*2
#define kScrollHeight kScreenHeight-64-kGap_30
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 控制scrollView的位置
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = 0;
    }
    
    self.navigationItem.title = self.model.title;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.titlesScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kGap_30)];
    self.titlesScroll.userInteractionEnabled = YES;
    self.titlesScroll.backgroundColor = [UIColor whiteColor];
    self.titlesScroll.showsHorizontalScrollIndicator = NO;
    self.titlesScroll.showsVerticalScrollIndicator = NO;
    self.titlesScroll.contentSize = CGSizeMake(kTitleWidth * self.titlesArray.count+kGap_30, kGap_30);
    self.titlesScroll.bounces = NO;
    [self.view addSubview:self.titlesScroll];
    
    // 布局title控件
    for (int i = 0; i < self.titlesArray.count; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 + kTitleWidth * i, 0, kTitleWidth, kGap_30)];
        if (i == self.titlesArray.count-1) {
            titleLabel.frame = CGRectMake(0 + kTitleWidth * i, 0, kTitleWidth+kGap_30, kGap_30);
        }
        titleLabel.userInteractionEnabled = YES;
        titleLabel.tag = 200+i;
        titleLabel.text = self.titlesArray[i];
        titleLabel.font = [UIFont systemFontOfSize:15];
        if (i == 0) {
            titleLabel.textColor = [UIColor orangeColor];
        }
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titlesScroll addSubview:titleLabel];
        
        // 添加手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
        [titleLabel addGestureRecognizer:singleTap];
        
    }
    
    // 绘制  主要  滚动图
    
    [self setup_mainTbaleViewScroll];

}
// 绘制  主 滚动图  tableView
- (void)setup_mainTbaleViewScroll {
    
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titlesScroll.frame), kScreenWidth, kScrollHeight)];
    self.mainScroll.contentSize = CGSizeMake(kScreenWidth*self.titlesArray.count, kScreenHeight-64-kGap_30);
    self.mainScroll.pagingEnabled = YES;
    self.mainScroll.bounces = NO;
    self.mainScroll.showsHorizontalScrollIndicator = NO;
    self.mainScroll.showsVerticalScrollIndicator = NO;
    // 给scrollView 设置代理
    self.mainScroll.delegate = self;
    self.mainScroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainScroll];
    
    for (int i = 0; i < self.titlesArray.count; i++) {
        
        // 定义 主  tableView
        UITableView *mainTaleView = [[UITableView alloc] initWithFrame:CGRectMake(0+kScreenWidth*i, 0, kScreenWidth, kScrollHeight) style:UITableViewStylePlain];
        mainTaleView.backgroundColor = [UIColor whiteColor];
        
        // 设置代理
        mainTaleView.delegate = self;
        mainTaleView.dataSource = self;
        mainTaleView.tag = 100+i;
        [mainTaleView registerClass:[WGHShowListTableViewCell class] forCellReuseIdentifier:@"maincell"];
        
        [self.mainScroll addSubview:mainTaleView];
        NSString *tagNmae = self.titlesArray[i];
        
        // 解析 mainTableView 数据
        mainTaleView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 请求数据
            [self requestMainTableViewData:100+i tagName:tagNmae];
        }];
        
        //        [mainTaleView.mj_header beginRefreshing];
        
        mainTaleView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            // 请求数据
            [self requestMainTableViewData:100+i tagName:tagNmae];
        }];
        
    }
    // 请求数据
    
    
    
    [self requestMainTableViewData:100 tagName:self.titlesArray[0]];
    
}

// //结束减速时,执行该方法
// 控制偏移量  加载数据
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    NSInteger i = self.mainScroll.contentOffset.x/kScreenWidth;
    if (indexNumber == i) {
        return;
    }
    indexNumber = i;
    
    if (i > 1) {
        [self.titlesScroll setContentOffset:CGPointMake(kTitleWidth*(i-1), 0) animated:YES];
    }else {
        [self.titlesScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    // 改变显示的tableView所对应titleLabel的字体颜色
    for (int n = 0; n < self.titlesArray.count; n++) {
        UILabel *title = [self.titlesScroll viewWithTag:200+n];
        UILabel *label = [self.titlesScroll viewWithTag:200+i];
        if ([label.text isEqualToString:title.text]) {
            
            title.textColor = [UIColor orangeColor];
        }else {
            title.textColor = [UIColor blackColor];
        }
    }
    
    if (i == 0) {
        [self requestMainTableViewData:100 tagName:self.titlesArray[0]];
    }else {
        
        [self requestMainTableViewData:100+i tagName:self.titlesArray[i]];
        
    }

    self.dataArray = [NSMutableArray array];
    self.pageId = 1;
}

// 手势触发事件   同样  设置偏移量
- (void)buttonpress:(UITapGestureRecognizer *)gestureRecognizer {
    
    UIView *viewClicked=[gestureRecognizer view];
    for (int i = 0; i < 100; i++) {
        UILabel *titleLabel = [self.view viewWithTag:200+i];
        if (viewClicked == titleLabel) {
            
            if (indexButton == i) {
                return;
            }
            indexButton = i;
            titleLabel.textColor = [UIColor orangeColor];
            //设置mainScroll 的偏移量
            [self.mainScroll setContentOffset:CGPointMake(kScreenWidth*i, 0) animated:YES];
            
            // 点击后  设置 titleScroll的偏移量
            if (i > 1) {
                [self.titlesScroll setContentOffset:CGPointMake(kTitleWidth*(i-1), 0) animated:YES];
            }else {
                [self.titlesScroll setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            
            // 改变显示的tableView所对应titleLabel的字体颜色
            for (int n = 0; n < self.titlesArray.count; n++) {
                UILabel *title = [self.titlesScroll viewWithTag:200+n];
                UILabel *label = [self.titlesScroll viewWithTag:200+i];
                if ([label.text isEqualToString:title.text]) {
                    
                    title.textColor = [UIColor orangeColor];
                }else {
                    title.textColor = [UIColor blackColor];
                }
            }
            
            if (i == 0) {
                [self requestMainTableViewData:100 tagName:self.titlesArray[0]];
            }else {
                
                [self requestMainTableViewData:100+i tagName:self.titlesArray[i]];
                
            }
            
            self.dataArray = [NSMutableArray array];
            self.pageId = 1;
            
            break;
        }
    }
    
    
    
}

#pragma mark   ========tableView  Delegate========

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WGHShowListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"maincell" forIndexPath:indexPath];
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

@end
