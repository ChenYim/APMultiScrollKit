//
//  ChartEmptyView.h
//  APKit
//
//  Created by ChenYim on 16/4/22.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartEmptyView : UIView

+ (ChartEmptyView *)CourseScheduleEmptyViewWithFrame:(CGRect)frame;
+ (ChartEmptyView *)CourseAnalysisEmptyViewWithFrame:(CGRect)frame;
+ (ChartEmptyView *)StagetAnalysisEmptyViewWithFrame:(CGRect)frame;

@end