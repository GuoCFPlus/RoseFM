//
//  WGHTestingViewController.m
//  WGH_FM
//
//  Created by 韩明雨 on 16/1/19.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHTestingViewController.h"

@interface WGHTestingViewController ()<UITextFieldDelegate>
@property(strong,nonatomic)UITextField *userName;

@property(strong,nonatomic)UITextField *password;

@property(strong,nonatomic)UITextField *email;

@property(strong,nonatomic)UIButton *nextButton;


@end

@implementation WGHTestingViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.navigationItem.title = @"注册";
        
    }
    return self;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = 0;
    }
    
    
    self.userName = [[UITextField alloc]initWithFrame:CGRectMake(20, kGap_40, kScreenWidth-40, 30)];
    self.userName.layer.borderColor = [[UIColor grayColor]CGColor];
    self.userName.placeholder = @"请输入用户名:";
    self.userName.delegate = self;
    self.userName.layer.borderWidth = 0.7;
    self.userName.layer.cornerRadius = 5;
    self.userName.layer.masksToBounds = YES;
    [self.view addSubview:self.userName];
    
    
    
    self.password = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.userName.frame)+kGap_20, kScreenWidth-40, 30)];
    self.password.layer.borderColor = [[UIColor grayColor]CGColor];
    self.password.placeholder = @"请输入密码:";
    self.password.delegate = self;
    self.password.secureTextEntry = YES;
    self.password.layer.borderWidth = 0.7;
    self.password.layer.cornerRadius = 5;
    self.password.layer.masksToBounds = YES;
    [self.view addSubview:self.password];
    
    self.email = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.password.frame)+kGap_20, kScreenWidth-40, 30)];
    self.email.layer.borderColor = [[UIColor grayColor]CGColor];
    self.email.placeholder = @"请输入邮箱号:";
    self.email.delegate = self;
    self.email.layer.borderWidth = 0.7;
    self.email.layer.cornerRadius = 5;
    self.email.layer.masksToBounds = YES;
    [self.view addSubview:self.email];
    
    
    self.nextButton=[[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.email.frame)+kGap_20, kScreenWidth-40, 30)];
    [self.nextButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.nextButton setTintColor:[UIColor whiteColor]];
    self.nextButton.backgroundColor=[UIColor orangeColor];
    self.nextButton.layer.cornerRadius=5;
    self.nextButton.layer.masksToBounds=YES;
    [self.nextButton addTarget:self action:@selector(textingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
    
    // Do any additional setup after loading the view.
}

-(void)textingAction:(UIButton *)button {
    
    //    user.username = dict[@"username"];
    //    user.password =  dict[@"password"];
    //    user.email = dict[@"email"];
    //    user.mobilePhoneNumber = dict[@"mobilePhoneNumber"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.userName.text,@"username",self.password.text,@"password",self.email.text,@"email", nil];
    NSLog(@"%@",dic);
    if (self.userName.text.length != 0 && self.password.text.length != 0) {
        [[WGHLeanCloudTools sharedLeanUserTools] registWithDictionary:dic passVlueBlock:^(BOOL result) {
            
            if (result) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册失败" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertController animated:YES completion:nil];
                UIAlertAction *defaultlAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertController addAction:defaultlAction];
            }
        }];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.userName) {
        [self.password becomeFirstResponder];
    }else if (textField == self.password) {
        [self.email becomeFirstResponder];
    }else if (textField == self.email) {
        [self.email resignFirstResponder];
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
