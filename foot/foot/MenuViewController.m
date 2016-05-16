//
//  MenuViewController.m
//  foot
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "MenuViewController.h"
#import "NetworkRequestManager.h"
#import "UIImageView+WebCache.h"
#import "MenuModel.h"
#import "MenuCollectionViewCell.h"
#import "MenuListViewController.h"
#import "UploadView.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define Color(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]

@interface MenuViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;  
@property (nonatomic,strong)UploadView *uploadV;
@end

@implementation MenuViewController

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"菜谱";

    [self createCollectionView];
    self.uploadV = [[UploadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64-49)];
    [self.view addSubview:self.uploadV];
    [self loadData];
}

#pragma -mark  创建collectionView
-(void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.itemSize = CGSizeMake((SCREEN_W - 50)/4, (SCREEN_W - 50)/4);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 49) collectionViewLayout:layout];
    self.collectionView.bounces = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    //加载cell
    [_collectionView registerClass:[MenuCollectionViewCell class] forCellWithReuseIdentifier:@"menu"];
    //加载头
    
}

#pragma -mark collectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = [self.dataArray[section] allValues].lastObject;
    return array.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menu" forIndexPath:indexPath];
    
    NSDictionary *dic = _dataArray[indexPath.section];
    NSArray *array = [dic allValues].lastObject;
    MenuModel *menu = array[indexPath.row];
    cell.nameLabel.text = menu.name;
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:menu.imageUrl]];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        for (UIView *view in header.subviews) {
            [view removeFromSuperview];
        }
        
        UIView *whiteView = [[UIView alloc] init];
        [header addSubview:whiteView];
        
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 3, 20)];
        [whiteView addSubview:redView];
        redView.backgroundColor = Color(228, 53, 42, 1);
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 5, 80, 20)];
        nameLabel.text = [self.dataArray[indexPath.section] allKeys].lastObject;
        
        [whiteView addSubview:nameLabel];
        nameLabel.textColor = [UIColor blackColor];
        
        if (indexPath.section == 0) {
            whiteView.frame = CGRectMake(0, 0, SCREEN_W, 30);
        }
        else
        {
            whiteView.frame = CGRectMake(0, 5, SCREEN_W, 30);
            UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 5)];
            grayView.backgroundColor = Color(230, 230, 230, 0.6);
            [header addSubview:grayView];
        }
        return header;
        
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(SCREEN_W, 30);
    }
    else
    {
        return CGSizeMake(SCREEN_W, 35);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [_dataArray[indexPath.section] allValues].lastObject;
    MenuModel *menu = array[indexPath.row];
    MenuListViewController *list = [[MenuListViewController alloc] init];
    list.identitfiy = menu.identify;
    list.navTitle = menu.name;
    [self.navigationController pushViewController:list animated:YES];
}


#pragma -mark  加载数据
-(void)loadData
{
[NetworkRequestManager requestWithType:POST urlString:@"http://api.ecook.cn/public/getRecipeHomeData.shtml" parDic:nil header:nil finish:^(NSData *data) {
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *array = dic[@"list"];
    for (NSDictionary *dict in array) {
        NSArray *arr = dict[@"list"];
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        NSMutableArray *array1 = [NSMutableArray array];
        for (NSDictionary *dictionary in arr) {
            if (![dictionary[@"name"] isEqualToString:@"视频菜谱"]) {
               
                MenuModel *menu = [[MenuModel alloc] init];
                menu.name = dictionary[@"name"];
                menu.identify = dictionary[@"id"];
                menu.imageUrl = [NSString stringWithFormat:@"http://pic.ecook.cn/web/%@.jpg",dictionary[@"imageid"]];
                [array1 addObject:menu];
            }
            
        }
        [dic1 setValue:array1 forKey:dict[@"name"]];
        if (![dict[@"name"] isEqualToString:@"视频专区"]) {
            [self.dataArray addObject:dic1];
        }
        
        
        //NSLog(@"%@",_dataArray);
    }
    
    [self performSelectorOnMainThread:@selector(doMain) withObject:nil waitUntilDone:YES];
    
} error:^(NSError *error) {
    NSLog(@"%@",error);
}];
}


-(void)doMain
{
    [self.uploadV removeFromSuperview];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView reloadData];
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
