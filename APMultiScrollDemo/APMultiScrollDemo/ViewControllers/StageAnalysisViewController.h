//
//  CourseAnalysisViewController.h
//  APKit
//
//  Created by ChenYim on 16/4/18.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "APMSContentView.h"

@interface StageAnalysisViewController : UIViewController
<
    ContentSubViewProtocol
>
- (instancetype)initWithAnalysisData:(NSArray *)analysisData Title:(NSString *)title CoordinateAxesTitle:(NSArray <NSString *>*)coordinateAxesTitles;

@end

@interface StageAnalysisViewEmptyController : UIViewController
<
    ContentSubViewProtocol
>
@end