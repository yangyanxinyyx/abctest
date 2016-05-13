//
//  PlayVideoViewController.m
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define ColorBack     [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]

#import "PlayVideoViewController.h"
#import "NetworkRequestManager.h"
@interface PlayVideoViewController ()
{
    NSString *strURL;
}
@end

@implementation PlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
#pragma mark- 自定义导航栏视图
    self.navigationController.navigationBarHidden = YES;
    UIView *navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, KScreenWidth, 44)];
    UIImage *image =[UIImage imageNamed:@"back"];
    UIButton *leftButtonImageV  =[UIButton buttonWithType:UIButtonTypeCustom];
    leftButtonImageV.frame = CGRectMake(5, 5, 44, 44);
    [navigationView addSubview:leftButtonImageV];
    [leftButtonImageV setImage:image forState:UIControlStateNormal];
    [leftButtonImageV addTarget:self action:@selector(toComeBack) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:navigationView];
    
    
    self.view.backgroundColor = ColorBack;
    NSString *str = [self.videoUrl substringToIndex:8];
    //判断数据给的网址是不是需要再次请求的
    if ([str containsString:@"recipes"]) {
         [self getDataWith:self.videoiID];
    }else{
        strURL = self.videoUrl;
        [self doMainThread];
    }
 
   
}
#pragma mark 获取数据
-(void)getDataWith:(NSString *)videID{
   
    NSString *str = [NSString stringWithFormat:@"http://api.douguo.net/recipe/detail/%@",videID];
    NSLog(@"%@",str);
    [NetworkRequestManager requestWithType:POST urlString:str parDic:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"author_id",@"4",@"client", nil] header:[NSDictionary dictionaryWithObjectsAndKeys:@"611.2",@"version", nil] finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dicResult = [dic objectForKey:@"result"];
        NSDictionary *dicRecipe = [dicResult objectForKey:@"recipe"];
       strURL = [dicRecipe objectForKey:@"vu"];
        [self performSelectorOnMainThread:@selector(doMainThread)withObject:nil waitUntilDone:NO];
    } error:^(NSError *error) {
        
    }];
   
}
-(void)doMainThread{
    UIWebView *webv = [[UIWebView alloc]initWithFrame:CGRectMake(0, 150, KScreenWidth, 300)];
    webv.scrollView.bounces = NO;
    webv.scrollView.scrollEnabled = NO;
    [webv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strURL]]];
    [self.view addSubview:webv];
    NSLog(@"%@",strURL);
}
#pragma -mark  tabBar的隐藏和显示
-(void)viewWillAppear:(BOOL)animated
{   self.navigationController.navigationBarHidden = YES;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{   self.navigationController.navigationBarHidden = NO;
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}
-(void)toComeBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
