//
//  CourseAnalysisContentView.h
//  APKit
//
//  Created by ChenYim on 16/4/18.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SADEF_PADDING_TOP   (([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad)? 35.0 : (32.0*[APUIKit sourceOfIPhone6Scale]))

#define SADEF_GRID_ColumnNum (_titleArry.count+1)

#define SADEF_GRID_WIDTH  (48.0*[APUIKit sourceOfIPhone6Scale] * 6.0/SADEF_GRID_ColumnNum)
#define SADEF_GRID_HEIGHT  (26.0*[APUIKit sourceOfIPhone6Scale])
#define SADEF_GRID_LINEWIDTH 1.0

#define SADEF_TEXTFONT1 (([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad)? [UIFont systemFontOfSize:13.0] : [UIFont systemFontOfSize:9.0])
#define SADEF_TEXTFONT2 (([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad)? [UIFont systemFontOfSize:16.0] : [UIFont systemFontOfSize:10.0])

#define SADEF_TITLE_Y_PaddingRight  (5.0*[APUIKit sourceOfIPhone6Scale])
#define SADEF_TITLE_X_PaddingTop  (5.0*[APUIKit sourceOfIPhone6Scale])
#define SADEF_TITLE_O_PaddingTop  (8.0*[APUIKit sourceOfIPhone6Scale])

@interface StageAnalysisContentView : UIView

- (instancetype)initWithData:(NSArray<NSNumber *> *)dataArry TitleArry:(NSArray<NSString *> *)titleArry;

@end
