//
//  MakeUpListViewController.m
//  foot
//
//  Created by lanou on 16/5/7.
//  Copyright © 2016年 念恩. All rights reserved.
//

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#import "MakeUpListViewController.h"
#import "MixResultCollectionViewCell.h"
#import "MixResultModel.h"
#import "UIImageView+WebCache.h"
#import "NetworkRequestManager.h"
#import "MJRefresh.h"
#import "CookDetailsViewController.h"

#import "UploadView.h"

@interface MakeUpListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)UICollectionView *MixListColl;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UploadView *uploadV;
@end

@implementation MakeUpListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"可做菜式";
    
    self.dataArray = [NSMutableArray array];
    
    [self getMixResult];
    [self createCollection];
    self.uploadV = [[UploadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    [self.view addSubview:self.uploadV];
    
    //设置nav左返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
}

-(void)createCollection
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 0, 20);
    layout.itemSize = CGSizeMake((SCREEN_W-50)/2,(SCREEN_W-50)/2*1.5 );
   
    self.MixListColl = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) collectionViewLayout:layout];

    self.MixListColl.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.MixListColl];
    self.MixListColl.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    self.MixListColl.dataSource = self;
    self.MixListColl.delegate = self;
    
    [self.MixListColl registerClass:[MixResultCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    if ([self.foodtotal intValue]>10) {
        [self.MixListColl addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefershing)];
    }
    
    
    
}

#pragma mark- collection的datasource和delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MixResultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    MixResultModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:model.image];
    [cell.imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"等待占位图"]];
    
    cell.labelText.text = model.title;
    cell.labelHard.text = model.hard_level;
    cell.labelTime.text = model.cooking_time;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CookDetailsViewController *cook = [[CookDetailsViewController alloc] init];
    MixResultModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    cook.url = @"http://api.izhangchu.com/";
    cook.urlId = 2;
    cook.content = model.content;
    cook.foodName = model.title;
    cook.foodId = model.dishes_id;
    
    
    [self.navigationController pushViewController:cook animated:YES];
}

#pragma mark- 请求页面数据

-(void)getMixResult
{
    NSMutableArray *arrayTemp = [NSMutableArray array];
    for (NSString *strId in self.dataArrayid) {
        [arrayTemp addObject:strId];
        
    }
    NSString *strRequest = [arrayTemp componentsJoinedByString:@"%2C"];
    strRequest = [strRequest stringByAppendingString:@"%2C"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"SearchMix",@"methodName",strRequest,@"material_ids",@"4.40",@"version", nil];
    [self requestData:dic];
}
-(void)requestData:(NSDictionary *)dic
{
    [NetworkRequestManager requestWithType:POST urlString:@"http://api.izhangchu.com/" parDic:dic header:nil finish:^(NSData *data) {
        
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSDictionary *dicData = [dict valueForKey:@"data"];
            NSArray *arrayData = [dicData valueForKey:@"data"];
        
            for (NSDictionary *dic in arrayData) {
                MixResultModel *model = [[MixResultModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.uploadV removeFromSuperview];
            [self.MixListColl reloadData];
           
        });
        
        
    } error:^(NSError *error) {
        
    }];
}

-(void)footerRefershing
{
    static int lastCount = 2;
    static int i = 1;

    
    NSMutableArray *arrayTemp = [NSMutableArray array];
    for (NSString *strId in self.dataArrayid) {
        [arrayTemp addObject:strId];
        
    }
    NSString *strRequest = [arrayTemp componentsJoinedByString:@"%2C"];
    strRequest = [strRequest stringByAppendingString:@"%2C"];
    NSString *strPage = [NSString stringWithFormat:@"%d",lastCount];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:strPage,@"page",@"SearchMix",@"methodName",strRequest,@"material_ids",@"4.40",@"version", nil];
    
    int k = [self.foodtotal intValue]/10;
    
    NSLog(@"%d",k);
    NSLog(@"--%d",[strPage intValue]);
    if ([strPage intValue]<=k+1) {
        [self requestData:dic];
    }
 
    i++;
    lastCount = i+1;
    
        [self.MixListColl reloadData];
        [self.MixListColl.footer endRefreshing];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

-(void)back
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

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
