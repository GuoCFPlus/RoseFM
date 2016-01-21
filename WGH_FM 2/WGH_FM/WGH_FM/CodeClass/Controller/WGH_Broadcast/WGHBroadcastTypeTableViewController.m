//
//  WGHBroadcastTypeTableViewController.m
//  WGH_FM
//
//  Created by lanou3g on 16/1/18.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHBroadcastTypeTableViewController.h"

@interface WGHBroadcastTypeTableViewController ()

@property (strong, nonatomic)NSMutableArray *dataArr;

@property (assign, nonatomic)int pageNum;

@end

static NSString *const typeCellId = @"typeCellId";

@implementation WGHBroadcastTypeTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    if (self = [super initWithStyle:style]) {
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[GD_BroadcastTopViewCell class] forCellReuseIdentifier:typeCellId];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if (![self.radioType isEqualToString:@"4"]) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            self.dataArr = [NSMutableArray array];
            //页数
            self.pageNum = 1;
            // 请求数据
            [self requestData];
        }];
        
        [self.tableView.mj_header beginRefreshing];
        
        self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            self.pageNum ++;
            
            // 请求数据
            [self requestData];
        }];
    }
    else
    {
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.dataArr = [NSMutableArray array];
            //页数
            self.pageNum = 1;
            // 根据页数、电台类型、所属省市获取电台列表
            [self requestRecommendData];
        }];
        
        [self.tableView.mj_header beginRefreshing];
        self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            self.pageNum ++;
            // 根据页数、电台类型、所属省市获取电台列表
            [self requestRecommendData];
        }];
        
    }
}

// 请求数据
- (void)requestData {
    
    [[WGHNetWorking shareAcquireNetworkState] acquireCurrentNetworkState:^(int result) {
        if (result != 0) {
            // 根据页数、电台类型、所属省市获取电台列表
            [self requestRecommendData];
        }else {
            [[WGHNetWorking shareAcquireNetworkState] showPrompt];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

// 根据页数、电台类型、所属省市获取电台列表
- (void)requestRecommendData {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    //http://live.ximalaya.com/live-web/v1/getRadiosListByType?pageNum=1&radioType=2&device=android&provinceCode=110000&pageSize=15
    
    if ([self.radioType isEqualToString:@"4"]) {
        self.radioType = @"2";
    }
    
    NSString *typeURL = [NSString stringWithFormat:@"http://live.ximalaya.com/live-web/v1/getRadiosListByType?pageNum=%d&radioType=%@&device=android&provinceCode=%@&pageSize=15",self.pageNum,self.radioType,self.provinceCode];
    DLog(@"%@",typeURL);
    __weak typeof(self) weak = self;
    [[WGHRequestData shareRequestData] requestClassBroadcastTypeDataWithURL:typeURL block:^(NSMutableArray *array) {
        
        [weak.dataArr addObjectsFromArray:array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 绘制视图
            [self.tableView reloadData];
            
        });
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GD_BroadcastTopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:typeCellId forIndexPath:indexPath];
    
    GD_BroadcastTopRadioModel *model = self.dataArr[indexPath.row];
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

//地方台页cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 跳转播放界面
    WGHBroadcastPlayViewController *bpVC = [WGHBroadcastPlayViewController sharePlayerVC];
    
    
    bpVC.dataArray = self.dataArr;
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
