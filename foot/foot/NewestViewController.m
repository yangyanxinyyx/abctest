//
//  NewestViewController.m
//  foot
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "NewestViewController.h"

@interface NewestViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *newestTab;
@end

@implementation NewestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.newestTab = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.newestTab.delegate = self;
    self.newestTab.dataSource = self;
    [self.view addSubview:self.newestTab];
    
}
#pragma mark uitableview的代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
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
