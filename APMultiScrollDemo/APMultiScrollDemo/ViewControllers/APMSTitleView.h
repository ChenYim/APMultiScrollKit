//
//  APMSTitleView.h
//  APKit
//
//  Created by ChenYim on 16/4/14.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol APMSTitleViewDelegate;
@protocol APMSTitleViewDataSource;

@interface APMSTitleView : UIScrollView

@property (nonatomic, weak) id<APMSTitleViewDelegate> titleViewDelegate;
@property (nonatomic, weak) id<APMSTitleViewDataSource> titleViewDataSource;

@property (nonatomic, strong, readonly) NSArray *titlesArray;
@property (nonatomic, assign, readonly) NSInteger currSelectedIdx;

// provide a title-Animation when index change (default:NO)
- (void)setupDefaultSelectAnimation:(BOOL)ifNeedSelectAnimation;

// init titlesMargin(leading, trailing, interval)
- (void)setupLeadingSpace:(CGFloat)leadingSpace trailingSpace:(CGFloat)trailingSpace intervalSpeace:(CGFloat)intervalSpace;

// init IndicateView
- (void)setupIndicateViewWidth:(CGFloat)width Height:(CGFloat)height;
- (void)setupIndicateViewToFlexibleWidth;

- (void)loadData;
- (void)selectTitleAtIndex:(NSInteger)index;
- (void)willSelectTitleFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex percent:(CGFloat)percent;
@end


#pragma mark - Delegate
@protocol APMSTitleViewDelegate <NSObject>
@required
- (void)msTitleView:(APMSTitleView *)titleView didSelectIndex:(NSInteger)index;
@optional
- (void)msTitleView:(APMSTitleView *)titleView didChangeIndicateView:(UIView *)indicateView;
@end

#pragma mark - DataSource
@protocol APMSTitleViewDataSource <NSObject>
@required
// Titles
- (NSArray<NSString *> *)titlesForMSTitleView:(APMSTitleView *)titleView;
@optional
// TitleFont
- (CGFloat)msTitleView:(APMSTitleView *)titleView normalFontSizeAtIndex:(NSInteger)index;
- (CGFloat)msTitleView:(APMSTitleView *)titleView selectedFontSizeAtIndex:(NSInteger)index;
// TitleColor
- (UIColor *)msTitleView:(APMSTitleView *)titleView normalFontColorAtIndex:(NSInteger)index;
- (UIColor *)msTitleView:(APMSTitleView *)titleView selectedFontColorAtIndex:(NSInteger)index;
// TitleImage
- (UIImage *)msTitleView:(APMSTitleView *)titleView normalImageAtIndex:(NSInteger)index;
- (UIImage *)msTitleView:(APMSTitleView *)titleView selectImageAtIndex:(NSInteger)index;
@end
