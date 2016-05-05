//
//  FirstTableViewCell.h
//  foot
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoBuutonAndNewestButton.h"

@protocol FirstTableViewCellDelegate <NSObject>

-(void)toucheVideoButtonOnCell;
-(void)toucheNewestButtonOnCell;

@end
@interface FirstTableViewCell : UITableViewCell<UIScrollViewDelegate,VideoBuutonAndNewestButtonDelegate>
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic)id<FirstTableViewCellDelegate>delegate;
@end
