
//
//  HomeViewController.m
//  foot
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define ColorBack     [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]
#define ColorVray     [UIColor whiteColor]

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
#import "MJRefresh.h"
#import "SearchViewController.h"
#import "ImageManager.h"

#import "CookDetailsViewController.h"
#import "UploadView.h"

@interface HomeViewController ()<UIScrollViewDelegate,FirstTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSInteger flag;
}
@property (nonatomic,strong)CombinationView *combinationV;
@property (nonatomic,strong)UITableView *tab;
@property (nonatomic,strong)NSMutableArray *selectDataArray;
@property (nonatomic,strong)UploadView *uploadV;
@property (nonatomic,strong)UIBarButtonItem *rightBarButtonItem;
@property (nonatomic,strong)UIImageView *imageHeaderView;
@end

@implementation HomeViewController

- (void)viewDidLoad {


    [super viewDidLoad];
    

    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.title = @"首页";
    flag = 0;
    self.selectDataArray = [NSMutableArray array];
    UIImage *image = [UIImage imageNamed:@"背景.jpg"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image = image;
    

#pragma mark 搜素引擎
    UIButton *buttonSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonSearch.frame = CGRectMake(0, 30, 250, 30);
    buttonSearch.backgroundColor = ColorBack;
    [buttonSearch setTitle:@"🔍 搜素菜谱" forState:UIControlStateNormal];
    [buttonSearch setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    buttonSearch.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.navigationItem.titleView = buttonSearch;
    [buttonSearch addTarget:self action:@selector(touchButtonSearch) forControlEvents:UIControlEventTouchDown];
    buttonSearch.layer.cornerRadius =5;
    buttonSearch.layer.masksToBounds = YES;
    buttonSearch.layer.borderColor = [UIColor grayColor].CGColor;
    buttonSearch.layer.borderWidth = 1;
  

#pragma mark - UITableView;
    self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0,0, KScreenWidth, KScreenHeight-64-49) style:UITableViewStylePlain];
    self.tab.delegate = self;
    self.tab.dataSource = self;
    self.tab.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tab];
    [self getDataWith:@"0"];


#pragma mark -加载
    self.uploadV = [[UploadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49)];
    [self.view addSubview:self.uploadV];
#pragma mark- 却换模式
    UIImage *imageDay = [UIImage imageNamed:@"日间模式"];
    imageDay = [imageDay imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   self.rightBarButtonItem =[[UIBarButtonItem alloc]initWithImage:imageDay style:UIBarButtonItemStylePlain target:self action:@selector(exchangeModel)];
    self.navigationItem.rightBarButtonItem = _rightBarButtonItem;
  }

#pragma mark 懒加载
-(UIImageView *)imageHeaderView{
    if (!_imageHeaderView) {
        //加载
        _imageHeaderView = [[UIImageView alloc]initWithFrame:CGRectMake((KScreenWidth-40)/2, -40, 40, 40)];
        UIImage *imageHeader = [UIImage imageNamed:@"加载"];
        _imageHeaderView.image = imageHeader;
        [self.tab insertSubview:_imageHeaderView atIndex:0];
    }
    return _imageHeaderView;
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
            cell.backgroundColor = ColorVray;
        }
        return cell;
    
    }else{
    static NSString *identifier = @"cell";
    SelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        SelectionFoodModel *model = [_selectDataArray objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[SelectionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
        [cell.selectImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"等待占位图"]];
        cell.labelName.text = model.n;
        cell.labelBrowse.text = [NSString stringWithFormat:@"%@浏览",model.vc];
        cell.labelCollect.text = [NSString stringWithFormat:@"·  %@收藏",model.fc];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = ColorVray;
        return cell;
    }

}
#pragma 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  KScreenWidth/375*500+80;
    }else
    return 300;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
#pragma -mark 设置分区
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    view.backgroundColor = ColorVray;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *image = [UIImage imageNamed:@"花边.jpg"];
        imageView.image = image;
        [view addSubview:imageView];
        
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((KScreenWidth-100)/2, 10, 100, 20)];
    label.text = @"精     选";
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    [view addSubview:label];
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        view.layer.borderWidth = 1;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureValue)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [view addGestureRecognizer:tapGesture];
        
  
        return view;
    }
}
#pragma mark -分区的点击事件
-(void)tapGestureValue{
  
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tab scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(CGFloat )tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 0;
    }else
    return 40;
}
#pragma mark 获取tab数据 豆果数据
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
         
       
            [self performSelectorOnMainThread:@selector(doMainThread) withObject:nil waitUntilDone:YES];
     
        }
        else {
            NSLog(@"失败");
        }
       
    } error:^(NSError *error) {
        
    }];
}
#pragma mark 回主线程更新UI
-(void)doMainThread{
       [self.uploadV removeFromSuperview];
        [self.tab reloadData];
        [self.tab addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footRefreshing)];
}
#pragma firstCell的代理方法
#pragma mark- 点击视频和今日最新的按钮方法
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
-(void)toucheComtaionImageViewWith:(HomeFootModel *)model{
    CookDetailsViewController *cookD =[[CookDetailsViewController alloc]init];
    NSString *strUrl = @"http://api.ecook.cn/public/getRecipeListByIds.shtml";
    NSDictionary *dicPar = [NSDictionary dictionaryWithObjectsAndKeys:model.idFood,@"ids", nil];
    NSDictionary *dicHeader = [NSDictionary dictionaryWithObjectsAndKeys:@"Content-Type: application/x-www-form-urlencoded",@"header", nil];
    cookD.url = strUrl;
    cookD.urlId = 12;
    cookD.parDic = dicPar;
    cookD.header = dicHeader;
    [self.navigationController pushViewController:cookD animated:YES];
    NSLog(@"%@",model.name);
}
#pragma mark点击cell

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    }else{
        
        CookDetailsViewController *cookD = [[CookDetailsViewController alloc]init];
        SelectionFoodModel *model = [self.selectDataArray objectAtIndex:indexPath.row];
        NSString *urlStr = [NSString stringWithFormat:@"http://api.douguo.net/recipe/detail/%@",model.aid];
        NSDictionary *dicPar = [NSDictionary dictionaryWithObjectsAndKeys:@"4",@"client",@"0",@"author_id", nil];
        NSDictionary *dicHeader = [NSDictionary dictionaryWithObjectsAndKeys:@"application/x-www-form-urlencoded; charset=utf-8",@"Content-Type",@"611.2",@"version", nil];
        cookD.url = urlStr;
        cookD.parDic = dicPar;
        cookD.header = dicHeader;
        cookD.urlId = 11;
        [self.navigationController pushViewController:cookD animated:YES];
    
    }
}
#pragma mark 上拉加载
-(void)footRefreshing{
    flag ++;
    NSString *number = [NSString stringWithFormat:@"%ld",flag*20];
    [self getDataWith:number];
    [self.tab.footer endRefreshing];
}
#pragma mark uitextField的代理方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.view endEditing:YES];

}
#pragma mark- 点击搜索按钮的方法
-(void)touchButtonSearch{
    SearchViewController *searchVC  = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark scrollView的方法
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.tab.scrollEnabled = YES;
}
//scrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((KScreenWidth -250)/2, -40, 250, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:15];
    if (scrollView.contentOffset.y<0&&scrollView.contentOffset.y>-80) {
        self.imageHeaderView.hidden = YES;
        label.text = @"继续下拉则重新加载该页面!!";
        [self.tab addSubview:label];

    }else if (scrollView.contentOffset.y<-80&&scrollView.contentOffset.y>-120){
        label.hidden = YES;
        self.imageHeaderView.hidden = NO;
        self.imageHeaderView.transform = CGAffineTransformRotate(_imageHeaderView.transform, -M_PI_4*scrollView.contentOffset.y/100);
    }
    else if (scrollView.contentOffset.y <-120){
      
        [self.tab removeFromSuperview];
        [self viewDidLoad];
     
    }else{
        label.hidden =NO;
    }
}
//切换日间夜间模式
-(void)exchangeModel{
    static NSString *modelValue = @"day";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if ([modelValue isEqualToString:@"day"]) {
        UIImage *imageNight = [UIImage imageNamed:@"夜间模式"];
        imageNight = [imageNight imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _rightBarButtonItem.image = imageNight;
   
        modelValue = @"night";
    }else{
        UIImage *imageDay = [UIImage imageNamed:@"日间模式"];
        imageDay = [imageDay imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _rightBarButtonItem.image = imageDay;
 
        modelValue = @"day";
    }
    [user setValue:modelValue forKey:@"model"];

    //创建通知
    NSNotification *notification = [NSNotification notificationWithName:@"tongzhi" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:modelValue,@"model", nil]];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter]postNotification:notification];

    
   
}
@end
