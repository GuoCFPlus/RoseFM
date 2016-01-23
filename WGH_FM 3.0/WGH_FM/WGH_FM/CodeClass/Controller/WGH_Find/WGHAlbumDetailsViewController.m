//
//  WGHAlbumDetailsViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/14.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHAlbumDetailsViewController.h"

@interface WGHAlbumDetailsViewController ()

@end

@implementation WGHAlbumDetailsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        
        
    }
    
    return self;
    
}



#define kTitleWidth kScreenWidth-120

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.900 green:0.900 blue:0.900 alpha:1.000];
    self.navigationItem.title = self.dictionary[@"title"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, kScreenHeight)];
    scrollView.backgroundColor = [UIColor colorWithRed:0.900 green:0.900 blue:0.900 alpha:1.000];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = NO;
    [self.view addSubview:scrollView];
    
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    [scrollView addSubview:view];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(kGap_20, kGap_20, 80, kGap_20)];
    label1.text = @"专辑名称 :";
    label1.textColor = [UIColor grayColor];
    [view addSubview:label1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+kGap_10, kGap_20, kTitleWidth-kGap_40, kGap_20)];
    titleLabel.text = self.dictionary[@"title"];
    [view addSubview:titleLabel];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(kGap_20, CGRectGetMaxY(label1.frame)+kGap_20, 70, kGap_20)];
    label2.text = @"创建人 :";
    label2.textColor = [UIColor grayColor];
    [view addSubview:label2];
    UILabel *nickname = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame)+kGap_10, CGRectGetMaxY(titleLabel.frame)+kGap_20, kTitleWidth-kGap_20, kGap_20)];
    nickname.text = self.dictionary[@"nickname"];
    [view addSubview:nickname];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(kGap_20, CGRectGetMaxY(label2.frame)+kGap_20, kGap_50, kGap_20)];
    label3.textColor = [UIColor grayColor];
    label3.text = @"标签 :";
    [view addSubview:label3];
    
    UILabel *tags = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label3.frame)+kGap_10, CGRectGetMaxY(nickname.frame)+kGap_20, kTitleWidth, kGap_20)];
    tags.text = self.dictionary[@"tags"];
    tags.numberOfLines = 0;
    CGRect rect1 = [tags.text boundingRectWithSize:CGSizeMake(kTitleWidth, 1500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    CGRect plotFram1 = tags.frame;
    plotFram1.size.height = rect1.size.height;
    tags.frame = plotFram1;
    [view addSubview:tags];
    
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(kGap_20, CGRectGetMaxY(tags.frame)+kGap_20, kGap_50, kGap_20)];
    label4.text = @"简介 :";
    label4.textColor = [UIColor grayColor];
    [view addSubview:label4];
    
    UILabel *intro = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label4.frame)+kGap_10, CGRectGetMaxY(tags.frame)+kGap_20, kTitleWidth, kGap_20)];
    intro.text = self.dictionary[@"intro"];
    intro.numberOfLines = 0;
    CGRect rect2 = [intro.text boundingRectWithSize:CGSizeMake(kTitleWidth, 1500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    CGRect plotFram2 = intro.frame;
    plotFram2.size.height = rect2.size.height;
    intro.frame = plotFram2;
    [view addSubview:intro];
    
    scrollView.contentSize =CGSizeMake(kScreenWidth-kGap_20, CGRectGetMaxY(intro.frame)+120);
    
    view.frame = CGRectMake(kGap_10, kGap_20, kScreenWidth-kGap_20, CGRectGetMaxY(intro.frame)+kGap_20);
    
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
