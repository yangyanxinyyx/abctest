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


@interface MakeUpViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
//瀑布流列表
@property(nonatomic,strong)UICollectionView *mixFoodCollectionView;
//下方view
@property(nonatomic,strong)UIView *bottomView;
//右侧view
@property(nonatomic,strong)UIView *rightView;
//右侧点击按钮
@property(nonatomic,strong)UIButton *buRight;

//提示框
@property(nonatomic,strong)UILabel *labelPrompt;

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
    
    self.view.backgroundColor = [UIColor redColor];
    
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
    return 20;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MixFoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.labelName.text = @"qqqqq";
    return cell;
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
    self.buRight = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buRight.frame = CGRectMake(SCREEN_W-30, (self.mixFoodCollectionView.frame.size.height-80)/2, 30, 80);
    [self.buRight setImage:[UIImage imageNamed:@"后退"] forState:UIControlStateNormal];
    self.buRight.layer.borderWidth = 1;
    self.buRight.layer.borderColor = [UIColor grayColor].CGColor;
    [self.buRight addTarget:self action:@selector(touchRightBu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buRight];
    
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W, 0, SCREEN_W/2, SCREEN_H-64-49-80)];
    self.rightView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.rightView];
}

#pragma mark- 点击右侧按钮弹出选择栏
-(void)touchRightBu
{
    [self.buRight setImage:[UIImage imageNamed:@"前进"] forState:UIControlStateNormal];
    [UIView animateWithDuration:1 animations:^{
        self.rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W/2, 0, SCREEN_W/2, SCREEN_H-64-49-80)];
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
