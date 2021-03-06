//
//  CarouselScrollView.h
//  ScrollView轮播的封装
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 严玉鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CarouselScrollView;
typedef void(^ClickBlock) (NSInteger index);
@protocol CarouselScrollViewDelegate <NSObject>
/**
 *  该方法用来处理图片的点击，会返回图片在数组中的索引
 *  代理与block二选一即可，若两者都实现，block的优先级高
 *
 *  @param carouselView 控件本身
 *  @param index        图片索引
 */
-(void)casrouselView:(CarouselScrollView *)carouselView didClickImage:(NSInteger)index;

@end

@interface CarouselScrollView : UIView
/*
 这里没有提供修改占位图片的接口，如果需要修改，可直接到.m文件中
 修改占位图片名称为你想要显示图片的名称，或者将你想要显示图片的
 名称修改为placeholder，因为没实际意义，所以就不提供接口了
 */


/*
 *  注意：
 *  通过xib/sb创建时，获取到的尺寸是不准确的
 *  比如xib/sb宽度是320，运行在宽度375的设备上时，依旧只有320
 *  解决办法：通过代码重新设置frame即可
 *
 */

#pragma mark 属性
/*
*  分页控件，默认位置在底部中间
*/
@property (nonatomic,strong) UIPageControl *pageControl;
/**
 *  图片描述控件，默认在底部
 *  黑色透明背景，白色字体居中显示
 */
@property (nonatomic,strong) UILabel *describLabel;
/**
 *  轮播的图片数组，可以是图片，也可以是网络路径
 */
@property (nonatomic,strong) NSArray *imageArray;
/**
 *  图片描述的字符串数组，应与图片顺序对应
 */
@property (nonatomic,strong)NSArray *describeArray;
/**
 *  每一页停留时间，默认为5s，最少1s
 *  当设置的值小于1s时，则为默认值
 */
@property (nonatomic) NSTimeInterval time;
/**
 *  点击图片后要执行的操作，会返回图片在数组中的索引
 */
@property (nonatomic,copy) ClickBlock imageClickBlock;
/**
 *  代理，用来处理图片的点击
 */
@property (nonatomic,strong) id<CarouselScrollViewDelegate>delegate;

#pragma mark- 构造方法
/**
 *  构造方法
 *
 *  @param imageArray 图片数组
 *  @param describeArray 图片描述数组
 *  @param imageClickBlock 处理图片点击的代码
 *
 */
-(instancetype)initWithImageArray:(NSArray *)imageArray;
+(instancetype)carouselViewWithImageArray:(NSArray *)imageArray;
-(instancetype)initWithImageArray:(NSArray *)imageArray describeArray:(NSArray *)describeArray;
+(instancetype)carouselViewWithImageArray:(NSArray *)imageArray describeArray:(NSArray *)describeArray;
-(instancetype)initWithImageArray:(NSArray *)imageArray imageClickBlock:(ClickBlock)imageClickBlock;
+(instancetype)carouselViewWithImageArray:(NSArray *)imageArray imageClickBlock:(ClickBlock)imageClickBlock;

#pragma mark 方法
/**
 *  开启定时器
 *  默认已开启，调用该方法会重新开启
 */
-(void)startTimer;
/**
 *  停止定时器
 *  停止后，如果手动滚动图片，定时器会重新开启
 */
-(void)stopTimer;
/**
 *  清除沙盒中的图片缓存
 */
- (void)clearDiskCache;
@end





