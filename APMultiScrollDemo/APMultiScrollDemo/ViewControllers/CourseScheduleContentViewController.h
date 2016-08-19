//
//  CourseScheduleContentViewController.h
//  APKit
//
//  Created by ChenYim on 16/4/13.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "APMSContentView.h"

@interface CourseScheduleContentViewController : UIViewController
<
    ContentSubViewProtocol
>

@property (nonatomic, strong) NSArray *scheduleArry;
@end

@interface CourseScheduleContentEmptyViewController : UIViewController
<
    ContentSubViewProtocol
>
@end