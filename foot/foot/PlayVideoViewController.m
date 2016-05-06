//
//  PlayVideoViewController.m
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
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
    
    self.view.backgroundColor = [UIColor grayColor];
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
    UIWebView *webv = [[UIWebView alloc]initWithFrame:CGRectMake(0, 100, KScreenWidth, 400)];
    [webv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strURL]]];
    [self.view addSubview:webv];
    NSLog(@"%@",strURL);
}
#pragma -mark  tabBar的隐藏和显示
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}


@end
