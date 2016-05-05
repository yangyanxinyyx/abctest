
//
//  VideoViewController.m
//  foot
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "VideoViewController.h"
#import "NetworkRequestManager.h"
#import "VideoModel.h"
#import "VideoTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface VideoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tabVideo;
@property (nonatomic,strong)NSMutableArray *arrayVideo;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.arrayVideo = [NSMutableArray array];
    self.tabVideo = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tabVideo.delegate = self;
    self.tabVideo.dataSource = self;
    [self.view addSubview:self.tabVideo];
    [self getDataWith:@"10"];
    
}
#pragma mark - UITableView的代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrayVideo.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell  = [[VideoTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    VideoModel *model = [self.arrayVideo objectAtIndex:indexPath.row];
    [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"等待占位图"]];
    cell.labelName.text = model.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}
#pragma  mark 获取数据
-(void)getDataWith:(NSString *)offsetNumber{
    [NetworkRequestManager requestWithType:POST urlString:@"http://m.douguo.com/video/ajaxshowlist" parDic:[NSDictionary dictionaryWithObjectsAndKeys:@"hot",@"type",offsetNumber,@"offset",@"10",@"limit", nil] header:[NSDictionary dictionaryWithObjectsAndKeys:@"application/x-www-form-urlencoded; charset=utf-8",@"Content-Type",@"611.2",@"version", nil] finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dicData = [dic objectForKey:@"data"];
        NSArray *arrayList = [dicData objectForKey:@"lists"];
        for (NSDictionary *dicList in arrayList) {
            VideoModel *model = [[VideoModel alloc]init];
            [model setValuesForKeysWithDictionary:dicList];
            [self.arrayVideo addObject:model];
        }
        [self performSelectorOnMainThread:@selector(doMainThread) withObject:nil waitUntilDone:nil];
       
    } error:^(NSError *error) {
        
    }];
}
-(void)doMainThread{
     [self.tabVideo reloadData];
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
