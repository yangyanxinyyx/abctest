//
//  MyProblemViewController.m
//  foot
//
//  Created by lanou on 16/5/6.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "MyProblemViewController.h"
#import "Tool.h"

@interface MyProblemViewController ()

@end

@implementation MyProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 200, 20)];
    labelTitle.text = @"常见问题";
    labelTitle.textColor = [UIColor blackColor];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelTitle];
    UILabel *labelConten = [[UILabel alloc]init];
    labelConten.textColor = [UIColor blackColor];
    labelConten.numberOfLines = 0;
    labelConten.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:labelConten];
    labelConten.text = @" <1>、该app由于本软件方向所决定,没有做横屏,所以该软件无法横屏操作.\n <2>、该app存储的个人数据均是本地,无法导出\n <3>、该app暂时没有提供第三方登陆 \n <4>、该app值允许微博分享 ";
    Tool *tool = [[Tool alloc]init];
    CGFloat height = [tool getLabelHeight:labelConten.text font:[UIFont systemFontOfSize:15]];
    labelConten.frame = CGRectMake(10, 60, self.view.frame.size.width-20, height);
}
#pragma -mark  tabBar的隐藏和显示
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}


@end
