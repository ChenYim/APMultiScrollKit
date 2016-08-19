//
//  APMSContentView.h
//  APKit
//
//  Created by ChenYim on 16/4/14.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol APMSContentViewDelegate;
@protocol APMSContentViewDataSource;

@interface APMSContentView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, weak) id<APMSContentViewDelegate> contentViewDelegate;
@property (nonatomic, weak) id<APMSContentViewDataSource> contentViewDataSource;

@property (nonatomic, readonly) NSNumber *currentShowingVCIndex;
@property (nonatomic, readonly) NSInteger numberOfSubViewsInContentView;
@property (nonatomic, strong, readonly) NSMutableDictionary *subViewControllersDic; // 以index为key的所有controller

- (void)loadData;
- (void)showSubViewAtIndex:(NSInteger)index;

@end

#pragma mark - ContentSubViewProtocol

@protocol ContentSubViewProtocol <NSObject>
- (void)msContentView:(APMSContentView *)contentView viewAtIndexDidAddToSuperView:(NSInteger)index;
- (void)msContentView:(APMSContentView *)contentView viewAtIndexWillAppear:(NSInteger)index;
- (void)msContentView:(APMSContentView *)contentView viewAtIndexWillDisappear:(NSInteger)index;
@end

#pragma mark - Delegate

@protocol APMSContentViewDelegate <NSObject>
@required
- (void)msContentView:(APMSContentView *)contentView showingSubViewHadChangedFromIndex:(NSInteger)fromIndex ToIndex:(NSInteger)toIndex;
@optional
- (void)msContentView:(APMSContentView *)contentView scrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex persent:(CGFloat)persent;
@end

#pragma mark - DataSource

@protocol APMSContentViewDataSource <NSObject>
@required
- (NSUInteger)numberOfViewControllersInContentView:(APMSContentView *)contentView;
@optional
- (UIViewController<ContentSubViewProtocol> *)msContentView:(APMSContentView *)contentView viewControllerAtIndex:(NSInteger)index;
@end
