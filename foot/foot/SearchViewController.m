

//
//  SearchViewController.m
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#import "SearchViewController.h"
#import "FireTableViewCell.h"
#import "DetailsSearchViewController.h"
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,FireTableViewCellDelegate>
@property (nonatomic,strong)UITextField *textF;
@property (nonatomic,strong)UITableView *tabSearch;
@property (nonatomic,strong)NSMutableArray *arrayHistory;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
    self.arrayHistory = [NSMutableArray array];
    UIImage *imageBack = [UIImage imageNamed:@"返回"];
    imageBack = [imageBack imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:imageBack style:UIBarButtonItemStylePlain target:self action:@selector(comeBackValue)];
    self.textF = [[UITextField alloc]initWithFrame:CGRectMake(0, 30,250, 30)];
    self.navigationItem.titleView = self.textF;
    self.textF.placeholder = @"输入菜谱名、食材名";
    self.textF.clearButtonMode = UITextFieldViewModeAlways;
    self.textF.backgroundColor = [UIColor grayColor];
    self.textF.layer.cornerRadius = 5;
    self.textF.layer.masksToBounds = YES;
    UIImage *imageSearch = [UIImage imageNamed:@"搜索"];
    imageSearch = [imageSearch imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:imageSearch style:UIBarButtonItemStylePlain target:self action:@selector(toucheSearch)];
    
#pragma mark UITableView
    self.tabSearch = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64) style:UITableViewStyleGrouped];
    self.tabSearch.delegate = self;
    self.tabSearch.dataSource = self;
    [self.view addSubview:self.tabSearch];
    
}
#pragma mark UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else
    return self.arrayHistory.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *identifier = @"cellFire";
        FireTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[FireTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate = self;
        }
        return cell;
    }else{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
        return cell;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.arrayHistory.count == 0) {
        return 1;
    }else
    return 2;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
    view.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 100, 20)];
    label.font = [UIFont systemFontOfSize:12];
    if (section == 0) {
        UIImage *image =[UIImage imageNamed:@"火"];
        imageView.image = image;
        label.text = @"热门搜索";
        
    }else{
        UIImage *image = [UIImage imageNamed:@"历史记录"];
        imageView.image = image;
        label.text = @"历史记录";
    }
    [view addSubview:imageView];
    [view addSubview:label];
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }else{
        return 30;
    }
}


#pragma mark 点击最热搜素里的方法
-(void)toucheBuutonWith:(UIButton *)but{
    
    self.textF.text = but.titleLabel.text;
    DetailsSearchViewController *details = [[DetailsSearchViewController alloc]init];
    details.searchContent = but.titleLabel.text;
    [self.navigationController pushViewController:details animated:YES];
    NSLog(@"%@",but.titleLabel.text);
}









#pragma mark-点击返回和搜素按钮的方法
-(void)comeBackValue{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)toucheSearch{
    if (self.textF.text.length == 0) {
        
    }else{
    DetailsSearchViewController *details = [[DetailsSearchViewController alloc]init];
    details.searchContent = self.textF.text;
    [self.navigationController pushViewController:details animated:YES];
    }
}
#pragma -mark  tabBar的隐藏和显示
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    self.textF.selected = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.textF endEditing:YES];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

@end
