//
//  WGHUserMainViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/15.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHUserMainViewController.h"

@interface WGHUserMainViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(strong,nonatomic)UIImageView *image;
@property(strong,nonatomic)UILabel *userName;
@property(strong,nonatomic)NSString *imagePath;
@property(strong,nonatomic)UIButton *setButton;

@property(strong,nonatomic)NSArray *array;

@end

@implementation WGHUserMainViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    if (self = [super initWithStyle:style]) {
        
        self.array = @[@[@"播放历史"],@[@"我赞过的",@"找听友"],@[@"仅在WIFI状态下载",@"消息推送",@"设置"]];
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 2、设置被拉伸图片view的高度
    self.stretchingImageHeight =200;
    
    // 3、设置头部拉伸图片的名称
    self.navigationItem.title = nil;
    self.stretchingImageName = @"wgh_user_header_stretching";
    self.navigationController.navigationBar.translucent = YES;
    [self addImageView];
    
    // 注册cell
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    // 设置header
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    
    UIButton *luyin = [[UIButton alloc] initWithFrame:CGRectMake(kGap_50, kGap_10, kScreenWidth-100, kGap_40)];
    [luyin setImage:[UIImage imageNamed:@"wgh_user_luyin"] forState:UIControlStateNormal];
    [luyin addTarget:self action:@selector(luyinAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:luyin];
    view.backgroundColor = [UIColor colorWithRed:0.950 green:0.950 blue:0.950 alpha:1.000];
    self.tableView.tableHeaderView = view;
    
    //设置footer
    self.tableView.tableFooterView = [UIView new];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    self.imagePath = [imageDocPath stringByAppendingPathComponent:@"WGH"];
    
    // Do any additional setup after loading the view.
}

- (void)addImageView {
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    view1.center = CGPointMake(kScreenWidth/2, -100);
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(loginAciton)];
    [view1 addGestureRecognizer:tap1];
    
    
    self.image = [[UIImageView alloc]init];
    self.image.userInteractionEnabled = YES;
    
    self.image.frame = CGRectMake(0, 0, 80, 80);
    self.image.layer.masksToBounds = YES;
    self.image.layer.cornerRadius = 40;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(Click)];
    [self.image addGestureRecognizer:tap2];
    
    
    self.image.image = [UIImage imageNamed:@"placeholder"];
    [view1 insertSubview:self.image atIndex:4];
    
    self.image.center = CGPointMake(view1.frame.size.width/2, view1.frame.size.height/2);
    
    [self.view insertSubview:view1 atIndex:3];
    self.userName = [[UILabel alloc]init];
    self.userName.frame = CGRectMake(0, 0, 200, 30);
    self.userName.font = [UIFont boldSystemFontOfSize:15];
    self.userName.center = CGPointMake(view1.frame.size.width/2, self.image.center.y + 65);
    self.userName.text = @"用户名";
    //改变字体颜色
    self.userName.textColor = [UIColor whiteColor];
    self.userName.textAlignment = NSTextAlignmentCenter;
    
    [view1 addSubview:self.userName];
    
    
    self.setButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.setButton.frame = CGRectMake(kGap_20, kGap_30, kGap_40, kGap_40);
    [self.setButton setImage:[UIImage imageNamed:@"wgh_user_shezhi"] forState:UIControlStateNormal];
    self.setButton.tintColor = [UIColor orangeColor];
    [self.setButton addTarget:self action:@selector(changedSetAction) forControlEvents:UIControlEventTouchUpInside];
    
    [view1 addSubview:self.setButton];
    
    
    [self.view addSubview:view1];

    
}
// 显示弹窗
- (void)Click{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * __nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * __nonnull action) {
        [self localPhoto];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        NSLog(@"该设备无摄像头");
    }
}
- (void)localPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

// 代理方法

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo{
    // 当图片部位空时显示图片并保存图片
    if (image != nil) {
        // 图片显示在界面上
        //        [self.imgView setBackgroundImage:image forState:UIControlStateNormal];
        self.image.image = image;
        // 以下是保存文件到沙盒路径下
        // 把图片转成NSData类型的数据类保存文件
        NSData *data = [NSData data];
        if (UIImagePNGRepresentation(image)) {
            // 返回Png图像
            data = UIImagePNGRepresentation(image);
        }else {
            
            // 返回Jpeg图像
            data = UIImageJPEGRepresentation(image, 1);
        }
        // 保存
        [[NSFileManager defaultManager] createFileAtPath:self.imagePath contents:data attributes:nil];
    }
    // 关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

// 区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.array.count;
    
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.array[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001;
    
}
// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    cell.textLabel.text = self.array[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"wgh_user_section%ld_row%ld",(long)indexPath.section,(long)indexPath.row]];
    if (indexPath.section == 2 && indexPath.row == 0) {
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchview setOn:YES];
        [UserDefaults setBool:switchview.isOn forKey:@"switch"];
        
        [switchview addTarget:self action:@selector(updateSwitch:) forControlEvents:UIControlEventValueChanged];
        NSLog(@"switchView =====  %d",switchview.isOn);
        cell.accessoryView = switchview;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        [self changedPlayHistory];
        
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        
        [self changedCollect];
        
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        
        [self changedFriend];
        
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        
    }else if (indexPath.section == 2 && indexPath.row == 1) {
        
    }else {
        [self changedSetAction];
    }
    
    
}

// 跳转播放历史界面
- (void)changedPlayHistory {
    
    NSLog(@"跳转播放历史界面");
    
}
// 收藏界面
- (void)changedCollect {
    
    NSLog(@"跳转收藏界面");
    
}

- (void)changedFriend {
    
    NSLog(@"跳转好友界面");
}

// 设置界面
- (void)changedSetAction {
    
    NSLog(@"跳转设置界面");
    
}


// 登录
- (void)loginAciton {
    
    NSLog(@"登录手势");
    
}

- (void)luyinAction {
    
    NSLog(@"开始录音");
    
}


//下载模式
-(void)updateSwitch:(UISwitch *)sender{
    
    [UserDefaults setBool:sender.isOn forKey:@"switch"];
    [UserDefaults synchronize];
    NSLog(@"sender ===== %d",sender.isOn);
    
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
