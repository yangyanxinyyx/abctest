//
//  CarouselScrollView.m
//  ScrollView轮播的封装
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 严玉鑫. All rights reserved.
//

#import "CarouselScrollView.h"
#define  DEFAULTTIME 5
typedef enum {
    DirecNone,
    DirecLeft,
    DirecRight,
}Direction;
@interface CarouselScrollView()<UIScrollViewDelegate>
//轮播的图片数组
@property (nonatomic,strong) NSMutableArray *images;
//下载的图片字典
@property (nonatomic,strong) NSMutableDictionary *imageDic;
//下载图片的操作
@property (nonatomic,strong) NSMutableDictionary *operationDic;
//滚动方向
@property (nonatomic,assign) Direction direction;
//显示的imageView
@property (nonatomic,strong) UIImageView *currImageView;
//辅助滚动的imageView
@property (nonatomic,strong) UIImageView *otherImageView;
//当前显示图片的索引
@property (nonatomic) NSInteger currIndex;
//将要显示图片的索引
@property (nonatomic) NSInteger nextIndex;
//滚动视图
@property (nonatomic,strong) UIScrollView *scrollView;
//定时器
@property (nonatomic,strong) NSTimer *timer;
//任务队列
@property (nonatomic,strong) NSOperationQueue *queue;

@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat width;

@end


@implementation CarouselScrollView
#pragma mark- 初始化方法
//创建用来缓存图片的文件夹
+(void)initialize{
    NSString *cache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"XRcarousel"];
    BOOL isDir = NO;
    BOOL isExists = [[NSFileManager defaultManager]fileExistsAtPath:cache isDirectory:&isDir];
    if (!isDir || !isExists) {
        [[NSFileManager defaultManager]createDirectoryAtPath:cache withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark- frame相关
-(CGFloat)height{
    return self.scrollView.frame.size.height;
}
-(CGFloat)width {
 
    return self.scrollView.frame.size.width;
}
#pragma mark- 懒加载
-(NSMutableDictionary *)imageDic{
    if (!_imageDic) {
        self.imageDic = [NSMutableDictionary dictionary];
    }
    return _imageDic;
}

-(NSMutableDictionary *)operationDic{
    if (!_operationDic) {
        self.operationDic = [NSMutableDictionary dictionary];
    }
    return _operationDic;
}

-(NSOperationQueue *)queue{
    if (!_queue) {
        self.queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc]init];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _currImageView = [[UIImageView alloc]init];
        _currImageView.contentMode = UIViewContentModeScaleAspectFit;
        _currImageView.userInteractionEnabled = YES;
        [_currImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick)]];
        [_scrollView addSubview:_currImageView];
        _otherImageView = [[UIImageView alloc]init];
        _otherImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_otherImageView];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
-(UILabel *)describLabel{
    if (!_describLabel) {
        self.describLabel = [[UILabel alloc]init];
        _describLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _describLabel.textColor = [UIColor whiteColor];
        _describLabel.textAlignment = NSTextAlignmentCenter;
        _describLabel.font = [UIFont systemFontOfSize:13];
        _describLabel.hidden= YES;
        [self addSubview:_describLabel];
    }
    return _describLabel;
}

#pragma mark-构造方法
-(instancetype)initWithImageArray:(NSArray *)imageArray{
    return [self initWithImageArray:imageArray imageClickBlock:nil];
}
+(instancetype)carouselViewWithImageArray:(NSArray *)imageArray{
    return [self carouselViewWithImageArray:imageArray imageClickBlock:nil];
}
-(instancetype)initWithImageArray:(NSArray *)imageArray describeArray:(NSArray *)describeArray{
    if (self = [self initWithImageArray:imageArray]) {
        self.describeArray = describeArray;
    }
    return self;
}
+(instancetype)carouselViewWithImageArray:(NSArray *)imageArray describeArray:(NSArray *)describeArray{
    return [[self alloc]initWithImageArray:imageArray describeArray:describeArray];
}
-(instancetype)initWithImageArray:(NSArray *)imageArray imageClickBlock:(ClickBlock)imageClickBlock{
    if (self = [super init]) {
        self.imageArray = imageArray;
        self.imageClickBlock = imageClickBlock;
    }
    return self;
}
+(instancetype)carouselViewWithImageArray:(NSArray *)imageArray imageClickBlock:(ClickBlock)imageClickBlock{
    return [[self alloc]initWithImageArray:imageArray imageClickBlock:imageClickBlock];
}
#pragma mark- --------设置相关方法--------
#pragma mark 设置控件的frame
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.scrollView.frame = frame;
    NSLog(@"%f",self.scrollView.frame.size.width);
    [self setscrollViewContentSize];
}
#pragma mark 设置滚动方向
-(void)setDirection:(Direction)direction{
    if (_direction == direction) return;
    _direction = direction;
    if (direction == DirecNone) return;
    if (direction == DirecRight) {
        self.otherImageView.frame = CGRectMake(0, 0, self.width, self.height);
        self.nextIndex = self.currIndex - 1;
        if (self.nextIndex < 0) {
            self.nextIndex = _images.count - 1;
        }
    }else if (direction == DirecLeft){
        self.otherImageView.frame = CGRectMake(CGRectGetMaxX(_currImageView.frame), 0, self.width, self.height);
        self.nextIndex = (self.currIndex + 1) % _images.count;
    }
    self.otherImageView.image = self.images[self.nextIndex];
}
#pragma mark 设置图片数组
-(void)setImageArray:(NSArray *)imageArray{
    if (!imageArray.count) return;
    _imageArray = imageArray;
    _images = [NSMutableArray array];
    for (int i = 0; i < imageArray.count; i++) {
        if ([imageArray[i] isKindOfClass:[UIImage class]]) {
            [_images addObject:imageArray[i]];
        }else if ([imageArray[i] isKindOfClass:[NSString class]]){
            [_images addObject:[UIImage imageNamed:@"等待占位图"]];
            [self downloadImages:i];

        }
    }
    self.currImageView.image = _images.firstObject;
    [self setscrollViewContentSize];
}
#pragma mark 设置描述数组
-(void)setDescribeArray:(NSArray *)describeArray{
    _describeArray = describeArray;
    //如果描述的个数与图片个数不一致,则补空字符串
    if (describeArray.count < _images.count) {
        NSMutableArray *descrines = [NSMutableArray arrayWithArray:describeArray];
        for (NSInteger i = describeArray.count; i<_images.count; i++) {
            [descrines addObject:@""];
        }
        _describeArray = descrines;
    }
    self.describLabel.hidden = NO;
    _describLabel.text = _describeArray.firstObject;
}
#pragma mark 设置scrollView的contentSize
-(void)setscrollViewContentSize{
    if (_images.count >1) {
        self.scrollView.contentSize = CGSizeMake(self.width * 3, 0);
        self.scrollView.contentOffset = CGPointMake(self.width, 0);
        self.currImageView.frame = CGRectMake(self.width, 0, self.width, self.height);
        [self startTimer];
    }else{
        self.scrollView.contentSize = CGSizeZero;
        self.scrollView.contentOffset = CGPointZero;
        self.currImageView.frame = CGRectMake(0, 0, self.width, self.height);
    }
}

#pragma mark 设置定时器时间
-(void)setTime:(NSTimeInterval)time{
    _time = time;
    [self startTimer];
}
#pragma mark- ----------定时器相关方法------------
-(void)startTimer{
    //如果只有一张图片,则直接返回,不开启定时器
    if (_images.count <= 1) return;
   //如果定时器已开启 先停止在重新开启
    if (self.timer) [self stopTimer];
    self.timer = [NSTimer timerWithTimeInterval:_time < 1? DEFAULTTIME:_time target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}
-(void)nextPage{
    [self.scrollView setContentOffset:CGPointMake(self.width * 2, 0) animated:YES];
}
#pragma mark- ---------其他 ----------
#pragma mark 布局子控件
-(void)layoutSubviews{
    [super layoutSubviews];
    //有导航控制器时, 会默认在scrollview上方添加64的内边距,这里强制设置为 0
    self.scrollView.contentInset = UIEdgeInsetsZero;
}
#pragma mark 图片点击事件
-(void)imageClick{
    if (self.imageClickBlock) {
        self.imageClickBlock(self.currIndex);
    }else if ([_delegate respondsToSelector:@selector(casrouselView:didClickImage:)]){
        [_delegate casrouselView:self didClickImage:self.currIndex];
    }
}

#pragma mark 下载网络图片
-(void)downloadImages:(int)index{
    NSString *key = _imageArray[index];
    //从内存缓冲中取图片
    UIImage *image = [self.imageDic objectForKey:key];
    if (image) {
        _images[index]  = image;
        return;
    }
    //从沙盒缓冲中去图片
    NSString *cache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"XRCarousel"];
    NSString *path = [cache stringByAppendingPathComponent:[key lastPathComponent]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data) {
        image = [UIImage imageWithData:data];
        _images[index] = image;
        [self.imageDic setObject:image forKey:key];
        return;
    }
    //下载图片
    NSBlockOperation *download = [self.operationDic objectForKey:key];
    if (download) return;
    download = [NSBlockOperation blockOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:key];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (!data) return ;
        UIImage *image = [UIImage imageWithData:data];
        //取到的data可能不是图片
        if (image) {
            [self.imageDic setObject:image forKey:key];
            self.images[index] = image;
            //如果下载的图片位当前要显示的图片,直接到主线程给imageView赋值,否则要等到下一轮才会显示
            if (_currIndex == index) {
                [_currImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
            }
            [data writeToFile:path atomically:YES];
        }
        [self.operationDic removeObjectForKey:key];
        
    }];
    [self.queue addOperation:download];
    [self.operationDic setObject:download forKey:key];
}
#pragma mark 清楚沙盒中图片的缓存
-(void)clearDiskCache{
    NSString *cache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"XRCarousel"];
    NSArray *contents = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:cache error:NULL];
    for (NSString *fileName in contents) {
        [[NSFileManager defaultManager]removeItemAtPath:[cache stringByAppendingPathComponent:fileName] error:nil];
    }
}

#pragma mark- --------UIScrollViewDelegate--------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    self.direction = offsetX > self.width ? DirecLeft :offsetX<self.width ? DirecRight:DirecNone;

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self pauseScroll];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self pauseScroll];
}

-(void)pauseScroll{
    //等于1表示没滚动
    if (self.scrollView.contentOffset.x / self.width == 1) return;
    self.currIndex = self.nextIndex;
    self.currImageView.frame = CGRectMake(self.width, 0, self.width, self.height);
    self.currImageView.image = self.otherImageView.image;
    self.scrollView.contentOffset = CGPointMake(self.width, 0);

}
@end



















