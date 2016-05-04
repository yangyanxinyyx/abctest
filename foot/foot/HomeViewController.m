
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


@interface HomeViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)CombinationView *combinationV;
@property (nonatomic,strong)UIPageControl *pageControl;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"首页";
    
    
#pragma mark 轮播图加page
    NSArray *idFoodArray = [NSArray arrayWithObjects:@"7136465",@"7136466",@"7136484",@"7136485",@"7136486", nil];
    NSArray *titleArray = [NSArray arrayWithObjects:@"早餐",@"午餐",@"下午茶",@"晚餐",@"宵夜", nil];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    for (int i = 0; i<5; i++) {
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(i*KScreenWidth, 0, KScreenWidth, 500)];
        CombinationView *combintionView = [[CombinationView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth-20,500)];
        combintionView.labelTitle.text = [titleArray objectAtIndex:i];
        [self getDataWith:idFoodArray[i] Combination:combintionView];
        [scroll addSubview:combintionView];
        scroll.delegate = self;
        [scrollView addSubview:scroll];
    }
    scrollView.contentSize = CGSizeMake(KScreenWidth*5, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 485, KScreenWidth, 10)];
    _pageControl.numberOfPages = 5;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self.view addSubview:_pageControl];
    
    
}

#pragma mark- 获取数据
-(void)getDataWith:(NSString *)idFood Combination:(CombinationView *)combinationView{
    NSMutableArray *dataArray = [NSMutableArray array];
    [NetworkRequestManager requestWithType:POST urlString:@"http://api.ecook.cn/public/getContentsBySubClassid.shtml" parDic:[NSDictionary dictionaryWithObjectsAndKeys:idFood,@"id",@"0",@"page", nil] header:[NSDictionary dictionaryWithObjectsAndKeys:@"application/x-www-form-urlencoded",@"Content-Type", nil] finish:^(NSData *data) {
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSArray *listArray = [dic objectForKey:@"list"];
        for (NSDictionary *dic1 in listArray) {
            HomeFootModel *hfModel = [[HomeFootModel alloc]init];
            [hfModel setValuesForKeysWithDictionary:dic1];
            [dataArray addObject:hfModel];
        }
#pragma mark 对三视图进行赋值
        HomeFootModel *hfm = [dataArray objectAtIndex:0];
        NSString *shapedImageURL = [NSString stringWithFormat:@"http://pic.ecook.cn/web/%@.jpg",hfm.imageid];
        [combinationView.shapedImageV sd_setImageWithURL:[NSURL URLWithString:shapedImageURL]];
        combinationView.shapedImageV.labelName.text = hfm.name;
        combinationView.shapedImageV.labelIntroduce.text = hfm.descriptionFood;
        
        HomeFootModel *hfmMid = [dataArray objectAtIndex:1];
        NSString *midImageURL = [NSString stringWithFormat:@"http://pic.ecook.cn/web/%@.jpg",hfmMid.imageid];
       [combinationView.midImageV sd_setImageWithURL:[NSURL URLWithString:midImageURL]];
        combinationView.midImageV.labelName.text = hfmMid.name;
        combinationView.midImageV.labelIntroduce.text = hfmMid.descriptionFood;
        
        HomeFootModel *hfmEnd = [dataArray objectAtIndex:2];
        NSString *endImageURL = [NSString stringWithFormat:@"http://pic.ecook.cn/web/%@.jpg",hfmEnd.imageid];
        [combinationView.endImageV sd_setImageWithURL:[NSURL URLWithString:endImageURL]];
        combinationView.endImageV.labelName.text = hfmEnd.name;
        combinationView.endImageV.labelIntroduce.text = hfmEnd.descriptionFood;
        [dataArray removeAllObjects];
    } error:^(NSError *error) {
        
    }];
    
}

#pragma mark scrollView 的代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger a = scrollView.contentOffset.x/KScreenWidth;
    _pageControl.currentPage = a;
    NSLog(@"%f",scrollView.contentOffset.x);
}

@end
