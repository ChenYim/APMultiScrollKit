//
//  CourseScheduleCell.m
//  APKit
//
//  Created by ChenYim on 16/4/13.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import "CourseScheduleCell.h"

@implementation CourseScheduleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.font = [UIFont systemFontOfSize:15.0];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}

-(void)layoutSubviews
{
    self.label.frame = self.bounds;
}

- (void)setAppreanceStyleGray
{
    self.label.textColor = [UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0];
    self.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
}

- (void)setAppreanceStylWhite
{
    self.label.textColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    self.backgroundColor = [UIColor whiteColor];
}
@end
