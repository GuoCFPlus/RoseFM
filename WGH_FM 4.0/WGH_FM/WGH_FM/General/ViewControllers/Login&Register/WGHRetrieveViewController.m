//
//  WGHRetrieveViewController.m
//  WGH_FM
//
//  Created by 韩明雨 on 16/1/19.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHRetrieveViewController.h"

@interface WGHRetrieveViewController ()
@property(strong,nonatomic)UILabel *retrieveLabel;
@property(strong,nonatomic)UITextField *retrieveField;
@property(strong,nonatomic)UIButton *retrieveButton;
@end

@implementation WGHRetrieveViewController



#define  kLongWidth kScreenWidth-80

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.number == 0) {
        self.navigationItem.title=@"找回密码";
    }else {
        self.navigationItem.title=@"修改密码";
    }
    
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    // 控制scrollView的位置
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = 0;
    }
    
    
    self.retrieveLabel=[[UILabel alloc]initWithFrame:CGRectMake(kGap_40, kGap_50, kLongWidth, 30)];
    self.retrieveLabel.text=@"你的邮箱";
    self.retrieveLabel.textColor=[UIColor grayColor];
    [self.view addSubview:_retrieveLabel];
    
    
    self.retrieveField=[[UITextField alloc]initWithFrame:CGRectMake(kGap_40, CGRectGetMaxY(self.retrieveLabel.frame)+10, kLongWidth, 30)];
    self.retrieveField.placeholder=@" 请输入邮箱号:";
    self.retrieveField.layer.borderColor=[[UIColor grayColor]CGColor];
    self.retrieveField.layer.borderWidth=0.7;
    self.retrieveField.layer.cornerRadius=7;
    self.retrieveField.layer.masksToBounds=YES;
    [self.view addSubview:_retrieveField];
    
    self.retrieveButton=[[UIButton alloc]initWithFrame:CGRectMake(kGap_40, CGRectGetMaxY(self.retrieveField.frame)+kGap_30, kLongWidth, 30)];
    [self.retrieveButton setTitle:@"提交" forState:UIControlStateNormal];
    self.retrieveButton.backgroundColor=[UIColor orangeColor];
    [self.retrieveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.retrieveButton.layer.cornerRadius=7;
    self.retrieveButton.layer.masksToBounds=YES;
    [self.retrieveButton addTarget:self action:@selector(retrieveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_retrieveButton];
    
    
}

-(void)retrieveAction:(UIButton *)button
{
    
    [[WGHLeanCloudTools sharedLeanUserTools] resetPasswordWithEmail:self.retrieveField.text passVlueBlock:^(BOOL result) {
       
        if (result) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"发送邮件成功,请查收" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
            UIAlertAction *defaultlAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alertController addAction:defaultlAction];
        }else {
            DLog(@"发送失败");
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
