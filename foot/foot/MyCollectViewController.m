//
//  MyCollectViewController.m
//  foot
//
//  Created by lanou on 16/5/9.
//  Copyright © 2016年 念恩. All rights reserved.
//

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#import "MyCollectViewController.h"
#import "MyCollectCollectionViewCell.h"
#import "DataBaseUtil.h"
#import "CollectModel.h"
#import "UIImageView+WebCache.h"

@interface MyCollectViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)UICollectionView *collectColl;
@property(nonatomic,strong)NSMutableArray *dataArrayColl;

@end

@implementation MyCollectViewController

-(NSMutableArray*)dataArrayColl
{
    if (_dataArrayColl == nil) {
        _dataArrayColl = [NSMutableArray array];
    }
    return _dataArrayColl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createColl];
    
    
    
    //设置nav左返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
}


-(void)createColl
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(SCREEN_W/2, SCREEN_W/2);
    
    self.collectColl = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) collectionViewLayout:layout];
    
    self.collectColl.showsVerticalScrollIndicator = NO;
    self.collectColl.dataSource = self;
    self.collectColl.delegate = self;
    
    [self.view addSubview:self.collectColl];
    
    self.collectColl.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    [self.collectColl registerClass:[MyCollectCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.dataArrayColl = [[DataBaseUtil shareDataBase] selectCollectModel];
    return self.dataArrayColl.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    CollectModel *model = [self.dataArrayColl objectAtIndex:indexPath.row];
    
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.topImage] placeholderImage:[UIImage imageNamed:@"等待占位图"]];
    
    
    cell.labelName.text = model.foodName;
    return cell;
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
