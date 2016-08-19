//
//  CourseAnalysisViewController.h
//  APKit
//
//  Created by ChenYim on 16/4/19.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "APMSContentView.h"

@interface CourseAnalysisViewController : UIViewController
<
    ContentSubViewProtocol
>

- (instancetype)initWithAnalysisData:(NSArray *)analysisData Title:(NSString *)title;

@end


@interface CourseAnalysisEmptyViewController : UIViewController
<
    ContentSubViewProtocol
>


@end