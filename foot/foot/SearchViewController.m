

//
//  SearchViewController.m
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define ColorBack     [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]

#import "SearchViewController.h"
#import "FireTableViewCell.h"
#import "DetailsSearchViewController.h"
#import "DataBaseUtil.h"
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,FireTableViewCellDelegate>
@property (nonatomic,strong)UITextField *textF;
@property (nonatomic,strong)UITableView *tabSearch;
@property (nonatomic,strong)NSArray *arrayHistory;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
    self.arrayHistory = [NSArray array];
    UIImage *imageBack = [UIImage imageNamed:@"返回"];
    imageBack = [imageBack imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:imageBack style:UIBarButtonItemStylePlain target:self action:@selector(comeBackValue)];
    self.textF = [[UITextField alloc]initWithFrame:CGRectMake(0, 30,250, 30)];
    self.navigationItem.titleView = self.textF;
    self.textF.placeholder = @"输入菜谱名、食材名";
    self.textF.clearButtonMode = UITextFieldViewModeAlways;
    self.textF.backgroundColor = ColorBack;
    self.textF.layer.cornerRadius = 5;
    self.textF.layer.masksToBounds = YES;
    UIImage *imageSearch = [UIImage imageNamed:@"搜索"];
    imageSearch = [imageSearch imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:imageSearch style:UIBarButtonItemStylePlain target:self action:@selector(toucheSearch)];
    
#pragma mark UITableView
    self.tabSearch = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64) style:UITableViewStyleGrouped];
    self.tabSearch.delegate = self;
    self.tabSearch.dataSource = self;
    self.tabSearch.bounces = NO;
    [self.view addSubview:self.tabSearch];
#pragma mark- 数据库操作
  self.arrayHistory = [[DataBaseUtil shareDataBase]selectModel];
    
}
#pragma mark UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1)
    return self.arrayHistory.count;
    else{
        return 0;
    }
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
        self.arrayHistory =[[DataBaseUtil shareDataBase] selectModel];
        HistoryModel *model = [self.arrayHistory objectAtIndex:( self.arrayHistory.count - indexPath.row -1)];
        cell.textLabel.text = model.content;
        return cell;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.arrayHistory.count == 0) {
        return 1;
    }else
    return 3;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
    view.backgroundColor = ColorBack;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, KScreenWidth-60, 20)];
    label.font = [UIFont systemFontOfSize:12];
    if (section == 0) {
        UIImage *image =[UIImage imageNamed:@"火"];
        imageView.image = image;
        label.text = @"热门搜索";
        
    }else if(section == 1){
        UIImage *image = [UIImage imageNamed:@"历史记录"];
        imageView.image = image;
        label.text = @"历史记录";
    }
    else{
        label.text = @"清空历史记录";
        label.textAlignment = NSTextAlignmentCenter;
        view.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toucheHistoryClean)];
        tapG.numberOfTouchesRequired = 1;
        tapG.numberOfTapsRequired = 1;
        [view addGestureRecognizer:tapG];
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
        return 40;
    }
}
#pragma mark -点击cell的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryModel *model = [self.arrayHistory objectAtIndex:( self.arrayHistory.count-indexPath.row -1)];
    self.textF.text = model.content;
    [self toucheSearch];
    
    
}

#pragma mark 点击最热搜素里的方法
-(void)toucheBuutonWith:(UIButton *)but{
    
    self.textF.text = but.titleLabel.text;
    DetailsSearchViewController *details = [[DetailsSearchViewController alloc]init];
    details.searchContent = but.titleLabel.text;
    [self.navigationController pushViewController:details animated:YES];
    //插入到数据库里
    HistoryModel *modele = [[HistoryModel alloc]init];
    modele.content = but.titleLabel.text;
    NSString *str = [[DataBaseUtil shareDataBase]selectModelWithContent:but.titleLabel.text].content;
    if (str.length == 0)
    {
        [[DataBaseUtil shareDataBase]insertModel:modele];
    }
    

}
#pragma mark 点击清空历史记录的方法
-(void)toucheHistoryClean{
    //删除数据库数据 然后刷新
    [[DataBaseUtil shareDataBase]deleteMode];
    self.arrayHistory = nil;
    [self.tabSearch reloadData];
}

#pragma mark-点击返回和搜素按钮的方法
-(void)comeBackValue{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)toucheSearch{
    if (self.textF.text.length == 0) {
        
    }else{
    DetailsSearchViewController *details = [[DetailsSearchViewController alloc]init];
    details.searchContent = self.textF.text;
    [self.navigationController pushViewController:details animated:YES];
        
    //插入到数据库里
    HistoryModel *modele = [[HistoryModel alloc]init];
    modele.content = self.textF.text;
    if ([[DataBaseUtil shareDataBase]selectModelWithContent:modele.content].content.length == 0)
    {
        [[DataBaseUtil shareDataBase]insertModel:modele];
    }

    }
}
#pragma -mark  tabBar的隐藏和显示
-(void)viewWillAppear:(BOOL)animated
{
    self.arrayHistory = [[DataBaseUtil shareDataBase]selectModel];
    [self.tabSearch reloadData];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    self.textF.selected = NO;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.textF endEditing:YES];
    
}

@end
