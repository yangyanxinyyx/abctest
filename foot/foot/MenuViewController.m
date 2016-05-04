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

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define Color(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]

@interface MenuViewController ()

@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createCollectionView];
    
}

#pragma -mark  创建collectionView
-(void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.itemSize = CGSizeMake((SCREEN_W - 50)/4, (SCREEN_W - 50)/4);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
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
