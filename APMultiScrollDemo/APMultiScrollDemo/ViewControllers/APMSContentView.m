//
//  APMSContentView.m
//  APKit
//
//  Created by ChenYim on 16/4/14.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import "APMSContentView.h"

@interface APMSContentView()
{
    CGFloat currentSubViewCount;
    BOOL isDragMadeScroll;
}

@property (nonatomic) NSNumber *currentShowingVCIndex;
@property (nonatomic) NSInteger numberOfSubViewsInContentView;
@property (nonatomic, strong) NSMutableDictionary *subViewControllersDic;

@end

@implementation APMSContentView

#pragma mark - Wrapper

- (NSNumber *)currentShowingVCIndex
{
    if (nil == _currentShowingVCIndex)
    {
        _currentShowingVCIndex = @(-1);
    }
    return _currentShowingVCIndex;
}

- (NSMutableDictionary *)subViewControllersDic
{
    if (_subViewControllersDic == nil)
    {
        _subViewControllersDic = [NSMutableDictionary dictionaryWithCapacity:self.numberOfSubViewsInContentView];
    }
    return _subViewControllersDic;
}

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

#pragma mark - Public Method

// 载入左中右三个视图
- (void)showSubViewAtIndex:(NSInteger)index
{
    NSInteger leftIndex = index - 1;
    NSInteger rightIndex = index + 1;
    BOOL isFromDic;
    
    // Left
    if (leftIndex >= 0 && leftIndex < self.numberOfSubViewsInContentView && [self.contentViewDataSource respondsToSelector:@selector(msContentView:viewControllerAtIndex:)])
    {
        [self getSubViewControllerAtIndex:leftIndex isFromDic:&isFromDic];
    }
    
    // Middle
    if (index >= 0 && index < self.numberOfSubViewsInContentView && [self.contentViewDataSource respondsToSelector:@selector(msContentView:viewControllerAtIndex:)])
    {
        UIViewController<ContentSubViewProtocol> *middleVC = (UIViewController<ContentSubViewProtocol> *)[self getSubViewControllerAtIndex:index isFromDic:&isFromDic];
        
        // 给上一个ViewController发送viewWillDisappear
        UIViewController<ContentSubViewProtocol> *oldVC= nil;
        if ([self.currentShowingVCIndex integerValue] != index)
        {
            oldVC = (UIViewController<ContentSubViewProtocol> *)[self getSubViewControllerAtIndex:[self.currentShowingVCIndex integerValue] isFromDic:&isFromDic];
            [self callSubViewController:oldVC viewAtIndexWillDisappear:[self.currentShowingVCIndex integerValue]];
        }
        
        // 给新VC发送ViewWillAppear
        [self callSubViewController:middleVC viewAtIndexWillAppear:index];
        
        self.currentShowingVCIndex = @(index);
        
        // 跳转到选中的页面
        [self setContentOffset:CGPointMake(middleVC.view.frame.origin.x, middleVC.view.frame.origin.y) animated:YES];
    }
    
    // Right
    if (rightIndex >= 0 && rightIndex < self.numberOfSubViewsInContentView && [self.contentViewDataSource respondsToSelector:@selector(msContentView:viewControllerAtIndex:)])
    {
        [self getSubViewControllerAtIndex:rightIndex isFromDic:&isFromDic];
    }
}

- (void)loadData
{
    // clearSubViews
    for(id key in [self.subViewControllersDic allKeys])
    {
        UIViewController *subViewController = self.subViewControllersDic[key];
        [subViewController removeFromParentViewController];
        [subViewController.view removeFromSuperview];
    }
    [self.subViewControllersDic removeAllObjects];
    [self setContentSize:CGSizeZero];
    
    // Request numbersOfViewControllersInContentView
    self.numberOfSubViewsInContentView = [self requestNumberOfViewControllersInContentView];
    if (self.numberOfSubViewsInContentView > 0)
    {
        [self setContentSize:CGSizeMake(self.numberOfSubViewsInContentView * self.bounds.size.width, 0)];
        [self showSubViewAtIndex:0];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isDragMadeScroll = NO;
    
    NSInteger oldIndex = [self.currentShowingVCIndex integerValue];
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    int index = currentOffsetX / self.bounds.size.width;
    
    if ([self.currentShowingVCIndex integerValue] != index)
    {
        [self showSubViewAtIndex:index];
    }
    
    [self callDelegate_showingSubViewHadChangedFromIndex:oldIndex toIndex:index];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isDragMadeScroll = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isDragMadeScroll)
    {
        CGFloat currentOffsetX = scrollView.contentOffset.x;
        CGFloat deltaX = currentOffsetX - ([self.currentShowingVCIndex integerValue] * self.bounds.size.width);
        CGFloat percent = fabs(deltaX) / self.bounds.size.width;
        NSInteger toIndex = [self.currentShowingVCIndex integerValue];
        
        if (deltaX > 0)
        {
            toIndex ++;
        }
        else if(deltaX < 0)
        {
            toIndex --;
        }
        else
        {
            
        }
        
        [self callDelegate_ScrollFromIndex:[self.currentShowingVCIndex integerValue] toIndex:toIndex percent:percent];
    }
}

#pragma mark - Request APMSContentDataSource

- (NSInteger)requestNumberOfViewControllersInContentView
{
    NSInteger numOfControllers = 0;
    if ([self.contentViewDataSource respondsToSelector:@selector(numberOfViewControllersInContentView:)])
    {
        numOfControllers = [self.contentViewDataSource numberOfViewControllersInContentView:self];
    }
    return numOfControllers;
}

- (UIViewController<ContentSubViewProtocol> *)requestViewControllerInMSContentViewAtIndex:(NSInteger)index
{
    UIViewController<ContentSubViewProtocol> * vc = nil;
    if ([self.contentViewDataSource respondsToSelector:@selector(msContentView:viewControllerAtIndex:)])
    {
        vc = [self.contentViewDataSource msContentView:self viewControllerAtIndex:index];
    }
    return vc;
}

#pragma mark - Call APMSContentDelegate

- (void)callDelegate_showingSubViewHadChangedFromIndex:(NSInteger)fromIdx toIndex:(NSInteger)toIdx
{
    if ([self.contentViewDelegate respondsToSelector:@selector(msContentView:showingSubViewHadChangedFromIndex:ToIndex:)])
    {
        [self.contentViewDelegate msContentView:self showingSubViewHadChangedFromIndex:fromIdx ToIndex:toIdx];
    }
}

- (void)callDelegate_ScrollFromIndex:(NSInteger)fromIdx toIndex:(NSInteger)toIdx percent:(CGFloat)percent
{
    if ([self.contentViewDelegate respondsToSelector:@selector(msContentView:scrollFromIndex:toIndex:persent:)])
    {
        [self.contentViewDelegate msContentView:self scrollFromIndex:fromIdx toIndex:toIdx persent:percent];
    }
}

#pragma mark - Call SubViewController
- (void)callSubViewController:(UIViewController <ContentSubViewProtocol> *)subViewController viewAtIndexDidAddToSuperView:(NSInteger)index
{
    if (subViewController && [subViewController respondsToSelector:@selector(msContentView:viewAtIndexDidAddToSuperView:)])
    {
        [subViewController msContentView:self viewAtIndexDidAddToSuperView:index];
    }
}

- (void)callSubViewController:(UIViewController <ContentSubViewProtocol> *)subViewController viewAtIndexWillAppear:(NSInteger)index
{
    if (subViewController && [subViewController respondsToSelector:@selector(msContentView:viewAtIndexWillAppear:)])
    {
        [subViewController msContentView:self viewAtIndexWillAppear:index];
    }
}

- (void)callSubViewController:(UIViewController <ContentSubViewProtocol> *)subViewController viewAtIndexWillDisappear:(NSInteger)index
{
    if (subViewController && [subViewController respondsToSelector:@selector(msContentView:viewAtIndexWillDisappear:)])
    {
        [subViewController msContentView:self viewAtIndexWillDisappear:index];
    }
}

#pragma mark - Private Method

- (void)setup
{
    self.delegate = self;
    self.scrollEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.directionalLockEnabled = YES;
    
    currentSubViewCount = 0;
}

// 获取vc，添加到subViewControllersDic和subview
- (UIViewController *)getSubViewControllerAtIndex:(NSInteger)index isFromDic:(BOOL*)isFromDic
{
    * isFromDic = NO;
    
    if (index < 0 || index >= self.numberOfSubViewsInContentView)
    {
        NSLog(@"APMSContentView getSubViewControllerAtIndex: isFromDic: >>> Index Overflow");
        return nil;
    }
    
    NSNumber *key = @(index);
    UIViewController<ContentSubViewProtocol> *vc = self.subViewControllersDic[key];
    
    if (vc == nil)
    {
        vc = [self requestViewControllerInMSContentViewAtIndex:index];
        [self.subViewControllersDic setObject:vc forKey:key];
       
        if (self.contentViewDelegate)
        {
            [((UIViewController *)self.contentViewDelegate) addChildViewController:vc];
            vc.view.frame = CGRectMake(index * self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
            [self addSubview:vc.view];
            
            [self callSubViewController:vc viewAtIndexDidAddToSuperView:index];
        }
    }
    else
    {
        * isFromDic = YES;
    }
    
    return vc;
}

@end

