//
//  CourseAnalysisContentView.h
//  APKit
//
//  Created by ChenYim on 16/4/19.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CADEF_PADDING_LEFT  (63.0*[APUIKit sourceOfIPhone6Scale])
#define CADEF_PADDING_TOP  (33.0*[APUIKit sourceOfIPhone6Scale])

#define CADEF_TITLE_Y_PaddingRight  (5.0*[APUIKit sourceOfIPhone6Scale])
#define CADEF_TITLE_X_PaddingTop  (5.0*[APUIKit sourceOfIPhone6Scale])
#define CADEF_TITLE_O_PaddingTop  (8.0*[APUIKit sourceOfIPhone6Scale])

#define CADEF_GRID_WIDTH  (26.0*[APUIKit sourceOfIPhone6Scale])
#define CADEF_GRID_HEIGHT  (15.0*[APUIKit sourceOfIPhone6Scale])
#define CADEF_GRIDLINE_WIDTH  (1.0*[APUIKit sourceOfIPhone6Scale])
#define CADEF_GRIDLINE_COLOR [UIColor colorWithWhite:0.0 alpha:0.1]
#define CADEF_GRID_COLOR1 [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]

@interface CourseAnalysisContentView : UIView

- (instancetype)initWithData:(NSArray *)dataArry;

@end
