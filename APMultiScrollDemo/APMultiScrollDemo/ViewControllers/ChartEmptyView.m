//
//  ChartEmptyView.m
//  APKit
//
//  Created by ChenYim on 16/4/22.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import "ChartEmptyView.h"

#define CEVDEF_IMAGEVIEW_W 100.0
#define CEVDEF_IMAGEVIEW_H 100.0

#define CEVDEF_TITLELABEL_PADDING 18.0

@interface ChartEmptyView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLab;
@end


@implementation ChartEmptyView

#pragma mark - Public Method

+ (ChartEmptyView *)CourseScheduleEmptyViewWithFrame:(CGRect)frame
{
    ChartEmptyView *view =  [[ChartEmptyView alloc] initWithFrame:frame image:[UIImage imageNamed:@"icon_coffe"] title:@"没有课程安排"];
    return view;
}

+ (ChartEmptyView *)CourseAnalysisEmptyViewWithFrame:(CGRect)frame
{
    ChartEmptyView *view =  [[ChartEmptyView alloc] initWithFrame:frame image:[UIImage imageNamed:@"icon_textpage"] title:@"分析数据还未生成"];
    return view;
}

+ (ChartEmptyView *)StagetAnalysisEmptyViewWithFrame:(CGRect)frame
{
    ChartEmptyView *view =  [[ChartEmptyView alloc] initWithFrame:frame image:[UIImage imageNamed:@"icon_textpage"] title:@"分析数据还未生成"];
    return view;
}

#pragma mark - Private Method

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)img title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.image = img;
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLab.text = title;
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.font = [UIFont systemFontOfSize:14.0];
        self.titleLab.textColor = [UIColor ap_colorWithHexStr:@"929292" alpha:1.0];
        [self.titleLab sizeToFit];
        
        [self addSubview:_imageView];
        [self addSubview:_titleLab];
    }
    return self;
}

-(void)layoutSubviews
{
    CGFloat frameHeight = CGRectGetHeight(self.frame);
    CGFloat componentHeight = CEVDEF_IMAGEVIEW_W + CGRectGetHeight(_titleLab.frame) + CEVDEF_TITLELABEL_PADDING;
    
    CGFloat y = (frameHeight - componentHeight)/2.0;
    
    self.imageView.frame = CGRectMake(0, y, CEVDEF_IMAGEVIEW_W, CEVDEF_IMAGEVIEW_H);
    self.imageView.center = CGPointMake(self.frame.size.width/2, self.imageView.center.y);

    self.titleLab.frame = CGRectMake((self.frame.size.width - self.titleLab.frame.size.width)/2.0, CGRectGetMaxY(_imageView.frame)+CEVDEF_TITLELABEL_PADDING, self.titleLab.frame.size.width, self.titleLab.frame.size.height);
}

@end
