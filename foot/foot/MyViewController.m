//
//  MyViewController.m
//  foot
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define ColorBack     [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]
#import "MyViewController.h"
#import "MyModel.h"
#import "ClauseView.h"
#import "MyCollectViewController.h"
#import "CarouselScrollView.h"
#import "NetworkRequestManager.h"
#import "SelectionFoodModel.h"

#import "SDImageCache.h"
#import "MyPoint.h"
#import "MyView_V2.h"
#import "ProblemView.h"
@interface MyViewController ()<ClauseViewDelegate,MyViewDelegate,ProblemViewDelegate>
{
    ClauseView *viewClause;
      ProblemView *viewProblem;
}
@property (nonatomic,strong)UITableView *tabMy;
@property (nonatomic,strong)NSMutableArray *arrayMySection;
@property (nonatomic,strong)NSArray *arrayNumber;
@property (nonatomic,strong)NSDictionary *dicData;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)NSMutableArray *arrayImages;
@property (nonatomic,strong)NSMutableArray *arrayPoint;
@property (nonatomic,strong)MyView_V2 *myViewV2;
@property (nonatomic)BOOL isRoat;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isRoat = NO;
    self.view.backgroundColor = ColorBack;
    self.navigationItem.title = @"我的";

#pragma mark- 测试
      //毛玻璃效果
    UIBlurEffect *effect  = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualeE =[[UIVisualEffectView alloc]initWithEffect:effect];
    visualeE.frame = self.view.bounds;
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    UIImage *image = [UIImage imageNamed:@"模糊背景图.jpg"];
    backImageView.image = image;
    backImageView.userInteractionEnabled = YES;
    [backImageView addSubview:visualeE];
    [self.view addSubview:backImageView];
    _myViewV2 = [[MyView_V2 alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49)];
    _myViewV2.delegate = self;
    [backImageView addSubview:_myViewV2];
    
    
}

#pragma mark- 轮播图
-(void)doMainThread{
    CarouselScrollView *carouseleS  = [[CarouselScrollView alloc]initWithImageArray:self.arrayImages];
    carouseleS.frame = CGRectMake(0, 0, KScreenWidth, 200);
    [self.view addSubview:carouseleS];
}


//点击返回button
-(void)toucheComeBackButton{
    [UIView animateWithDuration:0.5 animations:^{
        viewClause.frame = CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight);
    }];
}

//点击其他button
-(void)buttonVlaue:(UIButton *)Button{
    
    if (Button.tag == 1){
        self.buttonClean = Button;
//旋转动画
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        basicAnimation.duration = 0.5;
        basicAnimation.repeatDuration = 0.5;
        basicAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        basicAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
        [Button.layer addAnimation:basicAnimation forKey:@"transform.rotation"];
        
        [[SDImageCache sharedImageCache] clearDisk];
     float tmpSize = [[SDImageCache sharedImageCache]checkTmpSize];
        NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.1fM",tmpSize] : [NSString stringWithFormat:@"%.1fK",tmpSize * 1024];
        [Button setTitle:clearCacheName forState:UIControlStateNormal];
        
    }else if (Button.tag == 3){
        //旋转动画
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        basicAnimation.duration = 0.5;
        basicAnimation.repeatDuration = 1;
        basicAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        basicAnimation.toValue = [NSNumber numberWithFloat:-M_PI*2];
        [Button.layer addAnimation:basicAnimation forKey:@"transform.rotation"];
        [self toucheUpdata];

            }else if (Button.tag == 4){
        self.isRoat = YES;
        [UIView animateWithDuration:1 animations:^{
            self.myViewV2.outView.transform = CGAffineTransformRotate(self.myViewV2.outView.transform, M_PI);
        } completion:^(BOOL finished) {
            MyCollectViewController *myCollect = [[MyCollectViewController alloc]init];
            [self.navigationController pushViewController:myCollect animated:YES];
        }];

    }
}
//点击设置的button
-(void)buttonSetValue:(UIButton *)Butoon{
    if (Butoon.tag == 1) {
        viewClause = [[ClauseView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight)];

        [self.view addSubview:viewClause];
        viewClause.backgroundColor =[UIColor orangeColor];
        viewClause.delegate = self;
        [UIView animateWithDuration:0.5 animations:^{
            viewClause.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        }];
    }else if (Butoon.tag == 2){
    
        viewProblem = [[ProblemView alloc]initWithFrame:CGRectMake(0, -KScreenHeight, KScreenWidth, KScreenHeight)];
        [self.view addSubview:viewProblem];
        viewProblem.delegate = self;
        viewProblem.backgroundColor = [UIColor orangeColor];
        [UIView animateWithDuration:0.5 animations:^{
            viewProblem.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        }];
    
    }
}
//点击页面返回button
-(void)toucheProblemComeBackButton{
    [UIView animateWithDuration:0.5 animations:^{
        viewProblem.frame = CGRectMake(0, -KScreenHeight, KScreenWidth, KScreenHeight);
    }];

}
//页面出现
-(void)viewDidAppear:(BOOL)animated{
    if (_isRoat) {
        [UIView animateWithDuration:1 animations:^{
          self.myViewV2.outView.transform = CGAffineTransformRotate(self.myViewV2.outView.transform, M_PI);
        }];
        _isRoat = !_isRoat;
    }
    [self.myViewV2 doButtonValue:nil];
#pragma mark- 更新缓存的数据
    [[SDImageCache sharedImageCache] clearDisk];
    float tmpSize = [[SDImageCache sharedImageCache]checkTmpSize];
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.1fM",tmpSize] : [NSString stringWithFormat:@"%.1fK",tmpSize * 1024];
    [self.buttonClean setTitle:clearCacheName forState:UIControlStateNormal];

}
#pragma mark 点击更新延迟0.5弹出提示
-(void)toucheUpdata{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1.5);
        UIAlertController *alertC = [UIAlertController  alertControllerWithTitle:@"当前已是最新版本!!" message:@"版本为：1.0.1" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:action];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertC animated:YES completion:^{
                
            }];
        });
      
    });
    
    
        
  
}
@end
