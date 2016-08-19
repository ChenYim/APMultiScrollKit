//
//  CourseAnalysisViewController.m
//  APKit
//
//  Created by ChenYim on 16/4/18.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import "StageAnalysisViewController.h"

#import "StageAnalysisContentView.h"
#import "ChartEmptyView.h"

#define SADEF_TITLE_PADDING (([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad)? 35.0 : (35.0*[APUIKit sourceOfIPhone6Scale]))



@interface StageAnalysisViewController ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) StageAnalysisContentView *contentView;
@property (nonatomic, strong) NSArray *analysisData;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) NSArray *coordinateAxesTitles;


@end

@implementation StageAnalysisViewController

- (instancetype)initWithAnalysisData:(NSArray *)analysisData Title:(NSString *)title CoordinateAxesTitle:(NSArray <NSString *>*)coordinateAxesTitles
{
    self = [super init];
    if (self) {
        self.analysisData = analysisData;
        self.titleStr = title;
        self.coordinateAxesTitles = coordinateAxesTitles;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLab.font = [UIFont systemFontOfSize:17.0];
    self.titleLab.textColor = [UIColor blackColor];
    self.titleLab.text = [NSString stringWithFormat:@"%@%@",_titleStr,@"阶段分析"];
    [self.view addSubview:_titleLab];
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_contentScrollView];
    
    self.contentView = [[StageAnalysisContentView alloc] initWithData:self.analysisData TitleArry:_coordinateAxesTitles];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:_contentView];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.titleLab sizeToFit];
    self.titleLab.center = CGPointMake(MAINSCREEN_WIDTH / 2.0, SADEF_TITLE_PADDING + CGRectGetHeight(_titleLab.frame)/2);
    
//    CGFloat contentView_Y = CGRectGetMaxY(_titleLab.frame);
//    self.contentView.frame = CGRectMake(0, contentView_Y, MAINSCREEN_WIDTH , CGRectGetHeight(self.view.frame) - contentView_Y);
//    self.contentView.center = CGPointMake(MAINSCREEN_WIDTH / 2.0, self.contentView.center.y);

    CGFloat contentView_Y = CGRectGetMaxY(_titleLab.frame);
    self.contentScrollView.frame = CGRectMake(0, contentView_Y, MAINSCREEN_WIDTH , CGRectGetHeight(self.view.frame) - contentView_Y);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGSize textSize = [@"第一周" sizeWithFont:SADEF_TEXTFONT2];
#pragma clang diagnostic pop
    
    CGSize contentSize = CGSizeMake(MAINSCREEN_WIDTH, SADEF_GRID_HEIGHT*10 + SADEF_GRID_LINEWIDTH*11 + SADEF_PADDING_TOP + textSize.height+SADEF_TITLE_O_PaddingTop);
    [self.contentScrollView setContentSize:contentSize];
    self.contentView.frame = CGRectMake(0, 0, contentSize.width,contentSize.height);
    
    if (!IPAD_DEVICE) {
        self.contentScrollView.scrollEnabled = NO;
    }
    
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

@implementation StageAnalysisViewEmptyController
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
        emptyView = [ChartEmptyView StagetAnalysisEmptyViewWithFrame:self.view.bounds];
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
