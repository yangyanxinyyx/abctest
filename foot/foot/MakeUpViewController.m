//
//  MakeUpViewController.m
//  食材组合
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 yangyanxin. All rights reserved.
//

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#import "MakeUpViewController.h"
#import "MixFoodCollectionViewCell.h"
#import "NetworkRequestManager.h"
#import "MixKindModel.h"
#import "MixFoodModel.h"
#import "UIImageView+WebCache.h"
#import "MixFoodTableViewCell.h"

@interface MakeUpViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
//瀑布流列表
@property(nonatomic,strong)UICollectionView *mixFoodCollectionView;
//下方view
@property(nonatomic,strong)UIView *bottomView;
//右侧view
@property(nonatomic,strong)UIView *rightView;
//右侧点击按钮
@property(nonatomic,strong)UIButton *buRight;
//判断右侧是否弹出
@property(nonatomic,assign)BOOL isOpen;
//深色背景
@property(nonatomic,strong)UIView *viewBlack;
//右侧tableView
@property(nonatomic,strong)UITableView *tab;
//tableView的数据源数组
@property(nonatomic,strong)NSMutableArray *dataArrayTab;
//collectionView的数据源数组
@property(nonatomic,strong)NSMutableArray *dataArrayColl;


//提示框
@property(nonatomic,strong)UILabel *labelPrompt;
//选择的菜的数组
@property(nonatomic,strong)NSMutableArray *arraySelected;

@end

@implementation MakeUpViewController

-(UICollectionView*)mixFoodCollectionView
{
    if (!_mixFoodCollectionView) {
        
    }
    return _mixFoodCollectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"食材组合";
    
    self.view.backgroundColor = [UIColor redColor];
    self.dataArrayTab = [NSMutableArray array];
    self.dataArrayColl = [NSMutableArray array];
    self.arraySelected = [NSMutableArray array];
    
    [self requestData];
    [self setCollectionView];
    [self setBottomView];
    [self setRightView];
    
    
    
}


#pragma mark- 创建collectionView
-(void)setCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 0, 30);
    layout.itemSize = CGSizeMake((SCREEN_W-50-10*3)/3, (SCREEN_W-50-10*3)/3);
    
    
    self.mixFoodCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64-49-80) collectionViewLayout:layout];
    self.mixFoodCollectionView.backgroundColor = [UIColor whiteColor];
    self.mixFoodCollectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mixFoodCollectionView];
    
    self.mixFoodCollectionView.dataSource = self;
    self.mixFoodCollectionView.delegate = self;
    
    [self.mixFoodCollectionView registerClass:[MixFoodCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}

#pragma mark- collectionView DataSource Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArrayColl count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MixFoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    MixFoodModel *foodModel = [self.dataArrayColl objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:foodModel.image];
 
    [cell.imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"等待占位图"]];

    cell.labelName.text = foodModel.text;
    [cell.labelName sizeToFit];
    cell.labelName.center = [cell.subviews lastObject].center;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.labelPrompt removeFromSuperview];
    
    if (self.arraySelected.count<3) {
        MixFoodModel *foodModel = [self.dataArrayColl objectAtIndex:indexPath.row];
        [self.arraySelected addObject:foodModel];
        NSLog(@"%ld",self.arraySelected.count);
    }else
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_W-200)/2, self.bottomView.frame.origin.y-40, 200, 40)];
            [self.view addSubview:lab];
        lab.backgroundColor = [UIColor whiteColor];
        lab.textColor = [UIColor blackColor];
        [UIView animateWithDuration:5 animations:^{
            
            lab.backgroundColor = [UIColor blackColor];
            lab.text = @"最多只能选择3种食材哦~";
            lab.textColor = [UIColor whiteColor];
           
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    
    
    
    
    
}


#pragma mark- 设置下方view
-(void)setBottomView
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.mixFoodCollectionView.frame.size.height, SCREEN_W, 80)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.layer.borderWidth = 1;
    self.bottomView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:self.bottomView];
    
    
    self.labelPrompt = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 80)];
    self.labelPrompt.text = @"选择2个或3个食材\n爸爸告诉你可以做哪些菜";
    self.labelPrompt.textAlignment = NSTextAlignmentCenter;
    self.labelPrompt.numberOfLines = 0;
    [self.bottomView addSubview:self.labelPrompt];
}

#pragma mark- 设置右侧view
-(void)setRightView
{
    //右侧按钮
    self.buRight = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buRight.frame = CGRectMake(SCREEN_W-30, (self.mixFoodCollectionView.frame.size.height-80)/2, 35, 80);
    [self.buRight setImage:[UIImage imageNamed:@"后退"] forState:UIControlStateNormal];
    self.buRight.layer.cornerRadius = 5;
    self.buRight.layer.masksToBounds = YES;
    self.buRight.layer.borderWidth = 1;
    self.buRight.layer.borderColor = [UIColor grayColor].CGColor;
    [self.buRight addTarget:self action:@selector(touchRightBu) forControlEvents:UIControlEventTouchUpInside];
    self.buRight.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buRight];
    
    //右侧view
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W, 0, SCREEN_W/2, SCREEN_H-64-49-80)];
    self.rightView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.rightView];
    
    //右侧tableView
    
    self.tab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.rightView.frame.size.width, self.rightView.frame.size.height) style:UITableViewStylePlain];
    [self.rightView addSubview:self.tab];
    self.tab.delegate = self;
    self.tab.dataSource = self;
    self.tab.showsVerticalScrollIndicator = NO;
    
    self.isOpen = NO;
}

#pragma mark- 点击右侧按钮弹出选择栏
-(void)touchRightBu
{
    
    if (self.isOpen == NO) {
        
        //黑色阴影
        self.viewBlack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, self.mixFoodCollectionView.frame.size.height)];
        self.viewBlack.backgroundColor = [UIColor blackColor];
        self.viewBlack.alpha = 0.5;
        [self.view insertSubview:self.viewBlack aboveSubview:self.mixFoodCollectionView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBlackView)];
        self.viewBlack.userInteractionEnabled = YES;
        [self.viewBlack addGestureRecognizer:tap];
        
        //右侧弹出
        [self.buRight setImage:[UIImage imageNamed:@"前进"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.8 animations:^{
            self.buRight.frame = CGRectMake(SCREEN_W/2-30, (self.mixFoodCollectionView.frame.size.height-80)/2, 35, 80);
            
            self.rightView.frame = CGRectMake(SCREEN_W/2, 0, SCREEN_W/2, SCREEN_H-64-49-80);
        }];
    }else
    {
        [self.viewBlack removeFromSuperview];
        //右侧收回
        [self.buRight setImage:[UIImage imageNamed:@"后退"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.8 animations:^{
            self.buRight.frame = CGRectMake(SCREEN_W-30, (self.mixFoodCollectionView.frame.size.height-80)/2, 35, 80);
            
            self.rightView.frame = CGRectMake(SCREEN_W, 0, SCREEN_W/2, SCREEN_H-64-49-80);
        }];
    }
    
    self.isOpen = !self.isOpen;
}

#pragma mark 点击黑色背景
-(void)touchBlackView
{
    [self touchRightBu];
}

#pragma mark- tableView的dataSouse 和delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArrayTab count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    MixFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MixFoodTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    MixKindModel *kindModel = [self.dataArrayTab objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:kindModel.image];
    
    [cell.imageV sd_setImageWithURL:url];
    cell.labelText.text = kindModel.text;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataArrayColl removeAllObjects];
    MixKindModel *kindModel = [_dataArrayTab objectAtIndex:indexPath.row];
    NSArray *Array = kindModel.data;
    for (NSDictionary *dic in Array) {
        MixFoodModel *foodModel = [[MixFoodModel alloc] init];
        [foodModel setValuesForKeysWithDictionary:dic];
        [self.dataArrayColl addObject:foodModel];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mixFoodCollectionView reloadData];
    });
    [self touchRightBu];
    
}


#pragma mark- 数据请求
-(void)requestData
{
   [NetworkRequestManager requestWithType:POST urlString:@"http://api.izhangchu.com/" parDic:[NSDictionary dictionaryWithObjectsAndKeys:@"MaterialSubtype",@"methodName", nil] header:nil finish:^(NSData *data) {
       
       NSError *error = nil;
       
       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
       NSDictionary *dicData1 = [dic valueForKey:@"data"];
       NSArray *arrayData = [dicData1 valueForKey:@"data"];
       for (NSDictionary *dic in arrayData) {
           MixKindModel *model = [[MixKindModel alloc] init];
           [model setValuesForKeysWithDictionary:dic];
           [self.dataArrayTab addObject:model];
       }
       dispatch_async(dispatch_get_main_queue(), ^{
           [self.tab reloadData];
       });
       
       //页面开始先加载第一类的
       MixKindModel *kindModel = [_dataArrayTab objectAtIndex:0];
       NSArray *Array = kindModel.data;
       for (NSDictionary *dic in Array) {
           MixFoodModel *foodModel = [[MixFoodModel alloc] init];
           [foodModel setValuesForKeysWithDictionary:dic];
           [self.dataArrayColl addObject:foodModel];
       }
       dispatch_async(dispatch_get_main_queue(), ^{
           [self.mixFoodCollectionView reloadData];
       });
       
       
   } error:^(NSError *error) {
       
   }];
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
