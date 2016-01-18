//
//  WGHBroadcastRankMoreTableViewController.m
//  WGH_FM
//
//  Created by lanou3g on 16/1/18.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHBroadcastRankMoreTableViewController.h"

@interface WGHBroadcastRankMoreTableViewController ()

@property (strong, nonatomic)NSMutableArray *dataArr;

@end
static NSString *const rankCellId = @"rankCellId";
@implementation WGHBroadcastRankMoreTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"电台排行榜";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[GD_BroadcastRankMoreTableViewCell class] forCellReuseIdentifier:rankCellId];
    
    //加载排行数据
    [self requestRecommendData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        // 请求数据
        [self requestData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        
        // 请求数据
        [self requestData];
    }];
    
    
}

// 请求数据
- (void)requestData {
    
    [[WGHNetWorking shareAcquireNetworkState] acquireCurrentNetworkState:^(int result) {
        if (result != 0) {
            // 获取排名前一百的电台列表
            [self requestRecommendData];
            
        }else {
            [[WGHNetWorking shareAcquireNetworkState] showPrompt];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

//加载排行数据
- (void)requestRecommendData {
    
    __weak typeof(self) weak = self;
    
    [[WGHRequestData shareRequestData] requestClassBroadcastTypeDataWithURL:WGH_RankingListURL block:^(NSMutableArray *array) {
        weak.dataArr = [NSMutableArray arrayWithArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 绘制视图
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
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
    GD_BroadcastRankMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rankCellId forIndexPath:indexPath];
    
    GD_BroadcastTopRadioModel *model = self.dataArr[indexPath.row];
    if (model != nil) {
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1] ;
        if ([cell.numberLabel.text isEqualToString:@"1"]) {
            cell.numberLabel.textColor = [UIColor redColor];
        }
        else if([cell.numberLabel.text isEqualToString:@"2"]){
            cell.numberLabel.textColor = [UIColor orangeColor];
        }
        else if([cell.numberLabel.text isEqualToString:@"3"])
        {
            cell.numberLabel.textColor = [UIColor cyanColor];
        }
        else
        {
            cell.numberLabel.textColor = [UIColor blackColor];
        }
        [cell.radioCoverLargeImgView sd_setImageWithURL:[NSURL URLWithString:model.radioCoverLarge] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cell.rnameLabel.text = model.rname;
        cell.programNameLabel.text = model.programName;
        cell.radioPlayCountLabel.text = [NSString stringWithFormat:@"%.1f万人",[model.radioPlayCount floatValue] /10000];
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
