//
//  WGHSettingTableViewController.m
//  WGH_FM
//
//  Created by 韩明雨 on 16/1/20.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHSettingTableViewController.h"

@interface WGHSettingTableViewController ()<UIAlertViewDelegate>
@property(strong,nonatomic)NSArray *array;
@property(strong,nonatomic)UISwitch *alarmClock;
@property(strong,nonatomic)UILabel *versionLabel;
@property(strong,nonatomic)NSTimer *timer;
@end
static NSString *const systemCellID=@"systemCellID";
@implementation WGHSettingTableViewController
-(instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self=[super initWithStyle:style]) {
        
        self.navigationItem.title = @"设置";
        
        self.array=@[@[@"特色闹铃",@"定时关闭"],@[@"清理缓存",@"修改密码",@"检查更新",@"联系我们@",@"免责声明"]];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
        
        
    }
    return self;
}

- (void)returnAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:systemCellID];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.00001;
    }
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemCellID forIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        self.alarmClock = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        self.alarmClock.on = [UserDefaults boolForKey:@"alarm"];
        
        [self.alarmClock addTarget:self action:@selector(setAlarmClock) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = self.alarmClock;
        
    }
    
    
    cell.textLabel.text=self.array[indexPath.section][indexPath.row];
    cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"wgh_shezhi_section%ld_row%ld",(long)indexPath.section,(long)indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


// 设置footer
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(kGap_50, kGap_20, kScreenWidth-100, kGap_40)];
    cancel.backgroundColor = [UIColor orangeColor];
    cancel.layer.cornerRadius = 5;
    cancel.layer.masksToBounds = YES;
    [cancel setTitle:@"退出登录" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancel];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        
        
        
        
        
        
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        TimerViewController *timerVC = [[TimerViewController alloc] init];
        timerVC.isModal = NO;
        
        [self.navigationController pushViewController:timerVC animated:YES];
        
        
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        
        NSUInteger byteSize = [SDImageCache sharedImageCache].getSize;
        //M
        double size = byteSize/1000/1000;
        
        NSString *string = [NSString stringWithFormat:@"图片缓存为:%.01fM,确定清理么!",size];
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"友情提示" message:string preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [[SDImageCache sharedImageCache] clearDisk];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertCon addAction:sureAction];
        [alertCon addAction:cancleAction];
        //弹出
        [self presentViewController:alertCon animated:YES completion:nil];
        
        
        
        
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        
        WGHRetrieveViewController *retrieve = [[WGHRetrieveViewController alloc] init];
        retrieve.number = 1;
        [self.navigationController pushViewController:retrieve animated:YES];
        
        
    }else if (indexPath.section == 1 && indexPath.row == 2) {
        
        self.versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, kGap_40)];
        self.versionLabel.backgroundColor = [UIColor colorWithRed:0.001 green:0.001 blue:0.001 alpha:0.7];
        self.versionLabel.center = CGPointMake(kScreenWidth/2, kScreenHeight+kGap_20);
        self.versionLabel.layer.cornerRadius = 3;
        self.versionLabel.layer.masksToBounds = YES;
        self.versionLabel.textAlignment = NSTextAlignmentCenter;
        self.versionLabel.font = [UIFont systemFontOfSize:14];
        self.versionLabel.textColor = [UIColor whiteColor];
        self.versionLabel.text = @"当前已是最新版本";
        [self.view addSubview:self.versionLabel];
        
        
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showView) userInfo:nil repeats:YES];
        
        
    }else if (indexPath.section == 1 && indexPath.row == 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系我们" message:@"如有问题请联系我们\n\nQQ邮箱:  370006600@qq.com\nQQ邮箱:  734440641@qq.com\nQQ邮箱:  240655466@qq.com" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else if (indexPath.section == 1 && indexPath.row == 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"免责声明" message:@"1、一切移动客户端用户在下载并浏览本APP软件时均被视为已经仔细阅读本条款并完全同意。凡以任何方式登陆本APP，或直接、间接使用本APP资料者，均被视为自愿接受本APP相关声明和用户服务协议的约束。\n  2、本APP转载的内容并不代表本APP之意见及观点，也不意味着本APP赞同其观点或证实其内容的真实性。\n  3、本APP转载的文字、图片、音视频等资料均来自互联网，其真实性、准确性和合法性由信息发布人负责。本APP不提供任何保证，并不承担任何法律责任。\n  4、本APP所转载的文字、图片、音视频等资料，如果侵犯了第三方的知识产权或其他权利，责任由作者或转载者本人承担，本APP对此不承担责任。\n  5、本APP不保证为向用户提供便利而设置的外部链接的准确性和完整性，同时，对于该外部链接指向的不由本APP实际控制的任何网页上的内容，本APP不承担任何责任。\n  6、用户明确并同意其使用本APP网络服务所存在的风险将完全由其本人承担；因其使用本APP网络服务而产生的一切后果也由其本人承担，本APP对此不承担任何责任。\n  7、除本APP注明之服务条款外，其它因不当使用本APP而导致的任何意外、疏忽、合约毁坏、诽谤、版权或其他知识产权侵犯及其所造成的任何损失，本APP概不负责，亦不承担任何法律责任。\n  8、对于因不可抗力或因黑客攻击、通讯线路中断等本APP不能控制的原因造成的网络服务中断或其他缺陷，导致用户不能正常使用本APP，本APP不承担任何责任，但将尽力减少因此给用户造成的损失或影响。\n  9、本声明未涉及的问题请参见国家有关法律法规，当本声明与国家有关法律法规冲突时，以国家法律法规为准。\n  10、本网站相关声明版权及其修改权、更新权和最终解释权均属本APP所有。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)showView {
    
    [self.timer invalidate];
    self.timer = nil;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.versionLabel.centerY = kScreenHeight/2 - 64;
        
    }];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removeView) userInfo:nil repeats:YES];
    
}

- (void)removeView {
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self.versionLabel removeFromSuperview];
    
}

- (void)cancelAction {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要注销当前用户" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    UIAlertAction *defaultlAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[WGHLeanCloudTools sharedLeanUserTools] logOut];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:defaultlAction];
    [alertController addAction:cancelAction];
    
}


- (void)setAlarmClock {
    
    [UserDefaults setBool:self.alarmClock.on forKey:@"alarm"];
    
    if (self.alarmClock.on == YES) {
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"每天早上8点蔷薇FM通知您" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // 如果点击确定添加
    if (buttonIndex == 1) {
        
        [WGHSettingTableViewController registLocalNotification];
        
    }else {
        [UserDefaults setBool:NO forKey:@"alarm"];
        self.alarmClock.on = [UserDefaults boolForKey:@"alarm"];
        
    }
    
}



+ (void)registLocalNotification {
    
    // 初始化一个本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    //获取东八区时间
    NSTimeInterval t = 8*60*60;
    // 设置通知什么时候触发
    notification.fireDate = [NSDate dateWithTimeIntervalSinceReferenceDate:t];
    
    // 设置重复.(按天)
    notification.repeatInterval = kCFCalendarUnitDay;
    
    // 设置弹窗通知内容
    notification.alertBody = @"主人";
    
    // 设置气泡个数
    notification.applicationIconBadgeNumber = 1;
    
    // 设置通知声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    // 通知参数, userInfo.
    NSDictionary * userDic = [NSDictionary dictionaryWithObject:@"蔷薇FM通知您" forKey:@"hurry"];
    notification.userInfo = userDic;
    
    // 最后一步, 将这个通知交给iOS操作系统
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    
}
// 根据传入的key, 移除本地通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    
    // 从当前的app中找出所有的本地通知.
    NSArray *notificationArray = [UIApplication sharedApplication].scheduledLocalNotifications;
    // 如果按照key寻找userInfo, 不为空则说明找到了.
    for (UILocalNotification * notification in notificationArray) {
        if ([notification.userInfo valueForKey:key]) {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
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
