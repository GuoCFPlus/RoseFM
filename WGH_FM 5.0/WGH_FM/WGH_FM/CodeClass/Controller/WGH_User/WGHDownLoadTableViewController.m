//
//  WGHDownLoadTableViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/22.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHDownLoadTableViewController.h"

@interface WGHDownLoadTableViewController ()
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(strong,nonatomic)UIButton *deledeBtn;
@end

@implementation WGHDownLoadTableViewController
- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    if (self = [super initWithStyle:style]) {
        
        self.navigationItem.title = @"我的下载";
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
        
    }
    
    
    return self;
}

- (void)returnAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = 0;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self dataReload];
    
    [self.tableView registerClass:[WGHShowAlbumListCell class] forCellReuseIdentifier:@"cell"];
   
}
//加载数据
- (void)dataReload {
    
    //查询数据
    NSString * DocumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString * dataBasePath = [DocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[WGHLeanCloudTools sharedLeanUserTools].user]];
    //单例方法
    DataBaseTool * db = [DataBaseTool shareDataBase];
    //打开
    [db connectDB:dataBasePath];
    
    self.dataArray = [db selectAllDownload:@"1=1"];
    //关闭
    [db disconnectDB];
    
    [self.tableView reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.dataArray.count == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kGap_40)];
    
    view.backgroundColor = [UIColor colorWithRed:0.900 green:0.900 blue:0.900 alpha:1.000];
    
    self.deledeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.deledeBtn.tintColor = [UIColor orangeColor];
    [self.deledeBtn setTitle:@"❌ 清空历史" forState:UIControlStateNormal];
    self.deledeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    self.deledeBtn.frame = CGRectMake(0, 0, 200, kGap_30);
    
    self.deledeBtn.center = view.center;
    
    [self.deledeBtn addTarget:self action:@selector(deledeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:self.deledeBtn];
    
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return 0.0001;
    }
    return kGap_40;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.dataArray.count != 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64 - 45)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    label.centerX = kScreenWidth/2;
    label.centerY = view.frame.size.height/2 - 64;
    
    label.text = @"您还没有收藏过声音\n\n 尝试登录后再去收藏吧\n\n😊😊😊😊😊😊";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:label];
    
    return view;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.dataArray.count != 0) {
        return 0.00001;
    }
    return kScreenHeight-105;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WGHShowAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    WGHAlbumListModel *model = self.dataArray[indexPath.row];
    
    cell.albumModel = model;
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WGHShowListModel *model = self.dataArray[indexPath.row];
    //路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *audioPath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",model.title]];
    [[WGHBroadcastTools shareBroadcastPlayer] playRecordWithPath:audioPath];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString * DocumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString * dataBasePath = [DocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[WGHLeanCloudTools sharedLeanUserTools].user]];
        //单例方法
        DataBaseTool * db = [DataBaseTool shareDataBase];
        //打开
        [db connectDB:dataBasePath];
        WGHAlbumListModel *model = self.dataArray[indexPath.row];
        [db execDDLSql:[NSString stringWithFormat:@"delete from DownLoadList where playPathAacv164 = '%@' ",model.playPathAacv164]];
        [self.dataArray removeObject:model];
        //关闭
        [db disconnectDB];
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *audioPath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",model.title]];
        [[NSFileManager defaultManager] removeItemAtPath:audioPath error:nil];
        
        
        [self dataReload];
    }
}

- (void)deledeBtnAction {
    
    NSString * DocumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString * dataBasePath = [DocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[WGHLeanCloudTools sharedLeanUserTools].user]];
    //单例方法
    DataBaseTool * db = [DataBaseTool shareDataBase];
    //打开
    [db connectDB:dataBasePath];
    
    
    for (WGHAlbumListModel *model in self.dataArray) {
        [db execDDLSql:[NSString stringWithFormat:@"delete from DownLoadList where playPathAacv164 = '%@' ",model.playPathAacv164]];
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *audioPath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.aac",model.title]];
        [[NSFileManager defaultManager] removeItemAtPath:audioPath error:nil];
    }
    
    
    //关闭
    [db disconnectDB];
    
    [self dataReload];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [self dataReload];
    
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
