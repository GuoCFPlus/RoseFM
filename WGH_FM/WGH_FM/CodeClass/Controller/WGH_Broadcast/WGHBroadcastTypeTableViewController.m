//
//  WGHBroadcastTypeTableViewController.m
//  WGH_FM
//
//  Created by lanou3g on 16/1/18.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHBroadcastTypeTableViewController.h"

@interface WGHBroadcastTypeTableViewController ()

@property (strong, nonatomic)NSArray *dataArr;

@property (assign, nonatomic)NSInteger pageNum;

@end

static NSString *const typeCellId = @"typeCellId";

@implementation WGHBroadcastTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[GD_BroadcastTopViewCell class] forCellReuseIdentifier:typeCellId];
    //页数
    self.pageNum = 1;
    //加载数据
    [self requestRecommendData];
    DLog(@"%@",self.radioType);
    
}

// 请求主界面 推荐
- (void)requestRecommendData {
    
    __weak typeof(self) weak = self;
    
    //http://live.ximalaya.com/live-web/v1/getRadiosListByType?pageNum=1&radioType=2&device=android&provinceCode=110000&pageSize=15
    
    NSString *typeURL = [NSString stringWithFormat:@"http://live.ximalaya.com/live-web/v1/getRadiosListByType?pageNum=%ld&radioType=%@&device=android&provinceCode=%@&pageSize=15",self.pageNum,self.radioType,self.provinceCode];
    DLog(@"%@",typeURL);
    
    [[WGHRequestData shareRequestData] requestClassBroadcastTypeDataWithURL:typeURL block:^(NSMutableArray *array) {
        weak.dataArr = [NSMutableArray arrayWithArray:array];
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
