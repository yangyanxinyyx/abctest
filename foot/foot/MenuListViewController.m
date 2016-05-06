//
//  MenuListViewController.m
//  foot
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "MenuListViewController.h"
#import "NetworkRequestManager.h"
#import "MenuListModel.h"
#import "MenuListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "CookDetailsViewController.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@interface MenuListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
    BOOL _isDownRefresh;  //是否下拉刷新
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray; //数据

@end

@implementation MenuListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    
    self.navigationItem.title = self.navTitle;
    
    _page = 0;
    _isDownRefresh = NO;
    [self loadData];
    
    [self createTableView];
    
    //设置nav左返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
}


#pragma -mark 创建tableview
-(void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //上拉加载
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
    [self.tableView.footer setTitle:@"上拉加载更多美食" forState:MJRefreshFooterStateRefreshing];
    
    //下拉刷新
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
    
}

#pragma -mark  上拉加载
-(void)refreshMore
{
    _page ++;
    [self loadData];
    [self.tableView.footer endRefreshing];
}

#pragma -mark 下拉加载
-(void)downRefresh
{
    _isDownRefresh = YES;
    _page = 0;
    [self loadData];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(refresh) userInfo:nil repeats:NO];
    self.tableView.userInteractionEnabled = NO ;
}

-(void)refresh
{
    self.tableView.userInteractionEnabled = YES ;
    [self.tableView.header endRefreshing];
}


#pragma -mark  tableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"listCell";
    MenuListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[MenuListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }
    MenuListModel *list = _dataArray[indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:list.imageUrl]];
    cell.nameLabel.text = list.name;
    cell.titleLabel.text = list.title;
    cell.collectLabel.text =[NSString stringWithFormat:@"收藏:  %@",list.collectCount];
    //cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CookDetailsViewController *cook = [[CookDetailsViewController alloc] init];
    MenuListModel *list = _dataArray[indexPath.row];
    cook.url = @"http://api.ecook.cn/public/getRecipeListByIds.shtml";
    cook.parDic = [NSDictionary dictionaryWithObjectsAndKeys:list.identifiy,@"ids", nil];
    cook.header = [NSDictionary dictionaryWithObjectsAndKeys:@"application/x-www-form-urlencoded",@"Content-Type", nil];
    cook.urlId = 3;
    [self.navigationController pushViewController:cook animated:YES];
}


-(void)back
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark 加载数据
-(void)loadData
{
    
    
    NSDictionary *parDic = [NSDictionary dictionaryWithObjectsAndKeys:_identitfiy,@"id",[NSString stringWithFormat:@"%ld",_page],@"page", nil];
    
    NSDictionary *header = [NSDictionary dictionaryWithObjectsAndKeys:@"application/x-www-form-urlencoded",@"Content-Type", nil];
    
    [NetworkRequestManager requestWithType:POST urlString:@"http://api.ecook.cn/public/getContentsBySubClassid.shtml" parDic:parDic header:header finish:^(NSData *data) {
        
        if (_isDownRefresh) {
            [self.dataArray removeAllObjects];
            _isDownRefresh = NO;
        }
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = dictionary[@"list"];
        for (NSDictionary *dic in array) {
            
            MenuListModel *model = [[MenuListModel alloc] init];
            model.title = dic[@"description"];
            model.imageUrl = [NSString stringWithFormat:@"http://pic.ecook.cn/web/%@.jpg",dic[@"imageid"]];
            model.identifiy = dic[@"id"];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        
        [self performSelectorOnMainThread:@selector(doMain) withObject:nil waitUntilDone:YES];
        
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)doMain
{
    
    [self.tableView reloadData];
}



-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    self.tabBarController.hidesBottomBarWhenPushed = NO;
//}

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
