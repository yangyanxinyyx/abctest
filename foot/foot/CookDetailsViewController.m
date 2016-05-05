//
//  CookDetailsViewController.m
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import "CookDetailsViewController.h"
#import "NetworkRequestManager.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
@interface CookDetailsViewController ()

{
    float _height;   //控件的y
}

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *topImageView; //顶部图片
@property(nonatomic,strong)UILabel *nameLabel; //菜名label

@end

@implementation CookDetailsViewController

-(UIImageView *)topImageView
{
    if (_topImageView == nil) {
        _topImageView = [[UIImageView alloc] init];
        //_topImageView.image = self.topImage;
        [self.scrollView addSubview:_topImageView];
    }
    return _topImageView;
}

-(UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.scrollView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _height = -64;
    
    [self createScrollView];
}

#pragma -mark 创建底部scrollView
-(void)createScrollView
{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.scrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.scrollView];
    
    self.topImageView.frame = CGRectMake(0, _height, SCREEN_W, SCREEN_W/1.5);
    
    
}

#pragma -mark 加载数据
-(void)loadData
{
[NetworkRequestManager requestWithType:POST urlString:self.url parDic:self.parDic header:self.header finish:^(NSData *data) {
    
    
    
} error:^(NSError *error) {
    NSLog(@"%@",error);
}];

}



-(void)viewWillAppear:(BOOL)animated
{
    
#pragma -mark   设置导航控制器透明

    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    self.navigationController.navigationBar.translucent = YES;
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    self.navigationController.navigationBar.translucent = NO;
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
