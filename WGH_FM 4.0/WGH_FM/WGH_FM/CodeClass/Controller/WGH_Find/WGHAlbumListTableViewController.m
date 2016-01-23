//
//  WGHAlbumListTableViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/14.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "WGHAlbumListTableViewController.h"

@interface WGHAlbumListTableViewController ()

@property(strong,nonatomic)NSMutableArray *dataArray;
@property(strong,nonatomic)NSMutableDictionary *dataDict;
@property(assign,nonatomic)int pageId;

@end

static NSString *const ShowAlbumCellID = @"ShowAlbumCellID";
@implementation WGHAlbumListTableViewController

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
    
    self.dataDict = [NSMutableDictionary dictionary];
    
    self.navigationItem.title = self.showListModel.title;
    
    
    [self setupHeaderView];
    //self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.tableView registerClass:[WGHShowAlbumListCell class] forCellReuseIdentifier:ShowAlbumCellID];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.dataArray = [NSMutableArray array];
        self.pageId = 1;
        // 请求数据
        [self requestData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        self.pageId++;
        // 请求数据
        [self requestData];
    }];
}

#define kBckImgWidth kScreenWidth
#define kBckImgHeight kScreenWidth/3
#define kImgViewWidth 100
#define kImgViewHeight 100
#define kNicknameWidth kScreenWidth-kImgViewWidth-60-40
#define kIntroWidth kScreenWidth-kImgViewWidth-80

// 绘制header
- (void)setupHeaderView {
    
    //    "albumId": 3366901,
    //    "categoryId": 3,
    //    "categoryName": "有声书",
    //    "title": "风的预谋",
    //    "coverOrigin": "http://fdfs.xmcdn.com/group7/M01/D7/9D/wKgDWlZ-oIiR_V8PAAEt7RydP2c941.jpg",
    //    "coverSmall": "http://fdfs.xmcdn.com/group7/M01/D7/9D/wKgDWlZ-oIiR_V8PAAEt7RydP2c941_mobile_small.jpg",
    //    "coverMiddle": "http://fdfs.xmcdn.com/group7/M01/D7/9D/wKgDWlZ-oIiR_V8PAAEt7RydP2c941_mobile_meduim.jpg",
    //    "coverLarge": "http://fdfs.xmcdn.com/group7/M01/D7/9D/wKgDWlZ-oIiR_V8PAAEt7RydP2c941_mobile_large.jpg",
    //    "coverWebLarge": "http://fdfs.xmcdn.com/group7/M01/D7/9D/wKgDWlZ-oIiR_V8PAAEt7RydP2c941_web_large.jpg",
    //    "createdAt": 1450146951000,
    //    "updatedAt": 1452758038000,
    //    "uid": 10778196,
    //    "nickname": "头陀渊讲故事",
    //    "isVerified": true,
    //    "avatarPath": "http://fdfs.xmcdn.com/group15/M06/E3/40/wKgDaFaWEz-Aj_HPAAETcu7RTgk254_mobile_small.jpg",
    //    "zoneId": 133,
    //    "intro": "一首邓丽君的《甜蜜蜜》牵出一系列血腥的连环杀人案件，被害人均为接到报警后第一个赶到现场的警察，凶器则是一把不见踪影的弓箭。已经伏法的“萤火虫杀手”临终时留下遗言，以300万的代价委托逮捕他的刑警高竞为他寻找一个可能已经死去的神秘男人。与此同时，莫兰意外发现自己几年前参加的“真爱俱乐部”里，不断有人莫名其妙地死亡，是因为真爱俱乐部的“诅咒”应验了吗？随着高竞、莫兰13年的爱情长跑终于有了进展，两人渐渐发现所有这些案件中的细小关联。原来，邓丽君的歌词、奇怪的一元硬币、死者古怪的摆放姿势，这些凶手精心安排的离奇诡秘的凶杀现场，都只是在跟高竞玩一个游戏。“好多年前，我曾经见过你……”凶手在电话里阴沉沉地说。高竞想不起来了，但是他知道，凶手就在他身边。 【后期：娘口三三】 【旁白 高竞：头陀渊】 【莫兰：空无的念】 【乔纳 方凯灵 杜慧：月上重楼 】 【余男：有声的紫襟】 【梁永胜：小午】 【星光之箭 陈远哲：锦瑟】",
    //    "introRich": "<p> <span><strong><span>一首邓丽君的《</span><a target=\"_blank\" href=\"http://baike.baidu.com/view/298613.htm\">甜蜜蜜</a><span>》牵出一系列血腥的连环杀人案件，被害人均为接到报警后第一个赶到现场的警察，凶器则是一把不见踪影的弓箭。已经伏法的“萤火虫杀手”临终时留下遗言，以300万的代价委托逮捕他的刑警高竞为他寻找一个可能已经死去的神秘男人。与此同时，莫兰意外发现自己几年前参加的“真爱俱乐部”里，不断有人莫名其妙地死亡，是因为真爱俱乐部的“诅咒”应验了吗？随着高竞、莫兰13年的爱情长跑终于有了进展，两人渐渐发现所有这些案件中的细小关联。原来，邓丽君的歌词、奇怪的一元硬币、死者古怪的摆放姿势，这些凶手精心安排的离奇诡秘的凶杀现场，都只是在跟高竞玩一个游戏。“好多年前，我曾经见过你……”凶手在电话里阴沉沉地说。高竞想不起来了，但是他知道，凶手就在他身边。<br /> <span><strong>【</strong><strong></strong><strong>后期：娘口三三】</strong></span><span><strong>  【</strong></span><span><strong>旁白 高竞：</strong></span><span><strong>头陀渊】 【</strong></span><span><strong>莫兰：空无的念】</strong></span><span><strong> 【</strong></span><span><strong>乔纳 方凯灵 杜慧：月上重楼</strong></span><span><strong> 】 </strong></span><span><strong>  【</strong></span><span><strong>余男：有声的紫襟】</strong></span><span><strong>  【</strong></span><span><strong>梁永胜：小午】</strong></span><span><strong> 【</strong></span><span><strong>星光之箭 </strong></span><span><strong>陈远哲：锦瑟】</strong></span><span><strong>    <br /> </strong></span></span></strong></span> </p>",
    //    "tags": "言情,悬疑,推理,畅销书,都市",
    //    "tracks": 29,
    //    "shares": 0,
    //    "hasNew": false,
    //    "isFavorite": false,
    //    "playTimes": 294895,
    //    "status": 1,
    //    "serializeStatus": 1,
    //    "serialState": 1
    
    
    // header
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/5*2)];
    
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth/5*2)];
    [backImgView sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"coverOrigin"]]];
    [view addSubview:backImgView];
    
    //添加模糊背景
    //模糊背景
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = view.frame;
    [view addSubview:effectView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kGap_20, kScreenWidth/5*2/2-kGap_50, 100, 100)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"coverMiddle"]]];
    [view addSubview:imgView];
    
    UIImageView *avatarPath = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+kGap_20, CGRectGetMinY(imgView.frame), kGap_30, kGap_30)];
    avatarPath.layer.cornerRadius = 15;
    avatarPath.layer.masksToBounds = YES;
    [avatarPath sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"avatarPath"]]];
    [view addSubview:avatarPath];
    
    UILabel *nikNmae = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarPath.frame)+kGap_10, CGRectGetMinY(imgView.frame), kNicknameWidth, kGap_30)];
    nikNmae.text = self.dataDict[@"nickname"];
    [view addSubview:nikNmae];
    UILabel *intro = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+kGap_20, CGRectGetMaxY(avatarPath.frame)+kGap_10, kIntroWidth, kGap_30)];
    intro.text = self.dataDict[@"intro"];
    [view addSubview:intro];
    
    UILabel *tags = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+kGap_20, CGRectGetMaxY(intro.frame)+kGap_10, kIntroWidth, kGap_20)];
    tags.font = [UIFont systemFontOfSize:15];
    tags.text = self.dataDict[@"tags"];
    [view addSubview:tags];
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    rightView.center = CGPointMake(kScreenWidth-20, view.frame.size.height/2);
    rightView.image = [UIImage imageNamed:@"wgh_album_right"];
    [view addSubview:rightView];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
    [view addGestureRecognizer:singleTap];
    
    self.tableView.tableHeaderView = view;
}

// 请求数据  先判断当前是否有网络
- (void)requestData {
    
    [[WGHNetWorking shareAcquireNetworkState] acquireCurrentNetworkState:^(int result) {
        if (result != 0) {
            // 请求主数据
            [self requestMainData];
            
        }else {
            [[WGHNetWorking shareAcquireNetworkState] showPrompt];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
// 有网络状态下  解析数据
- (void)requestMainData {
    
    __weak typeof(self) weak = self;
    [[WGHRequestData shareRequestData] requestAlbumListDataWithURL:[NSString stringWithFormat:WGH_OneRecommendAlbumWithIDURL,[self.showListModel.albumId intValue],self.pageId] block:^(NSMutableArray *array, NSMutableDictionary *dictionary) {
        [self.dataArray addObjectsFromArray:array];
        [self.dataDict addEntriesFromDictionary:dictionary];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 回到主线程刷新
            [self setupHeaderView];
            [weak.tableView reloadData];
            [weak.tableView.mj_header endRefreshing];
            [weak.tableView.mj_footer endRefreshing];
        });
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WGHShowAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:ShowAlbumCellID forIndexPath:indexPath];
    
    WGHAlbumListModel *albumModel = self.dataArray[indexPath.row];
    
    cell.albumModel = albumModel;
    
    [cell.downButton addTarget:self action:@selector(downAudioPlayer) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WGHaudioPlayerViewController *audioPlayerVC = [WGHaudioPlayerViewController shareAudioPlayer];
    audioPlayerVC.dataArray = self.dataArray;
    audioPlayerVC.indext = indexPath.row;

    [self presentViewController:audioPlayerVC animated:YES completion:nil];
    
}



- (void)buttonpress:(UITapGestureRecognizer *)gestureRecognizer {
    
    WGHAlbumDetailsViewController *albumVC = [WGHAlbumDetailsViewController new];
    
    albumVC.dictionary = self.dataDict;
    
    [self.navigationController pushViewController:albumVC animated:YES];
}

- (void)downAudioPlayer {
    
    
    NSLog(@"下载");
    
    
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
