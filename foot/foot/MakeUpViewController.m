//
//  MakeUpViewController.m
//  食材组合
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 yangyanxin. All rights reserved.
//

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height


#import "MakeUpViewController.h"
#import "MakeUpListViewController.h"
#import "MixFoodCollectionViewCell.h"
#import "NetworkRequestManager.h"
#import "MixKindModel.h"
#import "MixFoodModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MixFoodTableViewCell.h"

@interface MakeUpViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
//瀑布流列表
@property(nonatomic,strong)UICollectionView *mixFoodCollectionView;
//下方view
@property(nonatomic,strong)UIView *bottomView;
//右侧view
@property(nonatomic,strong)UIView *rightView;
//右侧点击按钮
@property(nonatomic,strong)UIButton *buRight;
//判断右侧是否弹出
@property(nonatomic,assign)BOOL isOpen;
//深色背景
@property(nonatomic,strong)UIView *viewBlack;
//右侧tableView
@property(nonatomic,strong)UITableView *tab;
//tableView的数据源数组
@property(nonatomic,strong)NSMutableArray *dataArrayTab;
//collectionView的数据源数组
@property(nonatomic,strong)NSMutableArray *dataArrayColl;

@property(nonatomic,assign)BOOL isHave;


//提示框
@property(nonatomic,strong)UILabel *labelPrompt;
//分割线
@property(nonatomic,strong)UILabel *labelLine;
//选择的菜的数组
@property(nonatomic,strong)NSMutableArray *arraySelected;
//选择菜的按钮的数组
@property(nonatomic,strong)NSMutableArray *arrayButtomSelected;
//存放cell的数组
@property(nonatomic,strong)NSMutableArray *arrayCell;
//两个加号
@property(nonatomic,strong)UIImageView *imageVPlus1;
@property(nonatomic,strong)UIImageView *imageVPlus2;

//显示组合结果
@property(nonatomic,strong)UIView *viewResult;
@property(nonatomic,strong)UILabel *lableResultCount;
//显示可做的菜的数量
@property(nonatomic,strong)NSString *totalResult;


@property(nonatomic,strong)NSTimer *timer;

@end

@implementation MakeUpViewController

#pragma mark- 懒加载
-(NSMutableArray*)dataArrayTab
{
    if (_dataArrayTab == nil) {
        _dataArrayTab = [NSMutableArray array];
    }
    return _dataArrayTab;
}

-(NSMutableArray*)dataArrayColl
{
    if (_dataArrayColl == nil) {
        _dataArrayColl = [NSMutableArray array];
    }
    return _dataArrayColl;
}

-(NSMutableArray*)arraySelected
{
    if (_arraySelected == nil) {
        _arraySelected = [NSMutableArray array];
    }
    return _arraySelected;
}

-(NSMutableArray*)arrayButtomSelected
{
    if (_arrayButtomSelected == nil) {
        _arrayButtomSelected = [NSMutableArray array];
    }
    return _arrayButtomSelected;
}

-(NSMutableArray*)arrayCell
{
    if (_arrayCell == nil) {
        _arrayCell = [NSMutableArray array];
    }
    return _arrayCell;
}


#pragma mark- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"食材组合";

    [self requestData];
    [self setCollectionView];
    [self setBottomView];
    [self setRightView];
 
}


#pragma mark- 创建collectionView
-(void)setCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 0, 30);
    layout.itemSize = CGSizeMake((SCREEN_W-50-10*3)/3, (SCREEN_W-50-10*3)/3);
    
    
    self.mixFoodCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64-49-SCREEN_W/5) collectionViewLayout:layout];
    self.mixFoodCollectionView.backgroundColor = [UIColor whiteColor];
    self.mixFoodCollectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mixFoodCollectionView];
    self.mixFoodCollectionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    self.mixFoodCollectionView.dataSource = self;
    self.mixFoodCollectionView.delegate = self;
    
    [self.mixFoodCollectionView registerClass:[MixFoodCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}

#pragma mark- collectionView DataSource Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArrayColl count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MixFoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    MixFoodModel *foodModel = [self.dataArrayColl objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:foodModel.image];
 
    [cell.imageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"等待占位图"]];

    cell.viewBack.backgroundColor = [UIColor clearColor];
    cell.imageSelect.image = nil;
    
    //点击变成变成已点击的状态 --> 159行
    for (MixFoodModel *food in self.arraySelected) {
        if (food.text == foodModel.text) {
            cell.viewBack.backgroundColor = [UIColor blackColor];
            UIImage *image = [UIImage imageNamed:@"勾勾"];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            cell.imageSelect.image = image;
            cell.viewBack.alpha = 0.7;
            
        }
    }
    

    
    
    cell.labelName.text = foodModel.text;
    [cell.labelName sizeToFit];
    cell.labelName.center = [cell.subviews lastObject].center;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //分割线
    if (!self.labelLine) {
        self.labelLine = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W/5*4, 0, 1, self.bottomView.frame.size.height)];
        self.labelLine.backgroundColor = [UIColor grayColor];
        [self.bottomView addSubview:self.labelLine];
    }
    self.labelLine.hidden = NO;
    self.labelPrompt.hidden = YES;
    
    //开始组合食材
    if (self.arraySelected.count<3) {
        MixFoodModel *foodModel = [self.dataArrayColl objectAtIndex:indexPath.row];
        
        
        if (self.arraySelected.count == 0) {
            [self.arraySelected addObject:foodModel];
            //点击变成变成已点击的状态 --> 122行
            MixFoodCollectionViewCell *cell = (MixFoodCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
            cell.viewBack.backgroundColor = [UIColor blackColor];
            UIImage *image = [UIImage imageNamed:@"勾勾"];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            cell.imageSelect.image = image;
            cell.viewBack.alpha = 0.7;
            [self.arrayCell addObject:cell];
            //选择的菜的按钮
            [self creatFoodButtom];
            
        }else
        {
            NSArray *array = [NSArray arrayWithArray:self.arraySelected];
            for (MixFoodModel *model in array) {
                
                if (foodModel.text == model.text) {
                    self.isHave = YES;
                   
                    //删除菜
                    MixFoodCollectionViewCell *cell = (MixFoodCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
                    cell.imageSelect.backgroundColor = [UIColor clearColor];
                    NSArray *array = self.bottomView.subviews;
                    for (UIView *view in array) {
                        if ([view isKindOfClass:[UIButton class]]) {
                            UIButton *bu = (UIButton*)view;
                            if (bu.titleLabel.text == foodModel.text) {
                                [self cancelChoose:bu];
                            }

                        }
                    }
                    NSLog(@"%ld",self.arraySelected.count);
                    break;
                    
                }
                else
                {
                    self.isHave = NO;
                    
                }

            }
            
            if (self.isHave == NO) {
                [self.arraySelected addObject:foodModel];
                //点击变成变成已点击的状态 --> 122行
                MixFoodCollectionViewCell *cell = (MixFoodCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
                cell.viewBack.backgroundColor = [UIColor blackColor];
                UIImage *image = [UIImage imageNamed:@"勾勾"];
                image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                cell.imageSelect.image = image;
                cell.viewBack.alpha = 0.7;
                [self.arrayCell addObject:cell];
                //选择的菜的按钮
                [self creatFoodButtom];
                NSLog(@"添加");
            }
          
        }
    }
    else if (self.arraySelected.count == 3)
    {
        MixFoodModel *foodModel = [self.dataArrayColl objectAtIndex:indexPath.row];
        NSArray *array = [NSArray arrayWithArray:self.arraySelected];
        for (MixFoodModel *model in array) {
            if (foodModel.text == model.text) {
                self.isHave = YES;
                NSLog(@"11111");
                //删除菜
                MixFoodCollectionViewCell *cell = (MixFoodCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
                cell.viewBack.backgroundColor = [UIColor clearColor];
                cell.imageSelect.image = nil;
                
                NSArray *array = self.bottomView.subviews;
                for (UIView *view in array) {
                    if ([view isKindOfClass:[UIButton class]]) {
                        UIButton *bu = (UIButton*)view;
                        if (bu.titleLabel.text == foodModel.text) {
                            [self cancelChoose:bu];
                        }
                        
                    }
                }
                break;
            }
            else
            {
                self.isHave = NO;
                
            }
            
            
        }
        if (self.isHave == NO) {
 
            //弹出提示动画
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_W-200)/2, self.bottomView.frame.origin.y-38, 200, 38)];
            [self.view addSubview:lab];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                lab.backgroundColor = [UIColor blackColor];
                lab.text = @"最多只能选择3种食材哦~";
                lab.textColor = [UIColor whiteColor];
                lab.alpha = 0.8;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionTransitionNone animations:^{
                    lab.alpha = 0;
                } completion:^(BOOL finished) {
                    [lab removeFromSuperview];
                }];
            }];
        }
    }
   
#pragma mark- 下方弹出加号以及进行网络请求
    /*
     下方弹出加号以及进行网络请求
     */
    if (!self.imageVPlus1) {
        self.imageVPlus1 = [[UIImageView alloc] initWithFrame:CGRectMake((30+(SCREEN_W/5*4-110)/3)-10, (self.bottomView.frame.size.height-20)/2, 20, 20)];
        [self.bottomView addSubview:self.imageVPlus1];
        self.imageVPlus1.image = [UIImage imageNamed:@"加号红"];
        self.imageVPlus1.alpha = 0;
    }
    if (!self.imageVPlus2) {
        self.imageVPlus2 = [[UIImageView alloc] initWithFrame:CGRectMake((30+(SCREEN_W/5*4-110)/3)*2-10, (self.bottomView.frame.size.height-20)/2, 20, 20)];
        [self.bottomView addSubview:self.imageVPlus2];
        self.imageVPlus2.image = [UIImage imageNamed:@"加号红"];
        self.imageVPlus2.alpha = 0;
    }
    
    if (!self.viewResult) {
        self.viewResult = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W/5*4+5, 5, SCREEN_W/5-10, SCREEN_W/5-10)];
        self.viewResult.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        self.viewResult.layer.cornerRadius = SCREEN_W/5/2;
        self.viewResult.layer.masksToBounds = YES;
        [self.bottomView addSubview:self.viewResult];
        self.viewResult.alpha = 0;
        self.viewResult.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchResult)];
        [self.viewResult addGestureRecognizer:tap];
        
        
        self.lableResultCount = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_W/5/5, SCREEN_W/5-10, [UIScreen mainScreen].bounds.size.width*20/414)];
        self.lableResultCount.textAlignment = NSTextAlignmentCenter;
        self.lableResultCount.textColor = [UIColor redColor];
        [self.viewResult addSubview:self.lableResultCount];
        
        
        UILabel *labtext = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_W/5/5+[UIScreen mainScreen].bounds.size.width*20/414, SCREEN_W/5-10, 20)];
        labtext.text = @"可做菜式";
        labtext.textAlignment = NSTextAlignmentCenter;
        labtext.font = [UIFont systemFontOfSize:[UIScreen mainScreen].bounds.size.width*13/414];
        [self.viewResult addSubview:labtext];
    }
    
    
    if (self.arraySelected.count == 1 ) {
        self.imageVPlus1.alpha = 1;
    }else if (self.arraySelected.count == 2 )
    {
        self.imageVPlus2.alpha = 1;
        self.viewResult.alpha = 1;
        
        [self getMixResult];
    }else if (self.arraySelected.count == 3)
    {
        [self getMixResult];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(pause) userInfo:nil repeats:NO];
    self.mixFoodCollectionView.userInteractionEnabled = NO;
    
}

-(void)pause
{
    self.mixFoodCollectionView.userInteractionEnabled = YES;
    [_timer invalidate];
    _timer = nil;
}

#pragma mark- 点击菜的结果的执行的方法
-(void)touchResult
{
    
    if (self.lableResultCount.text.length>0 && ![self.lableResultCount.text  isEqualToString:@"0"]) {
        
        
        
        MakeUpListViewController *list = [[MakeUpListViewController alloc] init];
        
        NSMutableArray *array = [NSMutableArray array];
        for (MixFoodModel *model in self.arraySelected) {
            [array addObject:model.id];
        }
        list.dataArrayid = array;
        list.foodtotal = self.lableResultCount.text;
        
        [self.navigationController pushViewController:list animated:YES];
        
        
        
    }
    
}

#pragma mark- 创建菜的按钮
-(void)creatFoodButtom
{
    UIButton *bu = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:bu];
    bu.tag = self.arraySelected.count;
    [bu setBackgroundImage:[UIImage imageNamed:@"等待占位图"] forState:UIControlStateNormal];
    bu.layer.cornerRadius = (SCREEN_W/5*4-110)/3/2;
    bu.layer.masksToBounds = YES;
    bu.frame = CGRectMake(20+(30+(SCREEN_W/5*4-110)/3) * (self.arraySelected.count-1), (self.bottomView.frame.size.height-(SCREEN_W/5*4-110)/3)/2, (SCREEN_W/5*4-110)/3, (SCREEN_W/5*4-110)/3);
    MixFoodModel *model = [self.arraySelected objectAtIndex:bu.tag-1];
    [bu setTitle:model.text forState:UIControlStateNormal];
    [bu setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [bu sd_setBackgroundImageWithURL:[NSURL URLWithString:model.image] forState:UIControlStateNormal];
    [bu addTarget:self action:@selector(cancelChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.arrayButtomSelected addObject:bu];
    
    
    NSLog(@"%@",model.id);
}

#pragma mark- 点击删除选择的菜
-(void)cancelChoose:(UIButton*)bu
{
    [bu removeFromSuperview];
    
    NSArray *array = [NSArray arrayWithArray:self.arraySelected];
    
    for (MixFoodModel *model in array) {
        if (bu.titleLabel.text == model.text) {
            [self.arraySelected removeObject:model];
        }
    }
    
    int i=0;
    NSArray *array1 = self.bottomView.subviews;
    for (UIView *view in array1) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *bu = (UIButton*)view;
            bu.frame = CGRectMake(20+(30+(SCREEN_W/5*4-110)/3) * i, (self.bottomView.frame.size.height-(SCREEN_W/5*4-110)/3)/2, (SCREEN_W/5*4-110)/3, (SCREEN_W/5*4-110)/3);
            i++;
            
        }
    }
  
    for (MixFoodCollectionViewCell *cell in self.arrayCell) {
        NSLog(@"%@",cell.labelName.text);
        NSLog(@"%@",bu.titleLabel.text);
        if ([bu.titleLabel.text isEqualToString:cell.labelName.text]) {
            cell.viewBack.backgroundColor = [UIColor clearColor];
            cell.imageSelect.image = nil;
        }
    }
 
    if (self.arraySelected.count == 0) {
        self.labelLine.hidden = YES;;
        self.labelPrompt.hidden = NO;
        self.imageVPlus1.alpha = 0;

        
    }
    else if (self.arraySelected.count == 1)
    {

        self.imageVPlus2.alpha = 0;
        self.viewResult.alpha = 0;
        self.lableResultCount.text = nil;
    }
    else if (self.arraySelected.count == 2)
    {
        [self getMixResult];
    }

}


#pragma mark- 设置下方view
-(void)setBottomView
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.mixFoodCollectionView.frame.size.height, SCREEN_W, SCREEN_W/5)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.layer.borderWidth = 1;
    self.bottomView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:self.bottomView];
    
    
    self.labelPrompt = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_W/5)];
    self.labelPrompt.text = @"选择2个或3个食材\n爸爸告诉你可以做哪些菜";
    self.labelPrompt.textAlignment = NSTextAlignmentCenter;
    self.labelPrompt.numberOfLines = 0;
    [self.bottomView addSubview:self.labelPrompt];
}

#pragma mark- 设置右侧view
-(void)setRightView
{
    //右侧按钮
    self.buRight = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buRight.frame = CGRectMake(SCREEN_W-30, (self.mixFoodCollectionView.frame.size.height-SCREEN_W/5)/2, 35, SCREEN_W/5);
    [self.buRight setImage:[UIImage imageNamed:@"后退"] forState:UIControlStateNormal];
    self.buRight.layer.cornerRadius = 5;
    self.buRight.layer.masksToBounds = YES;
    self.buRight.layer.borderWidth = 1;
    self.buRight.layer.borderColor = [UIColor grayColor].CGColor;
    [self.buRight addTarget:self action:@selector(touchRightBu) forControlEvents:UIControlEventTouchUpInside];
    self.buRight.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buRight];
    
    //右侧view
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W, 0, SCREEN_W/2, SCREEN_H-64-49-SCREEN_W/5)];
    self.rightView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.rightView];
    
    //右侧tableView
    
    self.tab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.rightView.frame.size.width, self.rightView.frame.size.height) style:UITableViewStylePlain];
    [self.rightView addSubview:self.tab];
    self.tab.delegate = self;
    self.tab.dataSource = self;
    self.tab.showsVerticalScrollIndicator = NO;
    
    self.isOpen = NO;
}

#pragma mark- 点击右侧按钮弹出选择栏
-(void)touchRightBu
{
    
    if (self.isOpen == NO) {
        
        //黑色阴影
        self.viewBlack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, self.mixFoodCollectionView.frame.size.height)];
        self.viewBlack.backgroundColor = [UIColor blackColor];
        self.viewBlack.alpha = 0.5;
        [self.view insertSubview:self.viewBlack aboveSubview:self.mixFoodCollectionView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBlackView)];
        self.viewBlack.userInteractionEnabled = YES;
        [self.viewBlack addGestureRecognizer:tap];
        
        //右侧弹出
        [self.buRight setImage:[UIImage imageNamed:@"前进"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.8 animations:^{
            self.buRight.frame = CGRectMake(SCREEN_W/2-30, (self.mixFoodCollectionView.frame.size.height-SCREEN_W/5)/2, 35, SCREEN_W/5);
            
            self.rightView.frame = CGRectMake(SCREEN_W/2, 0, SCREEN_W/2, SCREEN_H-64-49-SCREEN_W/5);
        }];
    }else
    {
        [self.viewBlack removeFromSuperview];
        //右侧收回
        [self.buRight setImage:[UIImage imageNamed:@"后退"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.8 animations:^{
            self.buRight.frame = CGRectMake(SCREEN_W-30, (self.mixFoodCollectionView.frame.size.height-SCREEN_W/5)/2, 35, SCREEN_W/5);
            
            self.rightView.frame = CGRectMake(SCREEN_W, 0, SCREEN_W/2, SCREEN_H-64-49-SCREEN_W/5);
        }];
    }
    
    self.isOpen = !self.isOpen;
}

#pragma mark 点击黑色背景
-(void)touchBlackView
{
    [self touchRightBu];
}

#pragma mark- tableView的dataSouse 和delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArrayTab count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    MixFoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MixFoodTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    MixKindModel *kindModel = [self.dataArrayTab objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:kindModel.image];
    
    [cell.imageV sd_setImageWithURL:url];
    cell.labelText.text = kindModel.text;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataArrayColl removeAllObjects];
    MixKindModel *kindModel = [_dataArrayTab objectAtIndex:indexPath.row];
    NSArray *Array = kindModel.data;
    for (NSDictionary *dic in Array) {
        MixFoodModel *foodModel = [[MixFoodModel alloc] init];
        [foodModel setValuesForKeysWithDictionary:dic];
        [self.dataArrayColl addObject:foodModel];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mixFoodCollectionView reloadData];
    });
    [self touchRightBu];
    
}


#pragma mark- 页面数据请求
-(void)requestData
{
   [NetworkRequestManager requestWithType:POST urlString:@"http://api.izhangchu.com/" parDic:[NSDictionary dictionaryWithObjectsAndKeys:@"MaterialSubtype",@"methodName", nil] header:nil finish:^(NSData *data) {
       
       NSError *error = nil;
       
       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
       NSDictionary *dicData1 = [dic valueForKey:@"data"];
       NSArray *arrayData = [dicData1 valueForKey:@"data"];
       for (NSDictionary *dic in arrayData) {
           MixKindModel *model = [[MixKindModel alloc] init];
           [model setValuesForKeysWithDictionary:dic];
           [self.dataArrayTab addObject:model];
       }
       dispatch_async(dispatch_get_main_queue(), ^{
           [self.tab reloadData];
       });
       
       //页面开始先加载第一类的
       MixKindModel *kindModel = [_dataArrayTab objectAtIndex:0];
       NSArray *Array = kindModel.data;
       for (NSDictionary *dic in Array) {
           MixFoodModel *foodModel = [[MixFoodModel alloc] init];
           [foodModel setValuesForKeysWithDictionary:dic];
           [self.dataArrayColl addObject:foodModel];
       }
       dispatch_async(dispatch_get_main_queue(), ^{
           [self.mixFoodCollectionView reloadData];
       });
       
       
   } error:^(NSError *error) {
       
   }];
}

#pragma mark- 请求组合结果数据
-(void)requestMixResult:(NSDictionary*)dic
{

    [NetworkRequestManager requestWithType:POST urlString:@"http://api.izhangchu.com/" parDic:dic header:nil finish:^(NSData *data) {
        
        NSError *error = nil;
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSDictionary *dicData = [dic valueForKey:@"data"];

     
        
        NSString *total = [dicData valueForKey:@"total"];
        self.totalResult = total;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lableResultCount.text = self.totalResult;
        });
        
    } error:^(NSError *error) {
        
    }];
    
}

-(void)getMixResult
{
    NSMutableArray *arrayTemp = [NSMutableArray array];
    for (MixFoodModel *model in self.arraySelected) {
        [arrayTemp addObject:model.id];
    }
    NSString *strRequest = [arrayTemp componentsJoinedByString:@"%2C"];
    strRequest = [strRequest stringByAppendingString:@"%2C"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"SearchMix",@"methodName",strRequest,@"material_ids",@"4.40",@"version", nil];
    
    [self requestMixResult:dic];
}

#pragma mark- 页面出现的方法

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.isOpen == YES) {
        [self touchRightBu];
    }
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
