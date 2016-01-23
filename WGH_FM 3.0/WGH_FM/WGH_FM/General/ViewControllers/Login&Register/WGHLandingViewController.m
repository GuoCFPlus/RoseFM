//
//  WGHLandingViewController.m
//  WGH_FM
//
//  Created by 韩明雨 on 16/1/19.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHLandingViewController.h"

@interface WGHLandingViewController ()<UITextFieldDelegate>
@property(strong,nonatomic)UITextField *userNameField;// 用户名
@property(strong,nonatomic)UITextField *codeTextField;// 密码
@property(strong,nonatomic)UIButton *weixinButton;// 微信登陆
@property(strong,nonatomic)UIButton *qqButton;// QQ登陆
@property(strong,nonatomic)UIButton *weiboButton;// 微博登陆
@property(strong,nonatomic)UIButton *loginButton;// 注册
@property(strong,nonatomic)UIButton *landingButton;// 登陆
@property(strong,nonatomic)UIButton *retrieveButton;// 忘记密码/找回
@end

@implementation WGHLandingViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.title=@"登陆";
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
        
    }
    return self;
}

- (void)returnAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#define kButtonWidth kScreenWidth/4
#define kButtonHeight kScreenHeight/8



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 控制scrollView的位置
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = 0;
    }
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
    
    self.userNameField=[[UITextField alloc]initWithFrame:CGRectMake(kButtonWidth-70, kGap_30, kButtonWidth*2+140, 40)];
    self.userNameField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.userNameField.layer.borderWidth=0.7;
    self.userNameField.layer.cornerRadius=5;
    self.userNameField.layer.masksToBounds=YES;
    self.userNameField.placeholder=@"用户名或邮箱:";
    self.userNameField.delegate = self;
    [self.view addSubview:_userNameField];
    
    self.codeTextField=[[UITextField alloc]initWithFrame:CGRectMake(kButtonWidth-70, CGRectGetMaxY(self.userNameField.frame)+15, kButtonWidth*2+140, 40)];
    self.codeTextField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.codeTextField.layer.borderWidth=0.7;
    self.codeTextField.layer.cornerRadius=5;
    self.codeTextField.layer.masksToBounds=YES;
    self.codeTextField.placeholder=@"请输入密码:";
    self.codeTextField.secureTextEntry = YES;
    self.codeTextField.delegate = self;
    [self.view addSubview:_codeTextField];
    
    
    self.loginButton=[[UIButton alloc]initWithFrame:CGRectMake(kButtonWidth-70, CGRectGetMaxY(self.codeTextField.frame)+15, kButtonWidth+65, 40)];
    [self.loginButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.loginButton.layer.borderColor=[[UIColor orangeColor]CGColor];
    self.loginButton.layer.borderWidth=0.7;
    self.loginButton.layer.cornerRadius=5;
    self.loginButton.layer.masksToBounds=YES;
    [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    self.landingButton=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.loginButton.frame)+10, CGRectGetMaxY(self.codeTextField.frame)+15, kButtonWidth+65, 40)];
    self.landingButton.backgroundColor=[UIColor orangeColor];
    [self.landingButton setTitle:@"登录" forState:UIControlStateNormal];
    self.landingButton.layer.cornerRadius=5;
    self.landingButton.layer.masksToBounds=YES;
    [self.landingButton addTarget:self action:@selector(landingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_landingButton];
    
    self.retrieveButton=[[UIButton alloc]initWithFrame:CGRectMake(kButtonWidth*3-10, CGRectGetMaxY(self.landingButton.frame)+10, 80, 15)];
    [self.retrieveButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [self.retrieveButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.retrieveButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [self.retrieveButton addTarget:self action:@selector(retrieveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_retrieveButton];
    
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.retrieveButton.frame)+kGap_10, kScreenWidth-60, 1)];
    line.alpha=0.6;
    line.backgroundColor=[UIColor grayColor];
    [self.view addSubview:line];
    
    self.weixinButton=[[UIButton alloc]initWithFrame:CGRectMake(kButtonWidth-70, CGRectGetMaxY(self.retrieveButton.frame)+kGap_30, 80, 80)];
    [self.weixinButton setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [self.view addSubview:_weixinButton];
    UILabel *weixinLabel=[[UILabel alloc]initWithFrame:CGRectMake(kButtonWidth-70, CGRectGetMaxY(self.weixinButton.frame), 80, 15)];
    weixinLabel.text=@"微信登录";
    weixinLabel.font=[UIFont systemFontOfSize:12];
    weixinLabel.textAlignment=NSTextAlignmentCenter;
    weixinLabel.textColor=[UIColor grayColor];
    [self.view addSubview:weixinLabel];
    
    self.qqButton=[[UIButton alloc]initWithFrame:CGRectMake(kButtonWidth*2-40, CGRectGetMaxY(self.retrieveButton.frame)+kGap_30, 80, 80)];
    [self.qqButton setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    [self.view addSubview:_qqButton];
    
    UILabel *qqLabel=[[UILabel alloc]initWithFrame:CGRectMake(kButtonWidth*2-40, CGRectGetMaxY(self.qqButton.frame), 80, 15)];
    qqLabel.text=@"QQ登录";
    qqLabel.font=[UIFont systemFontOfSize:12];
    qqLabel.textAlignment=NSTextAlignmentCenter;
    qqLabel.textColor=[UIColor grayColor];
    [self.view addSubview:qqLabel];
    
    self.weiboButton=[[UIButton alloc]initWithFrame:CGRectMake(kButtonWidth*3-10, CGRectGetMaxY(self.retrieveButton.frame)+kGap_30, 80, 80)];
    [self.weiboButton setImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
    [self.weiboButton addTarget:self action:@selector(weiboClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_weiboButton];
    UILabel *weiboLabel=[[UILabel alloc]initWithFrame:CGRectMake(kButtonWidth*3-10, CGRectGetMaxY(self.weiboButton.frame), 80, 15)];
    weiboLabel.text=@"微博登录";
    weiboLabel.font=[UIFont systemFontOfSize:12];
    weiboLabel.textAlignment=NSTextAlignmentCenter;
    weiboLabel.textColor=[UIColor grayColor];
    [self.view addSubview:weiboLabel];
    
    
}

//注册事件
-(void)loginAction:(UIButton *)button
{
    WGHTestingViewController *loginVC = [WGHTestingViewController new];
    [self.navigationController pushViewController:loginVC animated:YES];
}
//登录事件
-(void)landingAction:(UIButton *)button
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.userNameField.text,@"username",self.codeTextField.text,@"password", nil];
    [[WGHLeanCloudTools sharedLeanUserTools] loginWithUsername:dic passVlueBlock:^(BOOL result) {
        
        if (result) {
            
            NSString * DocumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            DLog(@"%@",DocumentPath);
            NSString * dataBasePath = [DocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[[WGHLeanCloudTools sharedLeanUserTools] user]]];
            //单例方法
            DataBaseTool * db = [DataBaseTool shareDataBase];
            //打开
            [db connectDB:dataBasePath];
            //创建录音表
            [db execDDLSql:@"create table if not exists RecordList (\
             name text not null,\
             primary key (name)\
             )"];
            
            // 创建广播表
            [db createBroadcastHistoryList];
            
            //关闭
            [db disconnectDB];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
            UIAlertAction *defaultlAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[WGHLeanCloudTools sharedLeanUserTools] logOut];
                
            }];
            [alertController addAction:defaultlAction];
            
        }
        
    }];
    
}

//忘记密码事件
-(void)retrieveAction:(UIButton *)button
{
    // 跳转跟改密码界面
    WGHRetrieveViewController *retrieveVC=[WGHRetrieveViewController new];
    
    retrieveVC.number = 0;
    [self.navigationController pushViewController:retrieveVC animated:YES];
}

//弹窗
-(void)WarmTitl:(NSString*)string  Back:(NSString*)smge{
    UIAlertController *successdController = [UIAlertController alertControllerWithTitle:string message:smge preferredStyle:UIAlertControllerStyleAlert];
    // 设置弹窗上的按钮 ----  确认
    UIAlertAction *defultAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:nil];
    // 设置弹窗上的按钮 --- 返回
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
    // 把按钮添加到弹窗的控制器上
    [successdController addAction:defultAction];
    [successdController addAction:cancelAction];
    
    [self presentViewController:successdController animated:YES completion:nil];
}




- (void)weiboClick:(UIButton *)sender{
    
    //授权登陆
    UMSocialSnsPlatform * snsP = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsP.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity * response){
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity * snsA = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsA.userName,snsA.usid,snsA.accessToken,snsA.iconURL);
            [self setUserInfo:snsA.usid];
        }
    });
    
    
}


- (void)setUserInfo:(NSString *)usid
{
    //获取accestoken以及新浪用户信息，得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina completion:^(UMSocialResponseEntity *response) {
        NSLog(@"SnsInformation is %@",response.data);
        //设置头像信息
        
        //弹出提示
        
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:nil message:@"登陆成功"preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
        
        
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.userNameField) {
        [self.codeTextField becomeFirstResponder];
    }else if (textField == self.codeTextField) {
        [self.codeTextField resignFirstResponder];
    }
    
    return YES;
}




//点击空白处,回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
