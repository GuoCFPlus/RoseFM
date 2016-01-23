//
//  WGHHotAnchorAlbumViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/21.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHHotAnchorAlbumViewController.h"

@interface WGHHotAnchorAlbumViewController ()
@property(strong,nonatomic)UIImageView *image;
@property(strong,nonatomic)UILabel *nickName;
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(strong,nonatomic)UIButton *returnBtn;
@property(assign,nonatomic)int pageId;
@end

@implementation WGHHotAnchorAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 2、设置被拉伸图片view的高度
    self.stretchingImageHeight =200;
    
    // 3、设置头部拉伸图片的名称
    self.navigationItem.title = nil;
    self.stretchingImageName = @"wgh_user_header_stretching";
    self.navigationController.navigationBar.translucent = YES;
    [self addImageView];
    
    // 注册cell
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[WGHShowListTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
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
    [[WGHRequestData shareRequestData] requestListParsenDataWithURL:[NSString stringWithFormat:WGH_OneHotAnchorURL,[weak.anchorModel.uid intValue],weak.pageId] block:^(NSMutableArray *array) {
        [self.dataArray addObjectsFromArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 回到主线程刷新
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
    
}



- (void)addImageView {
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    view1.center = CGPointMake(kScreenWidth/2, -100);
    
    self.image = [[UIImageView alloc]init];
    self.image.userInteractionEnabled = YES;
    
    self.image.frame = CGRectMake(0, 0, 80, 80);
    self.image.layer.masksToBounds = YES;
    self.image.layer.cornerRadius = 40;
    
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:self.anchorModel.middleLogo]];
    [view1 insertSubview:self.image atIndex:4];
    
    self.image.center = CGPointMake(view1.frame.size.width/2, view1.frame.size.height/2);
    
    [self.view insertSubview:view1 atIndex:3];
    self.nickName = [[UILabel alloc]init];
    self.nickName.font = [UIFont boldSystemFontOfSize:15];
    
    self.nickName.text = self.anchorModel.nickname;
    //改变字体颜色
    self.nickName.textColor = [UIColor whiteColor];
    self.nickName.textAlignment = NSTextAlignmentCenter;
    
    CGSize size = CGSizeMake(1000, 20);
    CGRect newRect = [self.nickName.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    self.nickName.frame = CGRectMake(0, 0, newRect.size.width, kGap_20);
    self.nickName.center = CGPointMake(view1.frame.size.width/2-kGap_10, self.image.center.y + 65);
    [view1 addSubview:self.nickName];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nickName.frame)+5, CGRectGetMinY(self.nickName.frame), kGap_20, kGap_20)];
    imageView.image = [UIImage imageNamed:@"v"];
    [view1 addSubview:imageView];
    
    self.returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.returnBtn.frame = CGRectMake(kGap_20, kGap_30, kGap_40, kGap_30);
    [self.returnBtn setImage:[UIImage imageNamed:@"wgh_fenlei_fanhui"] forState:UIControlStateNormal];
    self.returnBtn.tintColor = [UIColor orangeColor];
    [self.returnBtn addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [view1 addSubview:self.returnBtn];
    
    
    [self.view addSubview:view1];
    
    
}
- (void)returnAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    WGHShowListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
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
