//
//  FootTabBarController.m
//  foot
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "FoodTabBarController.h"
#import "FoodNavigationController.h"
#import "HomeViewController.h"
#import "MakeUpViewController.h"
#import "MenuViewController.h"
#import "MyViewController.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define Color(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]

@interface FoodTabBarController ()

@property(nonatomic,strong)UIView *tabBarView;
@property(nonatomic,strong)UIButton *selectButton;

@end

@implementation FoodTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationController];
    [self initCustomTabBar];
    
    [self.tabBar setTranslucent:NO];
    
    
    
}

#pragma -mark  添加根视图
-(void)initNavigationController
{
    HomeViewController *home = [[HomeViewController alloc] init];
    FoodNavigationController *homeNav = [[FoodNavigationController alloc] initWithRootViewController:home];
    
    MakeUpViewController *make = [[MakeUpViewController alloc] init];
    FoodNavigationController *makeNav = [[FoodNavigationController alloc] initWithRootViewController:make];
    
    MenuViewController *menu = [[MenuViewController alloc] init];
    FoodNavigationController *menuNav = [[FoodNavigationController alloc] initWithRootViewController:menu];
    
    MyViewController *my = [[MyViewController alloc] init];
    FoodNavigationController *myNav = [[FoodNavigationController alloc] initWithRootViewController:my];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    self.viewControllers = @[homeNav,makeNav,menuNav,myNav];
    
}

#pragma -mark  根据需要自定义tabbar视图
-(void)initCustomTabBar
{
    self.tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 49, SCREEN_W, 49)];
    self.tabBarView.backgroundColor = Color(255, 255, 255, 1);
    [self.view addSubview:self.tabBarView];
    
    NSArray *array = @[@"首页1",@"食材",@"食谱",@"我"];

    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((SCREEN_W / 4 - 30)/2 + (i*SCREEN_W/4), (49-30)/2, 30, 30);
        button.tag = i +1;
        [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarView addSubview:button];
        if (i == 0) {
            [self setSelectButton:button];
        }
    }
}

-(void)selectButton:(UIButton *)button
{
    NSArray *array = @[@"首页",@"食材",@"食谱",@"我"];
    NSArray *array1 = @[@"首页1",@"食材1",@"食谱1",@"我1"];
    
    [self.selectButton setImage:[UIImage imageNamed:array[self.selectButton.tag - 1]] forState:UIControlStateNormal];
    switch (button.tag) {
        case 1:
            [button setImage:[UIImage imageNamed:array1[0]] forState:UIControlStateNormal];
            break;
        case 2:
            [button setImage:[UIImage imageNamed:array1[1]] forState:UIControlStateNormal];
            break;
        case 3:
            [button setImage:[UIImage imageNamed:array1[2]] forState:UIControlStateNormal];
            break;
        case 4:
            [button setImage:[UIImage imageNamed:array1[3]] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    self.selectedViewController = self.viewControllers[button.tag - 1];
    _selectButton = button;

}

-(void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed{
    
    if (hidesBottomBarWhenPushed) {
        [self hideTabBar];
    }
    else
    {
        [self showTabBar];
    }
    
}

- (void)hideTabBar {
    

    [UIView animateWithDuration:0.2
                     animations:^{
                         CGRect tabFrame = _tabBarView.frame;
                         tabFrame.origin.x = 0 - tabFrame.size.width;
                         _tabBarView.frame = tabFrame;
                     }];

}

- (void)showTabBar {
  
    [UIView animateWithDuration:0.01
                     animations:^{
                         CGRect tabFrame = _tabBarView.frame;
                         tabFrame.origin.x = CGRectGetWidth(tabFrame) + CGRectGetMinX(tabFrame);
                         _tabBarView.frame = tabFrame;
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
