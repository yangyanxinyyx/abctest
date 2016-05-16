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
#import "CookDetailsViewController.h"

@interface MyCollectViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)UICollectionView *collectColl;
@property(nonatomic,strong)NSMutableArray *dataArrayColl;
@property(nonatomic,strong)UILongPressGestureRecognizer *longP;

@property(nonatomic,strong)UIView *viewBack;
@property(nonatomic,assign)CGFloat contentOffY;
@property(nonatomic,strong)UIImageView *imageVDlelte;
@property(nonatomic,strong)UIButton *buDelete;

@property(nonatomic,strong)CollectModel *deleteModel;
@property(nonatomic,strong)UIImageView *imageBack;
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
    self.navigationItem.title = @"我的收藏";
    [self createColl];
    
     self.dataArrayColl = [NSMutableArray array];
    
    NSArray *array = [[DataBaseUtil shareDataBase] selectCollectModel];
    if (array.count == 0) {
        self.imageBack = [[UIImageView alloc] init];
        self.imageBack.image = [UIImage imageNamed:@"让人收藏.jpg"];
        self.imageBack.frame = CGRectMake((SCREEN_W-195)/2, SCREEN_H/5, 210, 195);
        
        [self.view addSubview:self.imageBack];
    }
    
    
    //设置nav左返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    //设置nav右边删除全部按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除全部" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAll)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
}


-(void)createColl
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(SCREEN_W/2, SCREEN_W/2);
    
    self.collectColl = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64) collectionViewLayout:layout];
    
    self.collectColl.showsVerticalScrollIndicator = NO;
    self.collectColl.dataSource = self;
    self.collectColl.delegate = self;
    self.collectColl.bounces = NO;
    
    [self.view addSubview:self.collectColl];
    
    self.collectColl.backgroundColor = [UIColor whiteColor];
    
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
    
    self.longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [cell.imageV addGestureRecognizer:_longP];
    cell.imageV.userInteractionEnabled = YES;
    _longP.view.tag = indexPath.row+1;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CookDetailsViewController *cook = [[CookDetailsViewController alloc] init];
    
    CollectModel *model = [self.dataArrayColl objectAtIndex:indexPath.row];
    
    cook.url = model.url;
    cook.parDic = model.parDic;
    cook.header = model.header;
    cook.urlId = [model.urlId integerValue];
    cook.content = model.content;
    cook.foodName = model.foodName;
    cook.foodId = model.foodId;
    
    [self.navigationController pushViewController:cook animated:YES];
  
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.contentOffY = scrollView.contentOffset.y;
    NSLog(@"%f",scrollView.contentOffset.y);
}



-(void)longPress:(UILongPressGestureRecognizer*)longPress
{

    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        UIView *view = [[longPress.view superview] superview];
       
    
        CollectModel *model = [self.dataArrayColl objectAtIndex:longPress.view.tag-1];
        self.deleteModel = model;
       
        self.viewBack = [[UIView alloc] initWithFrame:self.view.bounds];
        self.viewBack.backgroundColor = [UIColor blackColor];
        self.viewBack.alpha = 0.6;
        self.viewBack.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
        [self.viewBack addGestureRecognizer:tap];
        [self.view addSubview:self.viewBack];
        
        if ((longPress.view.tag-1)%2 == 0) {
            self.imageVDlelte = [[UIImageView alloc] initWithFrame:CGRectMake(0,view.frame.origin.y-self.contentOffY, 0, 0)];
            [self.view addSubview:self.imageVDlelte];
            [self.imageVDlelte sd_setImageWithURL:[NSURL URLWithString:model.topImage]];
            self.imageVDlelte.contentMode = UIViewContentModeScaleAspectFill;
            self.imageVDlelte.clipsToBounds = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.imageVDlelte.frame = CGRectMake(SCREEN_W/4, (SCREEN_H-64)/4, SCREEN_W/2, SCREEN_W/2);
            } completion:^(BOOL finished) {
                self.buDelete = [UIButton buttonWithType:UIButtonTypeCustom];
                self.buDelete.frame = CGRectMake((SCREEN_W-SCREEN_W/8)/2, (SCREEN_H-64)/4+SCREEN_W/2, SCREEN_W/8, SCREEN_W/8);
                [self.buDelete addTarget:self action:@selector(deleteOne) forControlEvents:UIControlEventTouchUpInside];
                [self.buDelete setImage:[UIImage imageNamed:@"垃圾桶"] forState:UIControlStateNormal];
                [self.view addSubview:self.buDelete];
                self.buDelete.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
                
                self.buDelete.layer.cornerRadius = SCREEN_W/16;
                self.buDelete.layer.masksToBounds = YES;
                
            }];
            
        }else
        {
            self.imageVDlelte = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W,view.frame.origin.y-self.contentOffY, 0, 0)];
            [self.view addSubview:self.imageVDlelte];
            [self.imageVDlelte sd_setImageWithURL:[NSURL URLWithString:model.topImage]];
            self.imageVDlelte.contentMode = UIViewContentModeScaleAspectFill;
            self.imageVDlelte.clipsToBounds = YES;
            [UIView animateWithDuration:0.3 animations:^{
                self.imageVDlelte.frame = CGRectMake(SCREEN_W/4, (SCREEN_H-64)/4, SCREEN_W/2, SCREEN_W/2);
            } completion:^(BOOL finished) {
                self.buDelete = [UIButton buttonWithType:UIButtonTypeCustom];
                self.buDelete.frame = CGRectMake((SCREEN_W-SCREEN_W/8)/2, (SCREEN_H-64)/4+SCREEN_W/2, SCREEN_W/8, SCREEN_W/8);
                [self.buDelete addTarget:self action:@selector(deleteOne) forControlEvents:UIControlEventTouchUpInside];
                [self.buDelete setImage:[UIImage imageNamed:@"垃圾桶"] forState:UIControlStateNormal];
                [self.view addSubview:self.buDelete];
                self.buDelete.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
                
                self.buDelete.layer.cornerRadius = SCREEN_W/16;
                self.buDelete.layer.masksToBounds = YES;
            }];
        }
        
      
    }
}

-(void)cancel
{
    [self.viewBack removeFromSuperview];
    [self.imageVDlelte removeFromSuperview];
    [self.buDelete removeFromSuperview];
}

-(void)deleteOne
{

    
    [[DataBaseUtil shareDataBase] deleteCollectWithFoodName:self.deleteModel.foodName urlId:self.deleteModel.urlId];
    [self.collectColl reloadData];
    
    [self.viewBack removeFromSuperview];
    [self.imageVDlelte removeFromSuperview];
    [self.buDelete removeFromSuperview];
    
    NSArray *array = [[DataBaseUtil shareDataBase] selectCollectModel];
    if (array.count == 0) {
        self.imageBack = [[UIImageView alloc] init];
        self.imageBack.image = [UIImage imageNamed:@"让人收藏.jpg"];
        self.imageBack.frame = CGRectMake((SCREEN_W-195)/2, SCREEN_H/5, 210, 195);
        
        [self.view addSubview:self.imageBack];
    }
}

#pragma mark- 删除全部
-(void)deleteAll
{
    if (self.dataArrayColl.count>0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除全部记录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[DataBaseUtil shareDataBase] deleteCollectAll];
            [_collectColl reloadData];
            
            NSArray *array = [[DataBaseUtil shareDataBase] selectCollectModel];
            if (array.count == 0) {
                self.imageBack = [[UIImageView alloc] init];
                self.imageBack.image = [UIImage imageNamed:@"让人收藏.jpg"];
                self.imageBack.frame = CGRectMake((SCREEN_W-195)/2, SCREEN_H/5, 210, 195);
                
                [self.view addSubview:self.imageBack];
            }
            
        }];
        UIAlertAction *action2= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.collectColl reloadData];
    NSArray *array = [[DataBaseUtil shareDataBase] selectCollectModel];
    if (array.count == 0) {
        self.imageBack = [[UIImageView alloc] init];
        self.imageBack.image = [UIImage imageNamed:@"让人收藏.jpg"];
        self.imageBack.frame = CGRectMake((SCREEN_W-195)/2, SCREEN_H/5, 210, 195);
        
        [self.view addSubview:self.imageBack];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.imageBack removeFromSuperview];
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
