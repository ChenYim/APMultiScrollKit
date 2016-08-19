//
//  StageAnalysisMainVC.m
//  APKit
//
//  Created by ChenYim on 16/4/20.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import "StageAnalysisMainVC.h"

#import "APMSTitleView.h"
#import "APMSContentView.h"

#import "StageAnalysisViewController.h"

@interface StageAnalysisMainVC ()
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

@implementation StageAnalysisMainVC

#pragma mark - Public Method

- (void)setupStageStaticsData:(NSArray *)stageStaticsData{
    self.contentInfoArry = stageStaticsData;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor= [UIColor whiteColor];
    
    self.titleInfoArry =   @[
                             @{@"近五周":@[@"第一周",@"第二周",@"第三周",@"上周",@"本周"]},
                             @{@"近五个月":@[@"第一个月",@"第二个月",@"第三个月",@"上个月",@"本月"]},
                             @{@"近三个学期":@[@"第一学期",@"上学期",@"本学期"]}
                             ];
    
    self.contentInfoArry = @[@[@"20",@"50",@"30",@"80",@"50"],@[@"18",@"50",@"53",@"84",@"24"],@[@"20",@"95",@"20"]];
    
    self.titleView = [[APMSTitleView alloc] initWithFrame:CGRectZero];
    self.contentView = [[APMSContentView alloc] initWithFrame:CGRectZero];
    
    self.titleView.titleViewDelegate = self;
    self.titleView.titleViewDataSource = self;
    self.contentView.contentViewDelegate = self;
    self.contentView.contentViewDataSource = self;

    [self.titleView setupDefaultSelectAnimation:YES];
    [self.titleView setupIndicateViewWidth:0.0 Height:39.0];
    [self.titleView setupIndicateViewToFlexibleWidth];
    
    [self.view addSubview:_titleView];
    [self.view addSubview:_contentView];
    
    
    self.titleViewSeparator = [[UIView alloc] initWithFrame:CGRectZero];
    self.titleViewSeparator.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    [self.view addSubview:_titleViewSeparator];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.titleView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 40.0);
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
    
    self.navigationItem.title = NSLocalizedString(@"Stage analysis", nil);
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
- (void)popBack:(id)sender
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
    NSMutableArray *titles = [NSMutableArray new];
    for (NSDictionary *dic in _titleInfoArry) {
        [titles addObject:[[dic allKeys] objectAtIndex:0]];
    }
    
    return titles;
}

-(void)msTitleView:(APMSTitleView *)titleView didChangeIndicateView:(UIView *)indicateView
{
    CGFloat centerX = indicateView.center.x;
    CGRect frame = indicateView.frame;
    indicateView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width+10, frame.size.height);
    indicateView.center = CGPointMake(centerX, _titleView.frame.size.height/2);
    
    indicateView.layer.cornerRadius = CGRectGetHeight(indicateView.frame)/3.0;
    indicateView.layer.masksToBounds = YES;
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
    return [UIColor grayColor];
}

- (UIColor *)msTitleView:(APMSTitleView *)titleView selectedFontColorAtIndex:(NSInteger)index
{
    return [UIColor colorWithWhite:1.0 alpha:1.0];
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
    NSArray  *analysisData = _contentInfoArry[index];
    
    NSDictionary *dic = _titleInfoArry[index];
    NSString *title = [[dic allKeys] objectAtIndex:0];
    NSArray  *coordinateAxesTitle = [[dic allValues] objectAtIndex:0];
    
    if (analysisData.count == 0) {
        StageAnalysisViewEmptyController *vc = [[StageAnalysisViewEmptyController alloc] init];
        return vc;

    }
    else{
        StageAnalysisViewController *vc = [[StageAnalysisViewController alloc] initWithAnalysisData:analysisData Title:title CoordinateAxesTitle:coordinateAxesTitle];
        return vc;
    }
}

@end
