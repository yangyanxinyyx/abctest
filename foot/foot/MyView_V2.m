//
//  MyView_V2.m
//  foot
//
//  Created by lanou on 16/5/12.
//  Copyright © 2016年 念恩. All rights reserved.
//

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#import "MyView_V2.h"
#import "CarouselScrollView.h"
#import "NetworkRequestManager.h"
#import "SDImageCache.h"
@interface MyView_V2 ()
@property (nonatomic,strong)UIView *midView;
@property (nonatomic,strong)UIView *centerView;
@property (nonatomic)BOOL isOpen;
@property (nonatomic,strong)NSMutableArray *arrayRoating;
@property (nonatomic,strong)NSMutableArray *arrayImages;
@property (nonatomic)CGFloat outR;
@property (nonatomic)CGFloat midR;
@property (nonatomic)CGFloat centerR;
@property (nonatomic)CGFloat roatingR;
@property (nonatomic)CGFloat offsetH;
@property (nonatomic)CGFloat scale;
@end
@implementation MyView_V2
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.centerPoint = self.center;
        self.isOpen = NO;
        _outR = (CGFloat)350/375 *frame.size.width;
        _centerR =(CGFloat)180/375*frame.size.width;
        _roatingR = (CGFloat)75/375*frame.size.width;
        _midR =(_outR-_roatingR);
        _offsetH = (CGFloat)80/375*frame.size.width;
        _scale = frame.size.width/375;
        [self addSubview:self.midView];
        [self addSubview:self.outView];
        [self addSubview:self.centerView];
        [self getDataWith:@"10"];
    }
    return self;
}

-(void)getLayout{
    self.outView.center = self.centerPoint;
    self.midView.center = self.centerPoint;
    self.centerView.center = self.centerPoint;
}
//懒加载
-(UIView *)outView{
    if (!_outView) {
   
        self.outView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _outR, _outR)];
        _outView.center = self.centerPoint;
        _outView.layer.cornerRadius = _outR/2;
        _outView.layer.masksToBounds = YES;
        [self setRoatingViewWith:-0 WithImageName:@"清除缓存" tag:1];
        [self setRoatingViewWith:-60 WithImageName:@"设置" tag:2];
        [self setRoatingViewWith:-120 WithImageName:@"更新" tag:3];
        [self setRoatingViewWith:120 WithImageName:@"我的收藏" tag:4];
    }
    return _outView;
}
-(UIView *)centerView{
    if (!_centerView) {
       
        self.centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _centerR, _centerR)];
        _centerView.center = self.centerPoint;
        _centerView.layer.cornerRadius = _centerR/2;
        _centerView.layer.masksToBounds = YES;
        _centerView.layer.borderColor = [UIColor whiteColor].CGColor;
        _centerView.layer.borderWidth = 4;
        _centerView.tag = 2;
    }
    return _centerView;
}
-(UIView *)midView{
    if (!_midView) {
        
        _midView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _midR, _midR)];
        _midView.center = self.centerPoint;
        _midView.layer.cornerRadius = _midR/2;
        _midView.layer.masksToBounds = YES;
        _midView.layer.borderColor = [UIColor whiteColor].CGColor;
        _midView.layer.borderWidth = 2;
    }
    
    return _midView;
}
-(NSMutableArray *)arrayRoating{
    if (!_arrayRoating) {
        self.arrayRoating = [NSMutableArray array];
    }
    return _arrayRoating;
}
-(void)setRoatingViewWith:(NSInteger)angle WithImageName:(NSString *)imageName tag:(NSInteger)tag{
    CGFloat lenght = (_outR/2-_roatingR)+_roatingR/2;
    UIView *roundView = [[UIView alloc]initWithFrame:CGRectMake(0,0, _roatingR, _roatingR)];
     CGPoint point = CGPointMake(lenght*sin(M_PI/180*(60+angle))+_outR/2,lenght*cos(M_PI/180*(60+angle))+_outR/2);
    
    roundView.center = point;
    roundView.layer.cornerRadius = _roatingR/2;
    roundView.layer.masksToBounds = YES;
    roundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    roundView.layer.borderWidth = 2;
    roundView.backgroundColor = [UIColor whiteColor];
    roundView.tag = 1;
    [_outView addSubview:roundView];
    UIImage *image = [UIImage imageNamed:imageName];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, roundView.bounds.size.width-20, roundView.bounds.size.height-20);
    button.center = CGPointMake(_roatingR/2, _roatingR/2);
    button.tag = tag;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    if ([imageName isEqualToString:@"清除缓存"]) {
        button.frame = CGRectMake(0, 0, roundView.bounds.size.width-10, roundView.bounds.size.height-10);
        button.center = CGPointMake(_roatingR/2, _roatingR/2);
        float tmpSize = [[SDImageCache sharedImageCache]checkTmpSize];
        NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.fM",tmpSize] : [NSString stringWithFormat:@"%.fK",tmpSize * 1024];
        [button setTitle:clearCacheName forState:UIControlStateNormal];
    }else{
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:imageName forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.imageView.userInteractionEnabled = YES;
    [button addTarget:self action:@selector(doButtonValue:) forControlEvents:UIControlEventTouchUpInside];
    [roundView addSubview:button];

    
}
-(void)toucheToaddRoatingWithImageName:(NSString *)imageName withPoint:(CGPoint)point witholdPoint:(CGPoint)oldPoint tag:(NSInteger)tag{
    NSLog(@"%f",self.center.y);
    UIView *roundView = [[UIView alloc]initWithFrame:CGRectMake(oldPoint.x,oldPoint.y, _roatingR, _roatingR)];
    roundView.center = point;
    roundView.layer.cornerRadius = _roatingR/2;
    roundView.layer.masksToBounds = YES;
    roundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    roundView.layer.borderWidth = 2;
    roundView.backgroundColor = [UIColor whiteColor];
    roundView.tag = 1;
    [self addSubview:roundView];
    UIImage *image = [UIImage imageNamed:imageName];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.frame = CGRectMake(0, 0, roundView.bounds.size.width-20, roundView.bounds.size.height-20);
    button.center = CGPointMake(_roatingR/2, _roatingR/2);
    button.tag = tag;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:imageName forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.imageView.userInteractionEnabled = YES;
    [button addTarget:self action:@selector(doButtonValueSet:) forControlEvents:UIControlEventTouchUpInside];
    [roundView addSubview:button];
        [self.arrayRoating addObject:roundView];
    
}
-(void)doButtonValue:(UIButton*)but{
    if (!but) {
        if (self.centerPoint.y==self.center.y) {         
            
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                self.centerPoint =self.center;
                [self getLayout];
                UIView *view1 =[self.arrayRoating lastObject];
                [UIView animateWithDuration:0.3 animations:^{
                    view1.center = CGPointMake(self.center.x, self.center.y-_offsetH+_outR/2+50*_scale);
                } completion:^(BOOL finished) {
                    for (UIView *view in self.arrayRoating) {
                        [UIView animateWithDuration:0.3 animations:^{
                            [view removeFromSuperview];
                        }];
                        
                    }
                }];
                
                
            }];
        }

    }
#pragma MARK 不为空
    else{
    if (but.tag == 2) {
        if (self.centerPoint.y==self.center.y) {
            [UIView animateWithDuration:0.3 animations:^{
                self.centerPoint =CGPointMake(self.center.x, self.center.y-_offsetH);
                [self getLayout];
 
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint point = CGPointMake(self.center.x,self.center.y-_offsetH+_outR/2+50*_scale);
                    CGPoint oldPoint =CGPointMake(point.x-_roatingR/2,point.y-_offsetH);
                    [self toucheToaddRoatingWithImageName:@"条款" withPoint:point witholdPoint:oldPoint tag:1];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3 animations:^{
                        CGPoint point = CGPointMake(self.center.x,self.center.y-_offsetH+_outR/2+140*_scale);
                        CGPoint oldPoint =CGPointMake(self.center.x-_roatingR/2,self.center.y-_offsetH+_outR/2+50*_scale);
                        [self toucheToaddRoatingWithImageName:@"问题" withPoint:point witholdPoint:oldPoint tag:2];
                    }];
                }];
            }];
       

        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self.centerPoint =self.center;
                [self getLayout];
                UIView *view1 =[self.arrayRoating lastObject];
                [UIView animateWithDuration:0.3 animations:^{
                    view1.center = CGPointMake(self.center.x, self.center.y-_offsetH+_outR/2+50*_scale);
                } completion:^(BOOL finished) {
                    for (UIView *view in self.arrayRoating) {
                        [UIView animateWithDuration:0.3 animations:^{
                            [view removeFromSuperview];
                        }];
                        
                    }
                }];
            
              
            }];
        }

    }else    [self.delegate buttonVlaue:but];
    }

}
-(void)doButtonValueSet:(UIButton *)but{
    NSLog(@"%ld",but.tag);   [self.delegate buttonSetValue:but];
}
#pragma mark 获取tab数据 豆果数据
-(void)getDataWith:(NSString *)pageId{
    NSString *url = [NSString stringWithFormat:@"http://api.douguo.net/recipe/home/%@/20",pageId];
    [NetworkRequestManager requestWithType:POST urlString:url parDic:[NSDictionary dictionaryWithObjectsAndKeys:@"4",@"client", nil] header:[NSDictionary dictionaryWithObjectsAndKeys:@"application/x-www-form-urlencoded; charset=utf-8",@"Content-Type",@"611.2",@"version", nil] finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"state"] isEqualToString:@"success"]) {
            NSDictionary *dicResult = [dic objectForKey:@"result"];
            NSArray *arrayList = [dicResult objectForKey:@"list"];
            self.arrayImages = [NSMutableArray array];
            for (NSDictionary * dicList in arrayList ) {
                NSDictionary *dicR = [dicList objectForKey:@"r"];
                if (dicR) {
                    NSString *urlImage = [dicR objectForKey:@"p"];
                    [_arrayImages addObject:urlImage];
                }
                
            }
            
            [self performSelectorOnMainThread:@selector(doMainThread) withObject:nil waitUntilDone:YES];
            
        }
        else {
            NSLog(@"失败");
        }
        
    } error:^(NSError *error) {
        
    }];
}
#pragma mark- 轮播图
-(void)doMainThread{
    CarouselScrollView *carouseleS  = [[CarouselScrollView alloc]initWithImageArray:self.arrayImages];
    carouseleS.frame = _centerView.bounds;
    [_centerView addSubview:carouseleS];
}
@end
