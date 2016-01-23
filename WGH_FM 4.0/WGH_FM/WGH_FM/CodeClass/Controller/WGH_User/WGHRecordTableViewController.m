//
//  WGHRecordTableViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/21.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHRecordTableViewController.h"

@interface WGHRecordTableViewController ()

@property(strong,nonatomic)NSMutableArray *recordArray;


@end

@implementation WGHRecordTableViewController


- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    if (self = [super initWithStyle:style]) {
        
        self.navigationItem.title = @"我的录音";
        
        self.recordArray = [NSMutableArray array];
        
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
        
    }
    
    return self;
}

- (void)returnAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wgh_recorde_image"]];
    
    NSString * DocumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString * dataBasePath = [DocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[WGHLeanCloudTools sharedLeanUserTools].user]];
    //单例方法
    DataBaseTool * db = [DataBaseTool shareDataBase];
    //打开
    [db connectDB:dataBasePath];
    self.recordArray = [db selectAllRecord:@"1=1"];
    //关闭
    [db disconnectDB];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    RecordListModel *model = self.recordArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.textColor = [UIColor orangeColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecordListModel *model = self.recordArray[indexPath.row];
    //路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *audioPath = [doc stringByAppendingPathComponent:model.name];
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
         RecordListModel *model = self.recordArray[indexPath.row];
        [db execDDLSql:[NSString stringWithFormat:@"delete from RecordList where name = '%@' ",model.name]];
        [self.recordArray removeObject:model];
        //关闭
        [db disconnectDB];
        //路径
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *audioPath = [doc stringByAppendingPathComponent:model.name];
        [[NSFileManager defaultManager] removeItemAtPath:audioPath error:nil];
        
        [self.tableView reloadData];
    }
}




- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSString * DocumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString * dataBasePath = [DocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[WGHLeanCloudTools sharedLeanUserTools].user]];
    //单例方法
    DataBaseTool * db = [DataBaseTool shareDataBase];
    //打开
    [db connectDB:dataBasePath];
    
    self.recordArray = [db selectAllRecord:@"1=1"];
    
    //关闭
    [db disconnectDB];
    
    [self.tableView reloadData];
    
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
