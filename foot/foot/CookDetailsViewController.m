//
//  CookDetailsViewController.m
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "CookDetailsViewController.h"
#import "NetworkRequestManager.h"
#import "MateriaModel.h"
#import "StepModel.h"
#import "FoodDetailsModel.h"
#import "UIImageView+WebCache.h"

#import "CollectAndTimeView.h"
#import "MateriaView.h"
#import "StepView.h"
#import "TipView.h"

#import "CollectModel.h"
#import "DataBaseUtil.h"

#import "UploadView.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define Color(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]
@interface CookDetailsViewController ()<UIScrollViewDelegate>

{
    float _height;   //控件的y
    float _navScaleHeight;
}

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *topImageView; //顶部图片
@property(nonatomic,strong)UILabel *nameLabel; //菜名label
@property(nonatomic,strong)CollectAndTimeView *collectView; //收藏,难度,时间 view
@property(nonatomic,strong)FoodDetailsModel *detailsModel;
@property(nonatomic,strong)UIButton *navCollectButton;

@property (nonatomic,strong)UploadView *uploadV;

@end

@implementation CookDetailsViewController

-(FoodDetailsModel *)detailsModel
{
    if (_detailsModel == nil) {
        _detailsModel = [[FoodDetailsModel alloc] init];
    }
    return _detailsModel;
}

-(UIImageView *)topImageView
{
    if (_topImageView == nil) {
        _topImageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:_topImageView];
    }
    return _topImageView;
}

-(UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.scrollView addSubview:_nameLabel];
    }
    return _nameLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    //设置nav左返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    _height = -64;
    
    [self createScrollView];
    
    if (self.urlId != 2) {
        [self loadData];
    }
    else
    {
        [self loadDataFromKMakeDoodMateria];
    }
    self.uploadV = [[UploadView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.uploadV];
}

#pragma -mark 创建底部scrollView
-(void)createScrollView
{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    
    self.topImageView.frame = CGRectMake(0, _height, SCREEN_W, SCREEN_W/1.5);
    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.topImageView.clipsToBounds = YES;
    
    _height += SCREEN_W/1.5;
    self.nameLabel.frame = CGRectMake(0, _height, SCREEN_W, 50);
    
    _navScaleHeight = _height + 50 -64;
    
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma -mark 加载数据
-(void)loadData
{
[NetworkRequestManager requestWithType:POST urlString:self.url parDic:self.parDic header:self.header finish:^(NSData *data) {
    
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    //判断数据来源
    if (self.urlId == 3 || self.urlId == 12) {
        NSArray *array = dictionary[@"list"];
        NSDictionary *dic = array[0];
        self.detailsModel.topImage = [NSString stringWithFormat:@"http://pic.ecook.cn/web/%@.jpg",dic[@"imageid"]];
        self.detailsModel.name = dic[@"name"];
        self.detailsModel.introduce = dic[@"description"];
        
        //食材
        NSMutableArray *materiaArray = [NSMutableArray array];
        for (NSDictionary *dict in dic[@"materialList"]) {
            MateriaModel *materia = [[MateriaModel alloc] init];
            materia.materia = dict[@"name"];
            materia.dosage = dict[@"dosage"];
            [materiaArray addObject:materia];
        }
        self.detailsModel.materiaArray = materiaArray;
        
        //烹饪步骤
        NSMutableArray *stepArray = [NSMutableArray array];
        for (NSDictionary *dict in dic[@"stepList"]) {
            StepModel *step = [[StepModel alloc] init];
            step.stepImage = [NSString stringWithFormat:@"http://pic.ecook.cn/web/%@.jpg",dict[@"imageid"]];
            NSNumber *num = dict[@"ordernum"];
            step.ordernum = [num integerValue];
            step.stepDetails = dict[@"details"];
            [stepArray addObject:step];
        }
        self.detailsModel.stepArray = stepArray;
        
        //小贴士
        NSMutableArray *tipArray =[NSMutableArray array];
        for (NSDictionary *dict in dic[@"tipList"]) {
            NSString *tip = dict[@"details"];
            [tipArray addObject:tip];
        }
        self.detailsModel.tipArray = tipArray;
    }
    
    if (self.urlId == 11 || self.urlId == 13) {
        
        NSDictionary *dic1 = dictionary[@"result"];
        NSDictionary *dic = dic1[@"recipe"];
        if ([dic[@"cook_difficulty"] length] > 0) {
            self.detailsModel.level = dic[@"cook_difficulty"];
        }
        if ([dic[@"cook_time"] length] > 0) {
            self.detailsModel.cookTime = dic[@"cook_time"];
        }
        self.detailsModel.name = dic[@"title"];
        self.detailsModel.topImage = dic[@"photo_path"];
        self.detailsModel.introduce = dic[@"cookstory"];
        
        //材料
        NSMutableArray *materaArray = [NSMutableArray array];
        for (NSDictionary *dict in dic[@"major"]) {
            
            MateriaModel *model = [[MateriaModel alloc] init];
            model.materia = dict[@"title"];
            model.dosage = dict[@"羊排"];
            [materaArray addObject:model];
            
        }
        self.detailsModel.materiaArray = materaArray;
        
        //步骤
        NSMutableArray *stepArray = [NSMutableArray array];
        for (NSDictionary *dict in dic[@"cookstep"]) {
            
            StepModel *step = [[StepModel alloc] init];
            step.stepImage = dict[@"image"];
            step.stepDetails = dict[@"content"];
            NSNumber *num = dict[@"position"];
            step.ordernum = [num integerValue];
            [stepArray addObject:step];
        }
        self.detailsModel.stepArray = stepArray;
        
        //小提示
        if ([dic[@"tips"] length] > 0) {
            self.detailsModel.tipArray = @[dic[@"tips"]];
        }
        
    }
    
    [self performSelectorOnMainThread:@selector(doMain) withObject:nil waitUntilDone:YES];
    
} error:^(NSError *error) {
    NSLog(@"%@",error);
}];

}

#pragma -mark 加载完数据返回主线程 更新UI
-(void)doMain
{
    [self.uploadV removeFromSuperview];
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:self.detailsModel.topImage]];
    
    self.nameLabel.text = self.detailsModel.name;
    
    _height += 50;
    
    UIImage *collectImage;
    CollectModel *oneCollect = [[DataBaseUtil shareDataBase] selectCollectWithFoodName:self.detailsModel.name urlId:[NSString stringWithFormat:@"%ld",self.urlId]];
    if ([oneCollect.foodName isEqualToString:self.detailsModel.name] && [oneCollect.urlId isEqualToString:[NSString stringWithFormat:@"%ld",self.urlId]]) {
        
        collectImage = [UIImage imageNamed:@"收藏"];
    }
    else
    {
        collectImage = [UIImage imageNamed:@"未收藏"];
    }
    
    self.collectView = [[CollectAndTimeView alloc] initWithFrame:CGRectMake(0, _height, SCREEN_W, 35) level:self.detailsModel.level collectIcom:collectImage time:self.detailsModel.cookTime];
    
    [self.collectView.collectButton addTarget:self action:@selector(touchCollectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.collectView];
    
    _height += 35;
    
    //过渡性
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _height + 3, SCREEN_W, 1)];
    [self.scrollView addSubview:lineView1];
    lineView1.backgroundColor = Color(230, 230, 230, 1);
    
    //描述
    if (self.detailsModel.introduce.length > 0) {
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _height + 10, SCREEN_W - 30, 0)];
        detailLabel.text = self.detailsModel.introduce;
        detailLabel.numberOfLines = 0;
        detailLabel.lineBreakMode = NSLineBreakByCharWrapping;
        CGSize size = [detailLabel sizeThatFits:CGSizeMake(detailLabel.frame.size.width, MAXFLOAT)];
        CGRect frame = detailLabel.frame;
        frame.size.height = size.height + 10;
        detailLabel.frame = frame;
        [self.scrollView addSubview:detailLabel];
        _height += frame.size.height + 10;
    }
    
    //过渡性
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _height + 3, SCREEN_W, 1)];
    [self.scrollView addSubview:lineView2];
    lineView2.backgroundColor = Color(230, 230, 230, 1);
    
    //食材
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(10, _height + 30 , 3, 20)];
    [self.scrollView addSubview:redView];
    redView.backgroundColor = Color(228, 53, 42, 1);
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(18, _height + 30, 80, 20)];
    label1.text = @"需要材料";
    label1.font = [UIFont boldSystemFontOfSize:17];
    [self.scrollView addSubview:label1];
    
    _height += 40 + 20;
 
    for (int i = 0; i<self.detailsModel.materiaArray.count; i++) {
        
        MateriaModel *model = self.detailsModel.materiaArray[i];
        
        MateriaView *materiaView = [[MateriaView alloc] initWithFrame:CGRectMake(0, _height, SCREEN_W, 30) materia:model.materia dosage:model.dosage];
        [self.scrollView addSubview:materiaView];
        
        _height += 30;
        if (i%2 == 0) {
            materiaView.backgroundColor = Color(230, 230, 230, 1);
        }
        
    }
   
    //过渡性
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, _height + 15, SCREEN_W, 1)];
    [self.scrollView addSubview:lineView3];
    lineView3.backgroundColor = Color(230, 230, 230, 1);
    
    
    //烹饪步骤
    UIView *redView1 = [[UIView alloc] initWithFrame:CGRectMake(10, _height + 30 , 3, 20)];
    [self.scrollView addSubview:redView1];
    redView1.backgroundColor = Color(228, 53, 42, 1);
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(18, _height + 30, 80, 20)];
    label2.text = @"烹饪步骤";
    label2.font = [UIFont boldSystemFontOfSize:17];
    [self.scrollView addSubview:label2];
    
    _height += 50 + 10;
    
    for (int i = 0; i < self.detailsModel.stepArray.count; i++) {
        
        StepModel *model = self.detailsModel.stepArray[i];
        StepView *stepView = [[StepView alloc] initWithFrame:CGRectMake(0, _height, SCREEN_W, 0) image:model.stepImage title:model.stepDetails ordernum:model.ordernum];
        [self.scrollView addSubview:stepView];
        
        _height += stepView.frame.size.height + 15;
        
    }
    
    //过渡性
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, _height + 10, SCREEN_W, 1)];
    [self.scrollView addSubview:lineView4];
    lineView4.backgroundColor = Color(230, 230, 230, 1);
    
    //小贴士
    UIView *redView2 = [[UIView alloc] initWithFrame:CGRectMake(10, _height + 30 , 3, 20)];
    [self.scrollView addSubview:redView2];
    redView2.backgroundColor = Color(228, 53, 42, 1);
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(18, _height + 30, 80, 20)];
    label3.text = @"小贴士";
    label3.font = [UIFont boldSystemFontOfSize:17];
    [self.scrollView addSubview:label3];
    
    _height += 50 +10;
    
    for (int i = 0; i<self.detailsModel.tipArray.count; i++) {
        
        TipView *tip = [[TipView alloc] initWithFrame:CGRectMake(0, _height, SCREEN_W, 0) tipTitle:self.detailsModel.tipArray[i]];
        [self.scrollView addSubview:tip];
        
        _height += tip.frame.size.height;
    }
    
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_W, _height + 10);
}


#pragma -mark  加载来自食材组合的数据
//食材
-(void)loadDataFromKMakeDoodMateria
{
    NSDictionary *parDic = [NSDictionary dictionaryWithObjectsAndKeys:@"DishesMaterial",@"methodName",self.foodId,@"dishes_id",@"4.40",@"version" ,nil];
    [NetworkRequestManager requestWithType:POST urlString:self.url parDic:parDic header:nil finish:^(NSData *data) {
        
        self.detailsModel.name = self.foodName;
        self.detailsModel.introduce = self.content;
        
        NSError *errer;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errer];
        NSMutableArray *materialArray = [NSMutableArray array];
        for (NSDictionary *dic in dictionary[@"data"][@"material"]) {
            
            MateriaModel *materia = [[MateriaModel alloc] init];
            materia.materia = dic[@"material_name"];
            materia.dosage = dic[@"material_weight"];
            [materialArray addObject:materia];
            
        }
        self.detailsModel.materiaArray = materialArray;
        
        [self performSelectorOnMainThread:@selector(loadCookStep) withObject:nil waitUntilDone:YES];
        
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//加载步骤
-(void)loadCookStep
{
     NSDictionary *parDic = [NSDictionary dictionaryWithObjectsAndKeys:@"DishesView",@"methodName",self.foodId,@"dishes_id",@"4.40",@"version" ,nil];
    [NetworkRequestManager requestWithType:POST urlString:self.url parDic:parDic header:nil finish:^(NSData *data) {
        
        NSError *errer;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errer];
        NSDictionary *dict = dictionary[@"data"];
        self.detailsModel.topImage = dict[@"image"];
        self.detailsModel.level = dict[@"hard_level"];
        self.detailsModel.cookTime = dict[@"cooking_time"];
        NSMutableArray *stepArray = [NSMutableArray array];
        for (NSDictionary *dic in dictionary[@"data"][@"step"]) {
            
            StepModel *step = [[StepModel alloc] init];
            step.stepDetails = dic[@"dishes_step_desc"];
            step.stepImage = dic[@"dishes_step_image"];
            step.ordernum = [dic[@"dishes_step_order"] integerValue];
            [stepArray addObject:step];
            
        }
        self.detailsModel.stepArray = stepArray;
        
        [self performSelectorOnMainThread:@selector(loadCookTip) withObject:nil waitUntilDone:YES];
        
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//加载小提示
-(void)loadCookTip
{
    NSDictionary *parDic = [NSDictionary dictionaryWithObjectsAndKeys:@"DishesCommensense",@"methodName",self.foodId,@"dishes_id",@"4.40",@"version" ,nil];
    [NetworkRequestManager requestWithType:POST urlString:self.url parDic:parDic header:nil finish:^(NSData *data) {
        
        NSError *errer;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errer];
        
        self.detailsModel.tipArray = @[dictionary[@"data"][@"production_direction"]];
        
        [self performSelectorOnMainThread:@selector(doMain) withObject:nil waitUntilDone:YES];
        
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma -mark  scrollView 滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < _navScaleHeight) {
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:scrollView.contentOffset.y / _navScaleHeight];
        self.navigationItem.title = @"";
        self.navCollectButton = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
        
        if (!self.navCollectButton) {
            
            UIImage *collectImage;
            CollectModel *oneCollect = [[DataBaseUtil shareDataBase] selectCollectWithFoodName:self.detailsModel.name urlId:[NSString stringWithFormat:@"%ld",self.urlId]];
            if ([oneCollect.foodName isEqualToString:self.detailsModel.name] && [oneCollect.urlId isEqualToString:[NSString stringWithFormat:@"%ld",self.urlId]]) {
                
                collectImage = [UIImage imageNamed:@"收藏"];
            }
            else
            {
                collectImage = [UIImage imageNamed:@"未收藏"];
            }
            
            self.navCollectButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.navCollectButton setImage:collectImage forState:UIControlStateNormal];
            _navCollectButton.frame = CGRectMake(0, 0, 25, 25);
            self.navigationItem.title = self.detailsModel.name;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navCollectButton];
            [self.navCollectButton addTarget:self action:@selector(touchCollectButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
    }
}

#pragma -mark  点击收藏
-(void)touchCollectButton:(UIButton *)button
{
    CollectModel *collect = [[CollectModel alloc] init];
    collect.topImage = self.detailsModel.topImage;
    collect.foodName = self.detailsModel.name;
    collect.content = self.detailsModel.introduce;
    collect.foodId = self.foodId;
    collect.url = self.url;
    collect.urlId = [NSString stringWithFormat:@"%ld",self.urlId];
    collect.header = self.header;
    collect.parDic = self.parDic;
    
    if (self.urlId == 2) {
        collect.materiaDic = [NSDictionary dictionaryWithObjectsAndKeys:@"DishesMaterial",@"methodName",self.foodId,@"dishes_id",@"4.40",@"version" ,nil];
        collect.stepDic = [NSDictionary dictionaryWithObjectsAndKeys:@"DishesView",@"methodName",self.foodId,@"dishes_id",@"4.40",@"version" ,nil];
        collect.tipDic = [NSDictionary dictionaryWithObjectsAndKeys:@"DishesCommensense",@"methodName",self.foodId,@"dishes_id",@"4.40",@"version" ,nil];
    }
    
    CollectModel *oneCollect = [[DataBaseUtil shareDataBase] selectCollectWithFoodName:collect.foodName urlId:collect.urlId];
    if ([oneCollect.foodName isEqualToString:collect.foodName] && [oneCollect.urlId isEqualToString:collect.urlId]) {
        [[DataBaseUtil shareDataBase] deleteCollectWithFoodName:collect.foodName urlId:collect.urlId];
        [self.collectView.collectButton setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
        [_navCollectButton setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
        
    }
    else
    {
        [[DataBaseUtil shareDataBase] insertCollectModel:collect];
        [self.collectView.collectButton setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
        [_navCollectButton setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
       
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
#pragma -mark   设置导航控制器透明

    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    self.navigationController.navigationBar.translucent = YES;
    
    if (self.urlId == 11 || self.urlId == 12) {
        self.tabBarController.hidesBottomBarWhenPushed = YES;
    }
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    self.navigationController.navigationBar.translucent = NO;
    
    if (self.urlId == 11 || self.urlId == 12) {
        self.tabBarController.hidesBottomBarWhenPushed = NO;
    }
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
