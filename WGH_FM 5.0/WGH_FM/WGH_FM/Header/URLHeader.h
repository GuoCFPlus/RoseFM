//
//  URLHeader.h
//  ProjectMusic
//
//  Created by young on 15/7/31.
//  Copyright (c) 2015年 young. All rights reserved.
//  这里是URL信息

#ifndef Project_URLHeader_h
#define Project_URLHeader_h

// ******发现界面******
// 小编推荐

// 轮播图
#define WGH_RecommendScrollURL @"http://mobile.ximalaya.com/mobile/discovery/v1/recommends?channel=ios-b1&device=iPhone&includeActivity=true&includeSpecial=true&scale=2&version=4.3.26"


#define WGH_EditorsrRecommendURL @"http://mobile.ximalaya.com/mobile/discovery/v1/recommend/editor?device=iPhone&pageId=%d&pageSize=20"  // 根据pageId  进行数据刷新

#define WGH_OneRecommendAlbumWithIDURL  @"http://mobile.ximalaya.com/mobile/others/ca/album/track/%d/true/%d/20?device=iPhone"   // 拼接id  pageId


// 分类
#define WGH_FenLeiURL @"http://mobile.ximalaya.com/mobile/discovery/v1/categories?device=iPhone&picVersion=11&scale=2"


#define WGH_OneItemTitleURL @"http://mobile.ximalaya.com/mobile/discovery/v1/category/tagsWithoutCover?categoryId=%d&contentType=album&device=iPhone"

// 具体某个分类 的推荐
#define WGH_OneItemURL @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=%d&contentType=album&device=iPhone&scale=2&version=4.3.26"   // 根据categoryId

// 具体某个类名下
#define WGH_OneTagNameURL @"http://mobile.ximalaya.com/mobile/discovery/v1/category/album?calcDimension=hot&categoryId=%d&device=iPhone&pageId=%d&pageSize=20&status=0&tagName=%@"  //拼接(tagName) 需要转码 在根据pageid 刷新数据

// 具体某个专辑
#define WGH_OneAlbumURL @"http://mobile.ximalaya.com/mobile/others/ca/album/track/%d/true/1/20?device=iPhone"  // 拼接 albumId

// ******广播界面******
//本地
#define WGH_LocalURL @"http://live.ximalaya.com/live-web/v1/getRadiosListByType?pageNum=%d&radioType=2&device=android&provinceCode=110000&pageSize=15"   // pageNum 刷新数据
//国家
#define WGH_CountryURL @"http://live.ximalaya.com/live-web/v1/getRadiosListByType?pageNum=%d&radioType=1&device=android&pageSize=15"   // pageNmu

//省市
#define WGH_ProvincesTitleURL @"http://live.ximalaya.com/live-web/v1/getProvinceList?device=iPhone"

#define WGH_OneProvincesURL @"http://live.ximalaya.com/live-web/v1/getRadiosListByType?device=iPhone&pageNum=%d&pageSize=30&provinceCode=%d&radioType=2"   // pageNum 数据刷新 //provinceCode  拼接省市code

//网络
#define WGH_NetworkURL @"http://live.ximalaya.com/live-web/v1/getRadiosListByType?pageNum=%d&radioType=3&device=android&pageSize=15"   //pageNum

//推荐电台
#define WGH_RecommendRadioURL @"http://live.ximalaya.com/live-web/v1/getHomePageRadiosList?device=iPhone"

#define WGH_RankingListURL @"http://live.ximalaya.com/live-web/v1/getTopRadiosList?device=iPhone&radioNum=100"


// ********榜单*******
#define WGH_HotListURL @"http://mobile.ximalaya.com/mobile/discovery/v2/rankingList/group?channel=ios-b1&device=iPhone&includeActivity=true&includeSpecial=true&scale=2&version=4.3.26"


#define WGH_OneHotListURL @"http://mobile.ximalaya.com/mobile/discovery/v1/rankingList/%@?device=iPhone&key=%@&pageId=%d&pageSize=20"   // key  转码

#define WGH_OneHotAnchorURL @"http://mobile.ximalaya.com/mobile/others/ca/album/%d/%d/30?device=iPhone"  // 拼接uid 和 pageID



#endif
