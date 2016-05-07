//
//  FirstTableViewCell.h
//  foot
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoBuutonAndNewestButton.h"
#import "HomeFootModel.h"
@protocol FirstTableViewCellDelegate <NSObject>

-(void)toucheVideoButtonOnCell;
-(void)toucheNewestButtonOnCell;
-(void)toucheComtaionImageViewWith:(HomeFootModel *)model;


@end
@interface FirstTableViewCell : UITableViewCell<UIScrollViewDelegate,VideoBuutonAndNewestButtonDelegate>
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *arr;//随机数组
@property (nonatomic,strong)NSMutableDictionary *dicData;
@property (nonatomic)id<FirstTableViewCellDelegate>delegate;
@end
