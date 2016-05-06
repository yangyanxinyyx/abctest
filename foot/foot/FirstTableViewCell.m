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

@interface FirstTableViewCell ()
@property (nonatomic,strong)UIScrollView *scrollViewImageViewS;
@end
@implementation FirstTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setLayout];
        //页面创建的时候对该时间进行判断是什么时候让它给我们推荐当前合适的选餐
        //获取系统时间
        NSDate *dateNow = [NSDate date];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"HH"];
        NSString *locationString = [dateformatter stringFromDate:dateNow];
        NSInteger currenHH = [locationString integerValue];
        if (currenHH>4 && currenHH <=9) {
            self.scrollViewImageViewS.contentOffset = CGPointMake(0, 0);
            self.pageControl.currentPage = 0;
        }else if (currenHH >9 && currenHH <=14){
            self.scrollViewImageViewS.contentOffset = CGPointMake(KScreenWidth, 0);
            self.pageControl.currentPage = 1;
        }else if (currenHH >14 && currenHH <=17){
            self.scrollViewImageViewS.contentOffset = CGPointMake(KScreenWidth*2, 0);
            self.pageControl.currentPage = 2;
        }else if (currenHH>17 && currenHH <20){
            self.scrollViewImageViewS.contentOffset = CGPointMake(KScreenWidth*3, 0);
            self.pageControl.currentPage = 3;
        }else{
            self.scrollViewImageViewS.contentOffset = CGPointMake(KScreenWidth*4, 0);
            self.pageControl.currentPage = 4;
        }
    }
    return self;
}
-(void)setLayout{
    
#pragma mark 轮播图加page
    CGFloat height = KScreenWidth/375*500;
    NSArray *idFoodArray = [NSArray arrayWithObjects:@"7136465",@"7136466",@"7136484",@"7136485",@"7136486", nil];
    NSArray *titleArray = [NSArray arrayWithObjects:@"早餐",@"午餐",@"下午茶",@"晚餐",@"宵夜", nil];
    _scrollViewImageViewS = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    for (int i = 0; i<5; i++) {
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(i*KScreenWidth, 0, KScreenWidth, height)];
        CombinationView *combintionView = [[CombinationView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth-20,height)];
        combintionView.labelTitle.text = [titleArray objectAtIndex:i];
        [self getDataWith:idFoodArray[i] Combination:combintionView];
        [scroll addSubview:combintionView];
        scroll.delegate = self;
        [_scrollViewImageViewS addSubview:scroll];
    }
    _scrollViewImageViewS.contentSize = CGSizeMake(KScreenWidth*5, 0);
    _scrollViewImageViewS.showsHorizontalScrollIndicator = NO;
    _scrollViewImageViewS.pagingEnabled = YES;
    _scrollViewImageViewS.bounces = NO;
    _scrollViewImageViewS.delegate = self;
    [self addSubview:_scrollViewImageViewS];
    
#pragma mark PageController
    self.pageControl = [[UIPageControl alloc]init];
    CGPoint point = self.center;
    self.pageControl.frame = CGRectMake(0, height-10, KScreenWidth, 10);
    self.pageControl.center = CGPointMake(point.x, height-10);
    
    _pageControl.numberOfPages = 5;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [_pageControl addTarget:self action:@selector(TouchePageControl:) forControlEvents:UIControlEventValueChanged];
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
        
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i<1000; i++) {
            int a = arc4random()%19;
            NSString *b = [NSString stringWithFormat:@"%d",a];
            if (![arr containsObject:b]) {
                [arr addObject:b];
                }
            if (arr.count>3) {
                break;
            }
        }
        HomeFootModel *hfm = [dataArray objectAtIndex:[arr[0] integerValue]];
        NSString *shapedImageURL = [NSString stringWithFormat:@"http://pic.ecook.cn/web/%@.jpg",hfm.imageid];
        [combinationView.shapedImageV sd_setImageWithURL:[NSURL URLWithString:shapedImageURL]];
        combinationView.shapedImageV.labelName.text = hfm.name;
        combinationView.shapedImageV.labelIntroduce.text = hfm.descriptionFood;
   
       
        
        HomeFootModel *hfmMid = [dataArray objectAtIndex:[arr[1] integerValue]];
        NSString *midImageURL = [NSString stringWithFormat:@"http://pic.ecook.cn/web/%@.jpg",hfmMid.imageid];
        [combinationView.midImageV sd_setImageWithURL:[NSURL URLWithString:midImageURL]];
        combinationView.midImageV.labelName.text = hfmMid.name;
        combinationView.midImageV.labelIntroduce.text = hfmMid.descriptionFood;
        
        HomeFootModel *hfmEnd = [dataArray objectAtIndex:[arr[2] integerValue]];
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
#pragma mark 点击pageControl的方法
-(void)TouchePageControl:(UIPageControl *)page{
    NSLog(@"%ld",page.currentPage);
    _scrollViewImageViewS.contentOffset = CGPointMake(page.currentPage*KScreenWidth, 0);
  
}
@end
