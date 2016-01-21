//
//  WGHBroadcastProvinceViewController.m
//  WGH_FM
//
//  Created by lanou3g on 16/1/18.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHBroadcastProvinceViewController.h"

@interface WGHBroadcastProvinceViewController ()
@property (strong, nonatomic)NSArray *provinceArr;
@end

@implementation WGHBroadcastProvinceViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        UIImage *image = [UIImage imageNamed:@"wgh_navigationbar_xiangxia"];
        //image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
    }
    
    return self;
    
}

- (void)returnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}






// 请求省市数据
- (void)requestProvincesData {
    
    __weak typeof(self) weak = self;
    
    [[WGHRequestData shareRequestData] requestClassBroadcastProvinceDataWithURL:WGH_ProvincesTitleURL block:^(NSMutableArray *array) {
        weak.provinceArr = [NSMutableArray arrayWithArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self drawView];
        });
    }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = 0;
    }
        
    //获取数据
    [self requestProvincesData];
    [self drawView];
}
//加载视图
-(void)drawView{
    
    [[WGHNetWorking shareAcquireNetworkState] acquireCurrentNetworkState:^(int result) {
        if (result != 0) {
            
            NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:self.provinceArr.count];
            
            for (int i = 0; i < self.provinceArr.count; i++) {
                WGHBroadcastTypeTableViewController *provinceVC = [[WGHBroadcastTypeTableViewController alloc]initWithStyle:UITableViewStylePlain];
                GD_ProvinceModel *model = self.provinceArr[i];
                provinceVC.title = model.provinceName;
                provinceVC.radioType = @"4";
                provinceVC.provinceCode = [NSString stringWithFormat:@"%@",model.provinceCode];
                //provinceVC.tableView.backgroundColor = [UIColor colorWithRed:arc4random()%255/256.0 green:arc4random()%255/256.0 blue:arc4random()%255/256.0 alpha:1];
                [arr addObject:provinceVC];
                
            }
            
            SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc]init];
            navTabBarController.subViewControllers = arr;
            navTabBarController.showArrowButton = YES;
            [navTabBarController addParentController:self];
            //    [self addChildViewController:navTabBarController];
            //    [self.view addSubview:navTabBarController.mainView];
        }else {
            
            [[WGHNetWorking shareAcquireNetworkState] showPrompt];
            
        }
        
    }];
    
    
    
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
