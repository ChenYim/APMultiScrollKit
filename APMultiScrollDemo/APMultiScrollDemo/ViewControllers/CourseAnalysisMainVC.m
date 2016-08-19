//
//  CourseAnalysisMainVC.m
//  APKit
//
//  Created by ChenYim on 16/4/20.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import "CourseAnalysisMainVC.h"

#import "APMSTitleView.h"
#import "APMSContentView.h"
#import "ChartEmptyView.h"

#import "CourseAnalysisViewController.h"

@interface CourseAnalysisMainVC ()
<
    APMSTitleViewDataSource,
    APMSTitleViewDelegate,
    APMSContentViewDataSource,
    APMSContentViewDelegate
>
@property (nonatomic, strong) APMSTitleView *titleView;
@property (nonatomic, strong) UIView *titleViewSeparator;
@property (nonatomic, strong) APMSContentView *contentView;

@property (nonatomic, strong) NSArray *titleInfoArry;
@property (nonatomic, strong) NSArray *contentInfoArry;
@end

@implementation CourseAnalysisMainVC

#pragma mark - Public Method
- (void)setupCourseStaticsData:(NSArray *)courseStaticsData{
    self.contentInfoArry = courseStaticsData;
}

- (NSArray *)getContentInfArryData
{
    return @[
             @[@{@"subject":@"语文",@"value":@"52"},
               @{@"subject":@"数学",@"value":@"88"},
               @{@"subject":@"英语",@"value":@"67"},
               @{@"subject":@"物理",@"value":@"100"},
               @{@"subject":@"化学",@"value":@"74"},
               @{@"subject":@"生物",@"value":@"88"},
               @{@"subject":@"计算机",@"value":@"46"},
               @{@"subject":@"音乐",@"value":@"83"},
               @{@"subject":@"美术",@"value":@"52"},
               @{@"subject":@"语文",@"value":@"52"},
               @{@"subject":@"数学",@"value":@"88"},
               @{@"subject":@"英语",@"value":@"67"},
               @{@"subject":@"物理",@"value":@"100"},
               @{@"subject":@"化学",@"value":@"74"},
               @{@"subject":@"生物",@"value":@"88"},
               @{@"subject":@"计算机",@"value":@"46"},
               @{@"subject":@"音乐",@"value":@"83"},
               @{@"subject":@"美术",@"value":@"52"}],
             @[@{@"subject":@"语文",@"value":@"52"},
               @{@"subject":@"数学",@"value":@"88"},
               @{@"subject":@"英语",@"value":@"67"},
               @{@"subject":@"物理",@"value":@"100"},
               @{@"subject":@"化学",@"value":@"74"},
               @{@"subject":@"生物",@"value":@"88"},
               @{@"subject":@"计算机",@"value":@"46"},
               @{@"subject":@"音乐",@"value":@"83"},
               @{@"subject":@"美术",@"value":@"52"},
               @{@"subject":@"语文",@"value":@"52"},
               @{@"subject":@"数学",@"value":@"88"},
               @{@"subject":@"英语",@"value":@"67"},
               @{@"subject":@"物理",@"value":@"100"},
               @{@"subject":@"化学",@"value":@"74"},
               @{@"subject":@"生物",@"value":@"88"},
               @{@"subject":@"计算机",@"value":@"46"},
               @{@"subject":@"音乐",@"value":@"83"},
               @{@"subject":@"美术",@"value":@"52"}],
             @[]];
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor= [UIColor whiteColor];
    
    self.titleInfoArry = @[@"近一周", @"近一个月", @"本学期"];
    self.contentInfoArry = [self getContentInfArryData];
    
    self.titleView = [[APMSTitleView alloc] initWithFrame:CGRectZero];
    self.contentView = [[APMSContentView alloc] initWithFrame:CGRectZero];
    
    self.titleView.titleViewDelegate = self;
    self.titleView.titleViewDataSource = self;
    self.contentView.contentViewDelegate = self;
    self.contentView.contentViewDataSource = self;
    
    [self.view addSubview:_titleView];
    [self.view addSubview:_contentView];
    
    self.titleViewSeparator = [[UIView alloc] initWithFrame:CGRectZero];
    self.titleViewSeparator.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    [self.view addSubview:_titleViewSeparator];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat topMargin = self.view.frame.origin.y;
    self.titleView.frame = CGRectMake(0, topMargin, MAINSCREEN_WIDTH, 40.0);
    self.titleViewSeparator.frame = CGRectMake(0, CGRectGetMaxY(_titleView.frame), MAINSCREEN_WIDTH, 1.0);
    self.contentView.frame = CGRectMake(0, CGRectGetMaxY(_titleViewSeparator.frame), MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - 64 - 40);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.titleView loadData];
    [self.contentView loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = NSLocalizedString(@"Course analysis", nil);
//    [self ap_initNavBarLeftItem:APBarBackBtn(@"返回", 1)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction
-(void)popBack:(id)sender
{
    NSArray *stackOfVC = self.navigationController.viewControllers;
    NSUInteger index = [stackOfVC indexOfObject:self];
    
    if (index == 0) {
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];;
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - APMSTitleViewDelegate

- (void)msTitleView:(APMSTitleView *)titleView didSelectIndex:(NSInteger)index
{
    [self.contentView showSubViewAtIndex:index];
}

#pragma mark - APMSTitleViewDataSource

- (NSArray *)titlesForMSTitleView:(APMSTitleView *)titleView
{
    return self.titleInfoArry;
}

-(CGFloat)msTitleView:(APMSTitleView *)titleView normalFontSizeAtIndex:(NSInteger)index
{
    return 15.0;
}

-(CGFloat)msTitleView:(APMSTitleView *)titleView selectedFontSizeAtIndex:(NSInteger)index
{
    return 15.0;
}

- (UIColor *)msTitleView:(APMSTitleView *)titleView normalFontColorAtIndex:(NSInteger)index
{
    return [UIColor colorWithRed:37/255.0 green:183/255.0 blue:188/255.0 alpha:1.0];
}

- (UIColor *)msTitleView:(APMSTitleView *)titleView selectedFontColorAtIndex:(NSInteger)index
{
    return [UIColor colorWithRed:37/255.0 green:183/255.0 blue:188/255.0 alpha:1.0];
}

#pragma mark - APMSContentDelegate

- (void)msContentView:(APMSContentView *)contentView showingSubViewHadChangedFromIndex:(NSInteger)fromIndex ToIndex:(NSInteger)toIndex
{
    [self.titleView selectTitleAtIndex:toIndex];
}

- (void)msContentView:(APMSContentView *)contentView scrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex persent:(CGFloat)persent
{
    [self.titleView willSelectTitleFromIndex:fromIndex toIndex:toIndex percent:persent];
}

#pragma mark - APMSContentDataSource

- (NSUInteger)numberOfViewControllersInContentView:(APMSContentView *)contentView
{
    return self.titleInfoArry.count;
}

- (UIViewController<ContentSubViewProtocol> *)msContentView:(APMSContentView *)contentView viewControllerAtIndex:(NSInteger)index
{
    NSArray *analysisData = _contentInfoArry[index];
    NSString *title = _titleInfoArry[index];
    
    if (analysisData.count == 0) {
        CourseAnalysisEmptyViewController *vc = [[CourseAnalysisEmptyViewController alloc] init];
        return vc;
    }
    else{
        CourseAnalysisViewController *vc = [[CourseAnalysisViewController alloc] initWithAnalysisData:analysisData Title:title];
        return vc;
    }
}
@end

