//
//  NewestViewController.m
//  foot
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#import "NewestViewController.h"
#import "NetworkRequestManager.h"
#import "SelectionFoodModel.h"
#import "SelectionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "CookDetailsViewController.h"

@interface NewestViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger flag;
}
@property (nonatomic,strong)UITableView *newestTab;
@property (nonatomic,strong)NSMutableArray *newestArray;
@end

@implementation NewestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"今日最新";    
    //设置nav左返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    flag = 0;
    self.newestArray = [NSMutableArray array];
    self.newestTab = [[UITableView alloc]initWithFrame:CGRectMake(0,0, KScreenWidth, KScreenHeight-64+10) style:UITableViewStylePlain];
    self.newestTab.delegate = self;
    self.newestTab.dataSource = self;
    [self.view addSubview:self.newestTab];
    [self getDataWit:@"0"];
    [self.newestTab addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footRefreshing)];
    
}

#pragma mark 获取数据
-(void)getDataWit:(NSString *)pageIdD{
    NSString *url = [NSString stringWithFormat:@"http://api.douguo.net/recipe/simplerecipe/%@/20",pageIdD];
    
    [NetworkRequestManager requestWithType:POST urlString:url parDic:[NSDictionary dictionaryWithObjectsAndKeys:@"5",@"id",@"4",@"client", nil] header:[NSDictionary dictionaryWithObjectsAndKeys:@"611.2",@"version", nil] finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"state"] isEqualToString:@"success"]) {
            NSDictionary *dicResult = [dic objectForKey:@"result"];
            NSArray *arrayList = [dicResult objectForKey:@"list"];
            for (NSDictionary * dicList in arrayList ) {
                NSDictionary *dicR = [dicList objectForKey:@"r"];
                if (dicR) {
                    SelectionFoodModel *model = [[SelectionFoodModel alloc]init];
                    [model setValuesForKeysWithDictionary:dicR];
                    [self.newestArray addObject:model];
                }
                
            }
            [self performSelectorOnMainThread:@selector(doMainThread) withObject:nil waitUntilDone:nil ];
            
        }

        NSLog(@"%@",dic);
    } error:^(NSError *error) {
        
    }];
}
-(void)doMainThread{
    [self.newestTab reloadData];
}
#pragma mark uitableview的代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.newestArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    SelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    SelectionFoodModel *model = [_newestArray objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[SelectionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell.selectImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"等待占位图"] ];
    cell.labelName.text = model.n;
    cell.labelBrowse.text = [NSString stringWithFormat:@"%@浏览",model.vc];
    cell.labelCollect.text = [NSString stringWithFormat:@"·  %@收藏",model.fc];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectionFoodModel *model = [self.newestArray objectAtIndex:indexPath.row];
    CookDetailsViewController *cookD = [[CookDetailsViewController alloc]init];
    NSString *strUrl = [NSString stringWithFormat:@"http://api.douguo.net/recipe/detail/%@",model.aid];
    NSDictionary *dicPar = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"author_id",@"4",@"client", nil];
    NSDictionary *dicHeader = [NSDictionary dictionaryWithObjectsAndKeys:@"611.2",@"version", nil];
    cookD.url = strUrl;
    cookD.parDic = dicPar;
    cookD.header = dicHeader;
    cookD.urlId = 13;
    [self.navigationController pushViewController:cookD animated:YES];
    
}

#pragma mark 下拉刷新;
-(void)footRefreshing{
    flag ++;
    NSString *number = [NSString stringWithFormat:@"%ld",flag*10];
    [self getDataWit:number];
    [self.newestTab.footer endRefreshing];
    
}

-(void)back
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark  tabBar的隐藏和显示
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}



@end
