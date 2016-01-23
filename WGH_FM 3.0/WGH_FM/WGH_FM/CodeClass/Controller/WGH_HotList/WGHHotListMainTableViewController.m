//
//  WGHHotListMainTableViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/14.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHHotListMainTableViewController.h"

@interface WGHHotListMainTableViewController ()

@property(strong,nonatomic)NSMutableArray *dataArray;
@property(strong,nonatomic)NSDictionary *focusDic;
@property(strong,nonatomic)UIImageView *focusImgView;

@end
static NSString *const HotListProgramCellID=@"HotListProgramCellID";
@implementation WGHHotListMainTableViewController
-(instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self=[super initWithStyle:style]) {
       
        self.navigationItem.title = @"热榜";
         
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.dataArray = [NSMutableArray array];
    
    //注册榜单cell
    [self.tableView registerClass:[WGHHotListProgramCell class] forCellReuseIdentifier:HotListProgramCellID];

    // 解析数据
    [self requestHotListData];
    
    // 设置header
    [self setupHeaderView];
    
    
}
// 设置header
- (void)setupHeaderView {
    
    self.focusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/5*2)];
    self.tableView.tableHeaderView = self.focusImgView;
    self.focusImgView.userInteractionEnabled = YES;
    // 添加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
    [self.focusImgView addGestureRecognizer:singleTap];
    
}
// 焦点视图的触发方法
- (void)buttonpress:(UITapGestureRecognizer *)gestureRecognizer {
    
    WGHFcousViewController *fcousVC = [WGHFcousViewController new];
    fcousVC.dic = self.focusDic;
    fcousVC.urlStr = self.focusDic[@"url"];
    UINavigationController *fcousNC = [[UINavigationController alloc] initWithRootViewController:fcousVC];
    [fcousNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont,nil]];
    fcousNC.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000];
    fcousNC.navigationBar.alpha = 0;
    [self presentViewController:fcousNC animated:YES completion:nil];
}

- (void)requestHotListData {
    
    [[WGHRequestData shareRequestData] requestHotListDataWithURL:WGH_HotListURL block:^(NSMutableArray *array, NSMutableDictionary *dictionary) {
        
        [self.dataArray addObjectsFromArray:array];
        self.focusDic = dictionary;
        dispatch_async(dispatch_get_main_queue(), ^{
          
            [self.focusImgView sd_setImageWithURL:[NSURL URLWithString:self.focusDic[@"pic"]] placeholderImage:[UIImage imageNamed:@"scrollDownFail"]];
            [self.tableView reloadData];
            
            
        });
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

// 区头标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.dataArray[section] allKeys] firstObject];
}

// 区头高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kGap_30;
}
//区尾
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = [[self.dataArray[section] allKeys] firstObject];
    
    return [[self.dataArray[section] objectForKey:key] count];
    
}
// cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    WGHHotListProgramCell *cell=[tableView dequeueReusableCellWithIdentifier:HotListProgramCellID forIndexPath:indexPath];
    
    NSString *key = [[self.dataArray[indexPath.section] allKeys] firstObject];
    
    WGHHotListModel *model =  [self.dataArray[indexPath.section] objectForKey:key][indexPath.row];
    
    cell.hotListModel=model;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
//跳转到详情界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WGHHotLIstDetailsTableViewController *details=[WGHHotLIstDetailsTableViewController new];
    NSString *key=[[self.dataArray[indexPath.section]allKeys]firstObject];
    WGHHotListModel *model = [self.dataArray[indexPath.section]objectForKey:key][indexPath.row];
    details.model = model;
    UINavigationController *detailsNC = [[UINavigationController alloc] initWithRootViewController:details];
    [detailsNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000],UITextAttributeTextColor,[UIFont systemFontOfSize:18],UITextAttributeFont,nil]];
    detailsNC.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.304 blue:0.156 alpha:1.000];
    detailsNC.navigationBar.alpha = 0;
    [self presentViewController:detailsNC animated:YES completion:nil];
    
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
