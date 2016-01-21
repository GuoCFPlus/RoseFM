//
//  WGHBroadcastTypeTableViewController.m
//  WGH_FM
//
//  Created by lanou3g on 16/1/18.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHBroadcastTypeTableViewController.h"

@interface WGHBroadcastTypeTableViewController ()<CLLocationManagerDelegate>
//数据数组
@property (strong, nonatomic)NSMutableArray *dataArr;
//页码
@property (assign, nonatomic)int pageNum;
//定位管理类
@property (nonatomic, strong) CLLocationManager  *locationManager;
//编码和反编码工具类
@property(nonatomic,strong)CLGeocoder *geo;

@property(assign,nonatomic)CGFloat latitude;
@property(assign,nonatomic)CGFloat longitude;

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
    
    //判断当前设备是否支持定位
    if ([CLLocationManager locationServicesEnabled]) {
        DLog(@"支持定位");
    }
    else
    {
        DLog(@"不支持定位");
    }
    //定位功能
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    //向系统和用户申请使用权限
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        //判断当前状态是拒绝的话，开始申请
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //定位的精度（效果）如何
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //多少米定位一次
    self.locationManager.distanceFilter = 10;
    //始终允许访问位置信息
    //[self.locationManager requestAlwaysAuthorization];
    //使用应用程序期间允许访问位置数据
    //[self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
//    // 编码与反编码初始化
//    self.geo = [[CLGeocoder alloc] init];
//    // 反编码
//    [self getCityNameWithCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
    
    //[self getCityNameWithCoordinate:CLLocationCoordinate2DMake(40, 116)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[GD_BroadcastTopViewCell class] forCellReuseIdentifier:typeCellId];
    
}

//获取到位置数据，返回的是一个CLLocation的数组，一般使用其中的一个
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    CLLocation *currLocation = [locations lastObject];
//    DLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
//    self.latitude = currLocation.coordinate.latitude;
//    self.longitude = currLocation.coordinate.longitude;
    
    //获取经纬度,拼接url字符串
    CLLocation *loc=locations.lastObject;

    NSString *str = [NSString stringWithFormat:@"http://location.ximalaya.com/locationService/location?device=iPhone&ip=%%28null%%29&latitude=%f&longitude=%f&uid=0&version=v1",loc.coordinate.latitude,loc.coordinate.longitude];
    DLog(@"%@",str);
    [[WGHRequestData shareRequestData] requestClassBroadcastLocationDataWithURL:str block:^(NSString *locationCode) {
        self.provinceCode = locationCode;
        DLog(@"%@",self.provinceCode);
        dispatch_async(dispatch_get_main_queue(), ^{
            // 绘制视图
            [self.tableView reloadData];
            
        });
    }];
    [self.locationManager stopUpdatingLocation];
    
}

//获取用户位置数据失败的回调方法，在此通知用户
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        DLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        DLog(@"无法获取位置信息");
    }
}

//在viewWillDisappear关闭定位
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_locationManager stopUpdatingLocation];
}

//反编码，根据坐标返回城市名称
-(void)getCityNameWithCoordinate:(CLLocationCoordinate2D)coor{
    
    CLLocation *locat = [[CLLocation alloc]initWithLatitude:coor.latitude longitude:coor.longitude];
    [self.geo reverseGeocodeLocation:locat completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            DLog(@"反编码失败：%@",error);
        }
        CLPlacemark *placeMark = [placemarks lastObject];
        //遍历结果
        [placeMark.addressDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ( [key isEqualToString:@"FormattedAddressLines"]) {
                for (NSString *str in obj) {
                    DLog(@"===%@",str);
                }
            }else
            {
                DLog(@"%@ : %@",key, obj);
            }
        }];
    }];
    
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
