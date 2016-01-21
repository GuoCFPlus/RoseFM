//
//  WGHHotLIstDetailsTableViewController.m
//  WGH_FM
//
//  Created by 韩明雨 on 16/1/16.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHHotLIstDetailsTableViewController.h"

@interface WGHHotLIstDetailsTableViewController ()
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(assign,nonatomic)int pageId;
@end
static NSString *const HotListDetailsCellID=@"HotListDetailsCellID";
static NSString *const HotListCellID=@"HotListCellID";
static NSString *const HotListAnchorCellID=@"WGHHotListAnchorCellID";
@implementation WGHHotLIstDetailsTableViewController
- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"wgh_navigationbar_xiangxia"] style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
        
    }
    return self;
}
- (void)returnAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    self.navigationItem.titleView = label;
    label.text = self.model.title;
    [label sizeToFit];
    
    [self.tableView registerClass:[WGHHotListDetailsTableViewCell class] forCellReuseIdentifier:HotListDetailsCellID];
    [self.tableView registerClass:[WGHHotListDetailsCell class] forCellReuseIdentifier:HotListCellID];
    [self.tableView registerClass:[WGHHotListAnchorCell class] forCellReuseIdentifier:HotListAnchorCellID];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.dataArray = [NSMutableArray array];
        self.pageId = 1;
        // 判断网络状态
        [self requestNetWorking];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        self.pageId++;
        // 判断网络状态
        [self requestNetWorking];
    }];
    
}
- (void)requestNetWorking {
    
    [[WGHNetWorking shareAcquireNetworkState] acquireCurrentNetworkState:^(int result) {
        
        if (result != 0) {
            [self requestOneHotListData];
        }else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [[WGHNetWorking shareAcquireNetworkState] showPrompt];
            
        }
    }];
}


- (void)requestOneHotListData {
    
    NSString *url = [NSString stringWithFormat:WGH_OneHotListURL,self.model.contentType,self.model.key,self.pageId];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([self.model.contentType isEqualToString:@"track"]) {
        [[WGHRequestData shareRequestData] requestOneHotListDataWithURL:url block:^(NSMutableArray *array) {
            
            [self.dataArray addObjectsFromArray:array];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            });
            
        }];
    }else if ([self.model.contentType isEqualToString:@"album"]) {
        [[WGHRequestData shareRequestData] requestListParsenDataWithURL:url block:^(NSMutableArray *array) {
            
            [self.dataArray addObjectsFromArray:array];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.pageId++;
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            });
            
        }];
    }else {
        [[WGHRequestData shareRequestData] requestOneHotListDataWithURL:url block:^(NSMutableArray *array) {
            
            [self.dataArray addObjectsFromArray:array];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            });
            
        }];
        
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.model.contentType isEqualToString:@"track"]) {
        WGHHotListDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HotListDetailsCellID forIndexPath:indexPath];
        WGHHotListDetailsModel *model = self.dataArray[indexPath.row];
        cell.numberLabel.text = [NSString stringWithFormat:@"%d",(int)(indexPath.row+1)];
        if (indexPath.row == 0) {
            cell.numberLabel.textColor = [UIColor orangeColor];
        }else if (indexPath.row == 1) {
            cell.numberLabel.textColor = [UIColor redColor];
        }else if (indexPath.row == 2) {
            cell.numberLabel.textColor = [UIColor cyanColor];
        }else {
            cell.numberLabel.textColor = [UIColor grayColor];
        }
        cell.hotDetailsModel = model;
        return cell;
    }else if([self.model.contentType isEqualToString:@"album"]) {
        
        WGHHotListDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:HotListCellID forIndexPath:indexPath];
        WGHShowListModel *model = self.dataArray[indexPath.row];
        cell.numberLabel.text = [NSString stringWithFormat:@"%d",(int)(indexPath.row+1)];
        if (indexPath.row == 0) {
            cell.numberLabel.textColor = [UIColor orangeColor];
        }else if (indexPath.row == 1) {
            cell.numberLabel.textColor = [UIColor redColor];
        }else if (indexPath.row == 2) {
            cell.numberLabel.textColor = [UIColor cyanColor];
        }else {
            cell.numberLabel.textColor = [UIColor grayColor];
        }
       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.hotDetailsModel = model;
        return cell;
        
    }else {
        WGHHotListAnchorCell *cell=[tableView dequeueReusableCellWithIdentifier:HotListAnchorCellID forIndexPath:indexPath];
        WGHHotListDetailsModel *model = self.dataArray[indexPath.row];
        cell.numberLabel.text = [NSString stringWithFormat:@"%d",(int)(indexPath.row+1)];
        if (indexPath.row == 0) {
            cell.numberLabel.textColor = [UIColor orangeColor];
        }else if (indexPath.row == 1) {
            cell.numberLabel.textColor = [UIColor redColor];
        }else if (indexPath.row == 2) {
            cell.numberLabel.textColor = [UIColor cyanColor];
        }else {
            cell.numberLabel.textColor = [UIColor grayColor];
        }
        cell.hotDetailsModel = model;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (![self.model.contentType isEqualToString:@"track"]) {
        // 跳转专辑界面
        WGHAlbumListTableViewController *albumListVC = [[WGHAlbumListTableViewController alloc] init];
        WGHShowListModel *showListModel = self.dataArray[indexPath.row];
        albumListVC.showListModel = showListModel;
        UINavigationController *albumListNC = [[UINavigationController alloc] initWithRootViewController:albumListVC];
        [albumListNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont,nil]];
        albumListNC.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000];
        albumListNC.navigationBar.alpha = 0;
        [self presentViewController:albumListNC animated:YES completion:nil];
    }else if ([self.model.contentType isEqualToString:@"track"]) {
        
        
        
        
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
