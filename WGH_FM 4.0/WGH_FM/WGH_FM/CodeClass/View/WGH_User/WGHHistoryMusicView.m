//
//  WGHHistoryMusicView.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/22.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHHistoryMusicView.h"

@interface WGHHistoryMusicView ()<UITableViewDataSource,UITableViewDelegate>


@property(strong,nonatomic)NSMutableArray *dataArray;

@property(strong,nonatomic)UITableView *myTableView;

@property(strong,nonatomic)UIButton *deledeBtn;

@end

@implementation WGHHistoryMusicView

static WGHHistoryMusicView *HM = nil;
+ (instancetype)shareShowHistoryMusictView:(CGRect)fram {
    if (HM == nil) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            HM = [[WGHHistoryMusicView alloc] initWithFrame:fram];

        });
        
    }
    return HM;
    
    
}


- (void)refreshTableView {
    
    [self dataReload];
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self wgh_setupViews];
        
    }
    return self;
}

- (void)wgh_setupViews {
    //加载数据
    self.backgroundColor = [UIColor whiteColor];

    [self dataReload];
    self.backgroundColor = [UIColor whiteColor];
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor clearColor];
    //隐藏滚动条
    self.myTableView.showsVerticalScrollIndicator = NO;
    //隐藏分割线
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.myTableView registerClass:[WGHShowAlbumListCell class] forCellReuseIdentifier:@"cell"];
    
    [self addSubview:self.myTableView];
    
}


- (void)dataReload {
    
    
    NSString * DocumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
     NSString * dataBasePath = [DocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[[WGHLeanCloudTools sharedLeanUserTools] user]]];
    //单例方法
    DataBaseTool * db = [DataBaseTool shareDataBase];
    //打开
    [db connectDB:dataBasePath];
    
    self.dataArray = [db selectAllMusicPlaye:@"1=1"];
    
    //关闭
    [db disconnectDB];
    
    [self.myTableView reloadData];
    
    
}

#pragma mark  ----tableView---

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.dataArray.count == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kGap_40)];
    
    view.backgroundColor = [UIColor colorWithRed:0.900 green:0.900 blue:0.900 alpha:1.000];
    
    self.deledeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.deledeBtn.tintColor = [UIColor orangeColor];
    [self.deledeBtn setTitle:@"❌ 清空历史" forState:UIControlStateNormal];
    self.deledeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    self.deledeBtn.frame = CGRectMake(0, 0, 200, kGap_30);
    
    self.deledeBtn.center = view.center;
    
    [self.deledeBtn addTarget:self action:@selector(deledeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:self.deledeBtn];
    
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return 0.0001;
    }
    return kGap_40;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.dataArray.count != 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64 - 45)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    label.centerX = kScreenWidth/2;
    label.centerY = view.frame.size.height/2 - 64;
    
    label.text = @"您还没有声音历史\n\n 尝试登录后再去听一听吧\n\n😊😊😊😊😊😊";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:label];
    
    return view;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.dataArray.count != 0) {
        return 0.00001;
    }
    return kScreenHeight-105;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WGHShowAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    WGHAlbumListModel *model = self.dataArray[indexPath.row];
    
    cell.albumModel = model;
    
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate changeAudioView:self.dataArray index:indexPath.row];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString * DocumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString * dataBasePath = [DocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[WGHLeanCloudTools sharedLeanUserTools].user]];
        //单例方法
        DataBaseTool * db = [DataBaseTool shareDataBase];
        //打开
        [db connectDB:dataBasePath];
        WGHAlbumListModel *model = self.dataArray[indexPath.row];
        [db execDDLSql:[NSString stringWithFormat:@"delete from MusicPlayerList where playPathAacv164 = '%@' ",model.playPathAacv164]];
        [self.dataArray removeObject:model];
        //关闭
        [db disconnectDB];
        
        [self refreshTableView];
    }
}

- (void)deledeBtnAction {
    
    NSString * DocumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString * dataBasePath = [DocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[WGHLeanCloudTools sharedLeanUserTools].user]];
    //单例方法
    DataBaseTool * db = [DataBaseTool shareDataBase];
    //打开
    [db connectDB:dataBasePath];
    
    
    for (WGHAlbumListModel *model in self.dataArray) {
        [db execDDLSql:[NSString stringWithFormat:@"delete from MusicPlayerList where playPathAacv164 = '%@' ",model.playPathAacv164]];
    }
    
    
    //关闭
    [db disconnectDB];
    
    [self refreshTableView];
    
    
}

@end
