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
#import "MyProblemViewController.h"
#import "ClauseView.h"

#import "MyCollectViewController.h"

@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ClauseViewDelegate>
{
    ClauseView *viewClause;
}
@property (nonatomic,strong)UITableView *tabMy;
@property (nonatomic,strong)NSMutableArray *arrayMySection;
@property (nonatomic,strong)NSArray *arrayNumber;
@property (nonatomic,strong)NSDictionary *dicData;
@property (nonatomic,strong)UIImageView *imageView;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = ColorBack;
    self.navigationItem.title = @"我的";
    self.arrayMySection = [NSMutableArray array];
    self.arrayNumber = [NSArray array];
    NSArray *arrayHelp = [NSArray arrayWithObjects:@"常见问题",@"联系客服",@"使用条款与隐私政策", nil];
    NSArray *arrayAbout = [NSArray arrayWithObjects:@"检查更新",@"清楚缓存",@"推荐给好友",@"关于我们", nil];
    self.dicData = [NSDictionary dictionaryWithObjectsAndKeys:self.arrayNumber,@"0",arrayHelp,@"1",arrayAbout,@"2",nil];
#pragma mark- 添加头像
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((KScreenWidth-80)/2, 10, 80, 80)];
    _imageView.layer.cornerRadius = 40;
    _imageView.layer.masksToBounds = YES;
    _imageView.backgroundColor = [UIColor orangeColor];
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toucheImageViewIcon)];
    [_imageView addGestureRecognizer:tapG];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [user objectForKey:@"image"];
    UIImage *image =[UIImage imageWithData:data];
    _imageView.image = image;
    [self.view addSubview:_imageView];
    
    
    self.tabMy = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, KScreenWidth, KScreenHeight -64 -49-100) style:UITableViewStyleGrouped];
    self.tabMy.delegate = self;
    self.tabMy.dataSource = self;
    self.tabMy.bounces = NO;
    [self.view addSubview:self.tabMy];
    
#pragma 获取数据
    for (int i =0; i<3; i++) {
        MyModel *myM = [[MyModel alloc]init];
        [self.arrayMySection addObject:myM];
    }
 
    
}

#pragma mark UITbaleView的代理方法
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MyModel *myModel = [self.arrayMySection objectAtIndex:section];
    if (myModel.isOpen == YES) {
        NSString *key = [NSString stringWithFormat:@"%ld",section];
     return  [[self.dicData objectForKey:key] count];
       
    }
    else return 0;
    
}
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.backgroundColor = ColorBack;
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.section];
    NSArray *arr = [self.dicData objectForKey:key];
    cell.textLabel.text = arr[indexPath.row];
    return cell;

}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}
//分区高度
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 50;
}
//自定义分区
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 10, KScreenWidth-10, 30)];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor lightGrayColor];
    
 
    NSArray *arrayTitle = [NSArray arrayWithObjects:@"历史收藏",@"使用帮助与反馈",@"关于软件",nil];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 10, KScreenWidth-30, 26);
    [button setTitle:arrayTitle[section] forState:UIControlStateNormal];
    button.tag = section;
    [button addTarget:self action:@selector(toucheSectionToSwitch:) forControlEvents:UIControlEventTouchDown];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.tag = section;
    //让but的字体
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [view addSubview:button];
    
    return view;
}
#pragma mark- 点击cell的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.section];
    NSArray *arrMy = [self.dicData objectForKey:key];
    NSString *str = [arrMy objectAtIndex:indexPath.row];
    if ([str isEqualToString:@"常见问题"]) {
        MyProblemViewController *myproblemV = [[MyProblemViewController alloc]init];
        [self.navigationController pushViewController:myproblemV animated:YES];
    }else if ([str isEqualToString:@"联系客服"]){
        UIAlertController *alertC = [UIAlertController  alertControllerWithTitle:@"如有遇到什么奇葩问题可以联系下面电话" message:@"13336525635" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:^{
            
        }];
        
    }else if ([str isEqualToString:@"检查更新"]){
        UIAlertController *alertC = [UIAlertController  alertControllerWithTitle:@"当前已是最新版本!!" message:@"版本为：1.0.1" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:^{
            
        }];
    }else if ([str isEqualToString:@"清楚缓存"]){
        UIAlertController *alertC = [UIAlertController  alertControllerWithTitle:@"是否要清楚缓存" message:@"现在缓存位M" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //清楚缓冲中的数据
            NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
            NSLog(@"%@",cache);
            NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cache error:NULL];
            for (NSString *fileName in contents) {
                [[NSFileManager defaultManager] removeItemAtPath:[cache stringByAppendingPathComponent:fileName] error:nil];
                            }
        
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:action];
        [alertC addAction:action1];
        [self presentViewController:alertC animated:YES completion:^{
            
        }];
    }else if ([str isEqualToString:@"使用条款与隐私政策"]){
        
        viewClause = [[ClauseView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight)];
        [self.view addSubview:viewClause];
        viewClause.backgroundColor =[UIColor orangeColor];
        viewClause.delegate = self;
        [UIView animateWithDuration:0.5 animations:^{
            viewClause.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        }];
        
    }
    
    
    
}
#pragma mark - 点击开关分区
-(void)toucheSectionToSwitch:(UIButton *)but{
    if ([but.titleLabel.text isEqualToString:@"历史收藏"]) {
        MyCollectViewController *myCollect = [[MyCollectViewController alloc]init];
        [self.navigationController pushViewController:myCollect animated:YES];
    }
    MyModel *myModel = [self.arrayMySection objectAtIndex:but.tag];
    myModel.isOpen = !myModel.isOpen;
//    [self.tabMy reloadData];
    [self.tabMy reloadSections:[NSIndexSet indexSetWithIndex:but.tag] withRowAnimation:UITableViewRowAnimationNone];//动画效果
}
#pragma mark -点击更换图片
-(void)toucheImageViewIcon{
    UIImagePickerController *pickC = [[UIImagePickerController alloc]init];
    pickC.delegate = self;
    //允许编辑
    pickC.allowsEditing = YES;
    [self presentViewController:pickC animated:YES completion:^{
        
    }];
    
}
//UIImagePickerController 的代理方法 获取系统图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //从字典中取图片
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    _imageView.image = image;
    NSData *data ;
    if (UIImagePNGRepresentation(image) == nil) {
        
        data = UIImageJPEGRepresentation(image, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(image);
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:data forKey:@"image"];
    
    
    //消失
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
-(void)toucheComeBackButton{
    [UIView animateWithDuration:0.5 animations:^{
        viewClause.frame = CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight);
    }];
}
@end
