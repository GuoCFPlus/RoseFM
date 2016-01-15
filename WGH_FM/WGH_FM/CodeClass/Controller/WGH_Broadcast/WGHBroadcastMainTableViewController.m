//
//  WGHBroadcastMainTableViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/14.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHBroadcastMainTableViewController.h"

#define kBgColorGray [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]
#define kLineHeight 20
#define kIconViewWidth kScreenWidth/4
#define kIconViewHeight (kIconViewWidth + kGap_10 + kLineHeight)

@interface WGHBroadcastMainTableViewController ()

@end

@implementation WGHBroadcastMainTableViewController

//头视图绘制
-(void)drawHeaderView{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kIconViewHeight+kGap_10)];
    headerView.backgroundColor = kBgColorGray;
    
    //本地台
    GD_BroadcastTypeView *localView = [[GD_BroadcastTypeView alloc]initWithFrame:CGRectMake(0, 0, kIconViewWidth, kIconViewHeight)];
    [localView.imgButton addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    localView.imgButton.tag = 101;
    [headerView addSubview:localView];
    
    //国家台
    GD_BroadcastTypeView *countryView = [[GD_BroadcastTypeView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(localView.frame), 0, kIconViewWidth, kIconViewHeight)];
    [countryView.imgButton setImage:[UIImage imageNamed:@"wgh_guangbo_guojia"] forState:UIControlStateNormal];
    countryView.nameLabel.text = @"国家台";
    [countryView.imgButton addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    countryView.imgButton.tag = 102;
    [headerView addSubview:countryView];
    
    //省市台
    GD_BroadcastTypeView *cityView = [[GD_BroadcastTypeView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(countryView.frame), 0, kIconViewWidth, kIconViewHeight)];
    [cityView.imgButton setImage:[UIImage imageNamed:@"wgh_guangbo_shengshi"] forState:UIControlStateNormal];
    cityView.nameLabel.text = @"省市台";
    [cityView.imgButton addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    cityView.imgButton.tag = 103;
    [headerView addSubview:cityView];
    
    
    //网络台
    GD_BroadcastTypeView *webView = [[GD_BroadcastTypeView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cityView.frame), 0, kIconViewWidth, kIconViewHeight)];
    [webView.imgButton setImage:[UIImage imageNamed:@"wgh_guangbo_wangluo"] forState:UIControlStateNormal];
    webView.nameLabel.text = @"网络台";
    [webView.imgButton addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    webView.imgButton.tag = 104;
    [headerView addSubview:webView];
    
    self.tableView.tableHeaderView = headerView;
    
}

//头视图button点击事件
-(void)changePage:(UIButton *)sender{
    switch (sender.tag) {
        case 101:
        {
            DLog(@"这是本地台");
            break;
        }
        case 102:
        {
            DLog(@"这是国家台");
            break;
        }
        case 103:
        {
            DLog(@"这是省市台");
            break;
        }
        case 104:
        {
            DLog(@"这是网络台");
            break;
        }
        default:
            DLog(@"出错了");
            break;
    }
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //头视图绘制
    [self drawHeaderView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
