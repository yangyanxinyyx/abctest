//
//  UIImageView+CreateByUrl.m
//  Lesson_UI_22(3)
//
//  Created by 侯垒 on 15/5/21.
//  Copyright (c) 2015年 Se7eN_HOU. All rights reserved.
//
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#import "UIImageView+CreateByUrl.h"
#import "ImageManager.h"

@implementation UIImageView (CreateByUrl)
#pragma -mark通过Url对UIImageView设置图片
-(void)setImageByUrl:(NSString *)urlString
{
   //使用多线程的技术根据URL去请求图片
    //创建一个并行队列
    dispatch_queue_t downLoadQueue=dispatch_queue_create("download",NULL);
    
    __block UIImageView *weakSelf = self;
     //使用并行队列创建一个子线程
    dispatch_async(downLoadQueue, ^{
        //在该子线程内部请求图片
        //1、创建一个URL
        NSURL *url=[NSURL URLWithString:urlString];
        //2、通过一个url可以直接创建一个NSData
        NSData *data=[NSData dataWithContentsOfURL:url];
        //3、使用请求回来的data创建UIImage
        UIImage *image=[UIImage imageWithData:data];
        
        //剪切图片
         CGFloat height = KScreenWidth/375*500;
       image =  [ImageManager getSubImage:image mCGRect:CGRectMake(0, 0, (KScreenWidth-20)*1.5 , height/3*1.5) centerBool:YES];
        
        
        //GCD返回主线程的方法
        dispatch_sync(dispatch_get_main_queue(), ^{
            //该block里面就是主线程
            weakSelf.image=image;
        });
    });
    
}



@end










