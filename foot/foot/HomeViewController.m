
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
    
    [self getData];


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
        }
        return cell;
    
    }else{
    static NSString *identifier = @"cell";
    SelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        SelectionFoodModel *model = [_selectDataArray objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[SelectionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier withModel:model];
    }
        [cell.selectImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
        cell.labelName.text = model.name;
        cell.labelName.textAlignment = NSTextAlignmentRight;
        return cell;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return KScreenHeight-64-39;
    }else
    return 200;
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
-(void)getData{
    [NetworkRequestManager requestWithType:POST urlString:@"http://www.xdmeishi.com/index.php?m=mobile&c=index&a=getRecipeTheme&id=18&pageNum=1&pageSize=20" parDic:nil header:nil finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"result"]isEqualToString:@"ok"]) {
            NSArray *dataArray = [dic objectForKey:@"data"];
            for (NSDictionary *dic1 in dataArray) {
                SelectionFoodModel *selectionFM = [[SelectionFoodModel alloc]init];
                [selectionFM setValuesForKeysWithDictionary:dic1];
                [self.selectDataArray addObject:selectionFM];
            }

        }
            
        [self.tab reloadData];
  
       
    } error:^(NSError *error) {
        
    }];
}
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

@end
