//
//  CourseAnalysisViewController.m
//  APKit
//
//  Created by ChenYim on 16/4/19.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import "CourseAnalysisViewController.h"

#import "CourseAnalysisContentView.h"
#import "ChartEmptyView.h"

#define CADEF_TITLE_PADDING (([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad)? 20.0 : (20.0*[APUIKit sourceOfIPhone6Scale]))

@interface CourseAnalysisViewController ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) CourseAnalysisContentView *contentView;
@property (nonatomic, strong) NSArray *analysisData;
@property (nonatomic, copy) NSString *titleStr;


@end

@implementation CourseAnalysisViewController

- (instancetype)initWithAnalysisData:(NSArray *)analysisData Title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.analysisData = analysisData;
        self.titleStr = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLab.font = [UIFont systemFontOfSize:17.0];
    self.titleLab.textColor = [UIColor blackColor];
    self.titleLab.text = [NSString stringWithFormat:@"%@%@",_titleStr,NSLocalizedString(@"Course analysis", nil)];
    [self.view addSubview:_titleLab];
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_contentScrollView];
    
    self.contentView = [[CourseAnalysisContentView alloc] initWithData:_analysisData];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:_contentView];
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.titleLab sizeToFit];
    self.titleLab.center = CGPointMake(MAINSCREEN_WIDTH / 2.0, CADEF_TITLE_PADDING + CGRectGetHeight(_titleLab.frame)/2);
    
    CGFloat contentView_Y = CGRectGetMaxY(_titleLab.frame);
    self.contentScrollView.frame = CGRectMake(0, contentView_Y, MAINSCREEN_WIDTH , CGRectGetHeight(self.view.frame) - contentView_Y);
    
    CGSize contentSize = CGSizeMake(MAINSCREEN_WIDTH, _analysisData.count*(CADEF_GRID_HEIGHT*2 + 1) + CADEF_PADDING_TOP);
    [self.contentScrollView setContentSize:contentSize];
    self.contentView.frame = CGRectMake(0, 0, contentSize.width,contentSize.height);
    
    _contentView.layer.borderWidth = 1.0;
    _contentView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ContentSubViewProtocol
-(void)msContentView:(APMSContentView *)contentView viewAtIndexDidAddToSuperView:(NSInteger)index
{
    
}

-(void)msContentView:(APMSContentView *)contentView viewAtIndexWillAppear:(NSInteger)index
{
    
}

-(void)msContentView:(APMSContentView *)contentView viewAtIndexWillDisappear:(NSInteger)index
{
    
}
@end

@implementation CourseAnalysisEmptyViewController
{
    ChartEmptyView *emptyView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (emptyView==nil) {
         emptyView = [ChartEmptyView CourseAnalysisEmptyViewWithFrame:self.view.bounds];
        [self.view addSubview:emptyView];
    }
}

#pragma mark - ContentSubViewProtocol
-(void)msContentView:(APMSContentView *)contentView viewAtIndexDidAddToSuperView:(NSInteger)index
{
    
}

-(void)msContentView:(APMSContentView *)contentView viewAtIndexWillAppear:(NSInteger)index
{
    
}

-(void)msContentView:(APMSContentView *)contentView viewAtIndexWillDisappear:(NSInteger)index
{
    
}
@end

