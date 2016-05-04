//
//  FirstTableViewCell.m
//  foot
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#import "FirstTableViewCell.h"
#import "CombinationView.h"
#import "NetworkRequestManager.h"
#import "HomeFootModel.h"
#import "UIImageView+WebCache.h"
@implementation FirstTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setLayout];
    }
    return self;
}
-(void)setLayout{
    
#pragma mark 轮播图加page
    CGFloat height = KScreenWidth/375*500;
    NSArray *idFoodArray = [NSArray arrayWithObjects:@"7136465",@"7136466",@"7136484",@"7136485",@"7136486", nil];
    NSArray *titleArray = [NSArray arrayWithObjects:@"早餐",@"午餐",@"下午茶",@"晚餐",@"宵夜", nil];
    UIScrollView *scrollViewImageViewS = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    for (int i = 0; i<5; i++) {
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(i*KScreenWidth, 0, KScreenWidth, height)];
        CombinationView *combintionView = [[CombinationView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth-20,height)];
        combintionView.labelTitle.text = [titleArray objectAtIndex:i];
        [self getDataWith:idFoodArray[i] Combination:combintionView];
        [scroll addSubview:combintionView];
        scroll.delegate = self;
        [scrollViewImageViewS addSubview:scroll];
    }
    scrollViewImageViewS.contentSize = CGSizeMake(KScreenWidth*5, 0);
    scrollViewImageViewS.showsHorizontalScrollIndicator = NO;
    scrollViewImageViewS.pagingEnabled = YES;
    scrollViewImageViewS.bounces = NO;
    scrollViewImageViewS.delegate = self;
    [self addSubview:scrollViewImageViewS];
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, height-10, KScreenWidth, 10)];
    _pageControl.numberOfPages = 5;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:_pageControl];
    
#pragma mark - 视屏推荐 和今日最新
    VideoBuutonAndNewestButton *vbnb = [[VideoBuutonAndNewestButton alloc]initWithFrame:CGRectMake(0, height, KScreenWidth, 80)];
    vbnb.delegate = self;
    [self addSubview:vbnb];
    

    
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
}
#pragma mark 代理方法;
-(void)toucheNewestButton{
    [self.delegate toucheNewestButtonOnCell];
}
-(void)toucheVideoButton{
    [self.delegate toucheVideoButtonOnCell];
}
@end
