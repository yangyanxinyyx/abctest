//
//  DetailsSearchViewController.m
//  foot
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 念恩. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define ColorBack     [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]


#import "DetailsSearchViewController.h"
#import "NetworkRequestManager.h"
#import "DetailsModel.h"
#import "SelectionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DataBaseUtil.h"
#import "HistoryModel.h"
#import "CookDetailsViewController.h"
@interface DetailsSearchViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITextField *textF;
@property (nonatomic,strong)UITableView *tabDetails;
@property (nonatomic,strong)NSMutableArray *detailsArray;
@end

@implementation DetailsSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *imageBack = [UIImage imageNamed:@"返回"];
    self.detailsArray = [NSMutableArray array];
    imageBack = [imageBack imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:imageBack style:UIBarButtonItemStylePlain target:self action:@selector(comeBackValue)];
    self.textF = [[UITextField alloc]initWithFrame:CGRectMake(0, 30,250, 30)];
    self.navigationItem.titleView = self.textF;
    self.textF.placeholder = @"输入菜谱名、食材名";
    self.textF.clearButtonMode = UITextFieldViewModeAlways;
    self.textF.backgroundColor = ColorBack;
    self.textF.layer.cornerRadius = 5;
    self.textF.layer.masksToBounds = YES;
    self.textF.text = self.searchContent;
    UIImage *imageSearch = [UIImage imageNamed:@"搜索"];
    imageSearch = [imageSearch imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:imageSearch style:UIBarButtonItemStylePlain target:self action:@selector(toucheSearch)];

    self.tabDetails = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
    self.tabDetails.delegate = self;
    self.tabDetails.dataSource = self;
    [self.view addSubview:self.tabDetails];
    [self getDataWith:self.searchContent];

   
}
#pragma mark-点击返回和搜素按钮的方法
-(void)comeBackValue{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)toucheSearch{
    if (self.textF.text.length == 0) {
        
    }else
   
    [self getDataWith:self.textF.text];
    [self.textF endEditing:YES];
    HistoryModel *modele = [[HistoryModel alloc]init];
    modele.content = self.textF.text;
    //插入到数据库里
    if (![[DataBaseUtil shareDataBase]selectModelWithContent:self.textF.text]) {
    [[DataBaseUtil shareDataBase]insertModel:modele];
    }
    
}
#pragma mark UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.detailsArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    SelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SelectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    DetailsModel *model = [_detailsArray objectAtIndex:indexPath.row];
    [cell.selectImageView sd_setImageWithURL:[NSURL URLWithString:model.p]];
    cell.labelName.text = model.n;
    cell.labelBrowse.text = [NSString stringWithFormat:@"%@浏览",model.vc];
    cell.labelCollect.text = [NSString stringWithFormat:@"  ·  %@收藏   ·  %@人做",model.fc,model.dc];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}
#pragma mark 点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CookDetailsViewController *cookD = [[CookDetailsViewController alloc]init];
    DetailsModel *model = [self.detailsArray objectAtIndex:indexPath.row];
    NSString *urlStr = [NSString stringWithFormat:@"http://api.douguo.net/recipe/detail/%@",model.id];
    NSDictionary *dicPar = [NSDictionary dictionaryWithObjectsAndKeys:@"4",@"client",@"0",@"author_id", nil];
    NSDictionary *dicHeader = [NSDictionary dictionaryWithObjectsAndKeys:@"application/x-www-form-urlencoded; charset=utf-8",@"Content-Type",@"611.2",@"version", nil];
    cookD.url = urlStr;
    cookD.parDic = dicPar;
    cookD.header = dicHeader;
    cookD.urlId = 11;
    [self.navigationController pushViewController:cookD animated:YES];
    
    
}
#pragma mark 获取数据
-(void)getDataWith:(NSString *)content{
    
    NSString *strUrl = [NSString stringWithFormat:@"http://api.douguo.net/recipe/s/0/20"];
    [NetworkRequestManager requestWithType:POST urlString:strUrl parDic:[NSDictionary dictionaryWithObjectsAndKeys:@"200",@"ss",@"0",@"order",@"4",@"client", content,@"keyword", nil] header:[NSDictionary dictionaryWithObjectsAndKeys:@"611.2",@"version",@"application/x-www-form-urlencoded; charset=utf-8",@"Content-Type", nil] finish:^(NSData *data) {
        [self.detailsArray removeAllObjects];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dicResult = [dic objectForKey:@"result"];
        NSArray *arrayList = [dicResult objectForKey:@"list"];
        for (NSDictionary *dicList in arrayList) {
            NSDictionary *dicR = [dicList objectForKey:@"r"];
            DetailsModel *model = [[DetailsModel alloc]init];
            [model setValuesForKeysWithDictionary:dicR];
            [self.detailsArray addObject:model];
       
        }
        if (_detailsArray.count == 0) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"未有搜索到你需要的" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertC addAction:action];
            [self presentViewController:alertC animated:YES completion:^{
                
            }];
        }
        else{
            [self performSelectorOnMainThread:@selector(doMainThread) withObject:nil waitUntilDone:NO];
            
                    }
    } error:^(NSError *error) {
        
    }];
    
    
}
-(void)doMainThread{
    [self.tabDetails reloadData];

}
#pragma -mark  tabBar的隐藏和显示
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.hidesBottomBarWhenPushed = YES;

}

-(void)viewWillDisappear:(BOOL)animated
{   [self.textF endEditing:YES];
 
}



@end
