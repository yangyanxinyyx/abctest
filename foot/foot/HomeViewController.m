
//
//  HomeViewController.m
//  foot
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#import "HomeViewController.h"
#import "CombinationView.h"
#import "HomeFootModel.h"
#import "NetworkRequestManager.h"
#import "UIImageView+WebCache.h"
#import "VideoBuutonAndNewestButton.h"
#import "SelectionFoodModel.h"
#import "SelectionTableViewCell.h"
#import "FirstTableViewCell.h"
#import "NewestViewController.h"
#import "VideoViewController.h"
@interface HomeViewController ()<UIScrollViewDelegate,FirstTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)CombinationView *combinationV;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)UITableView *tab;
@property (nonatomic,strong)NSMutableArray *selectDataArray;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"首页";
    self.selectDataArray = [NSMutableArray array];
#pragma mark - 精选
    self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0,0, KScreenWidth, KScreenHeight-64-49) style:UITableViewStylePlain];
    self.tab.delegate = self;
    self.tab.dataSource = self;
    [self.view addSubview:self.tab];
    
    [self getDataWith:@"0"];


  }

#pragma mark UITableView 的代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    else
    return self.selectDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *identifier = @"cell1";
        FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[FirstTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    
    }else{
    static NSString *identifier = @"cell";
    SelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        SelectionFoodModel *model = [_selectDataArray objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[SelectionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
        [cell.selectImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        cell.labelName.text = model.n;
        cell.labelBrowse.text = [NSString stringWithFormat:@"%@浏览",model.vc];
        cell.labelCollect.text = [NSString stringWithFormat:@"·  %@收藏",model.fc];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  KScreenWidth/375*500+80;
    }else
    return 300;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((KScreenWidth-100)/2, 10, 100, 20)];
    label.text = @"精     选";
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    [view addSubview:label];
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        view.layer.borderWidth = 1;
        return view;
    }
}
-(CGFloat )tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 0;
    }else
    return 40;
}
#pragma mark 获取tab数据
-(void)getDataWith:(NSString *)pageId{
    NSString *url = [NSString stringWithFormat:@"http://api.douguo.net/recipe/home/%@/20",pageId];
    [NetworkRequestManager requestWithType:POST urlString:url parDic:[NSDictionary dictionaryWithObjectsAndKeys:@"4",@"client", nil] header:[NSDictionary dictionaryWithObjectsAndKeys:@"application/x-www-form-urlencoded; charset=utf-8",@"Content-Type",@"611.2",@"version", nil] finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"state"] isEqualToString:@"success"]) {
            NSDictionary *dicResult = [dic objectForKey:@"result"];
            NSArray *arrayList = [dicResult objectForKey:@"list"];
            for (NSDictionary * dicList in arrayList ) {
                NSDictionary *dicR = [dicList objectForKey:@"r"];
                if (dicR) {
                    SelectionFoodModel *model = [[SelectionFoodModel alloc]init];
                    [model setValuesForKeysWithDictionary:dicR];
                    [self.selectDataArray addObject:model];
                }

            }
            [self.tab reloadData];
        }
        else {
            NSLog(@"失败");
        }
       
    } error:^(NSError *error) {
        
    }];
}
#pragma firstCell的代理方法
-(void)toucheVideoButtonOnCell{
    VideoViewController *videoV = [[VideoViewController alloc]init];
    [self.navigationController pushViewController:videoV animated:YES];
    NSLog(@"点击视频");
}
-(void)toucheNewestButtonOnCell{
    NewestViewController *newestV = [[NewestViewController alloc]init];
    [self.navigationController pushViewController:newestV animated:YES];
    NSLog(@"点击今日");
}
#pragma mark点击cell

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    }else{
        
    }
}

@end
