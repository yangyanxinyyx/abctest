//
//  VideoBuutonAndNewestButton.h
//  foot
//
//  Created by lanou on 16/5/4.
//  Copyright © 2016年 念恩. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoBuutonAndNewestButtonDelegate <NSObject>

-(void)toucheVideoButton;
-(void)toucheNewestButton;

@end


@interface VideoBuutonAndNewestButton : UIView
@property (nonatomic,strong)UIButton *VideoButton;
@property (nonatomic,strong)UIButton *NewestButton;
@property (nonatomic)id<VideoBuutonAndNewestButtonDelegate>delegate;
-(instancetype)initWithFrame:(CGRect)frame;
@end
