//
//  MainScrollViewController.m
//  WGH_FM
//
//  Created by 吴凯强 on 16/1/13.
//  Copyright © 2016年 吴凯强. All rights reserved.
//

#import "MainScrollViewController.h"

@interface MainScrollViewController ()

@property(strong,nonatomic)NSTimer *timer;

@end

@implementation MainScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    
    for (int i = 1; i <= 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"APPscrollView%d",i]];
        [array addObject:image];
    }
    
    KQCarouselFigureView *carousel = [[KQCarouselFigureView alloc] initWithFrame:self.view.bounds];
    
    carousel.picturesAraay = array;
    
    
    [carousel.button addTarget:self action:@selector(changeFindMainAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:carousel];
    
    
    
}

- (void)changeFindMainAction {
    
    [self presentViewController:[WGHTabBarViewController new] animated:YES completion:nil];
    
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
