//
//  WGHHeaderStretchingTableViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/15.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHHeaderStretchingTableViewController.h"

@interface WGHHeaderStretchingTableViewController ()
/** 顶部拉伸的图片 */

/** 导航栏背景图片 */
@property (nonatomic, strong) UIImage *navigation_background_image;
@end
//头部被拉伸图片控件的默认高度`
CGFloat CFTopViewH = 200;
@implementation WGHHeaderStretchingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置内边距(让cell往下移动一段距离)
    self.tableView.contentInset = UIEdgeInsetsMake(CFTopViewH , 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    UIImageView *topView = [[UIImageView alloc] init];
    topView.frame = CGRectMake(0, -CFTopViewH, self.tableView.frame.size.width, CFTopViewH);
    [self.tableView addSubview:topView];
    self.topView = topView;
    
    
    
}


-(UIImage *)navigation_background_image{
    if(!_navigation_background_image){
        if(self.navigation_backgroundImageName){
            _navigation_background_image = [UIImage imageNamed:self.navigation_backgroundImageName];
        }
    }
    return _navigation_background_image;
}

-(void)setStretchingImageHeight:(CGFloat)stretchingImageHeight{
    _stretchingImageHeight = stretchingImageHeight;
    CFTopViewH = stretchingImageHeight;
    self.tableView.contentInset = UIEdgeInsetsMake(stretchingImageHeight , 0, 0, 0);
    self.topView.frame = CGRectMake(0, -CFTopViewH, self.tableView.frame.size.width, CFTopViewH);
}

- (void)setStretchingImageName:(NSString *)stretchingImageName{
    _stretchingImageName = stretchingImageName;
    self.topView.image = [UIImage imageNamed:stretchingImageName];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + CFTopViewH) / 2;
    
    
    if (yOffset < -CFTopViewH) {
        CGRect rect = self.topView.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = scrollView.frame.size.width + fabs(xOffset) * 2;
        
        self.topView.frame = rect;
        
        
    }
    
    CGFloat alpha = (yOffset + CFTopViewH) / CFTopViewH;
    if(self.edgesForExtendedLayout == UIRectEdgeTop || self.edgesForExtendedLayout == UIRectEdgeAll){
        
        
        [self.navigationController.navigationBar setBackgroundImage:[self imageByApplyingAlpha:alpha image:self.navigation_background_image == nil?[self imageWithColor:[UIColor clearColor]]:self.navigation_background_image] forBarMetrics:UIBarMetricsDefault];
    }
}

//设置图片透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
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
