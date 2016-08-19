//
//  CourseScheduleViewController.m
//  APKit
//
//  Created by ChenYim on 16/4/14.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import "CourseScheduleViewController.h"

#import "APMSTitleView.h"
#import "APMSContentView.h"
#import "ChartEmptyView.h"

#import "CourseScheduleContentViewController.h"

@interface CourseScheduleViewController ()
<
    APMSTitleViewDataSource, APMSTitleViewDelegate,
    APMSContentViewDataSource, APMSContentViewDelegate
>
@property (nonatomic, strong) NSArray *MondaySchedule;
@property (nonatomic, strong) NSArray *TuesdaySchedule;
@property (nonatomic, strong) NSArray *WednesdaySchedule;
@property (nonatomic, strong) NSArray *ThursaySchedule;
@property (nonatomic, strong) NSArray *FridaySchedule;
@property (nonatomic, strong) NSArray *SaturdaySchedule;
@property (nonatomic, strong) NSArray *SundaySchedule;

@property (nonatomic, strong) APMSTitleView *titleView;
@property (nonatomic, strong) APMSContentView *contentView;

@property (nonatomic, strong) NSArray *titleInfoArry;
@property (nonatomic, strong) NSArray *contentInfoArry;

@property (nonatomic, assign) BOOL ifSetNavLeftPopback;
@property (nonatomic, assign) BOOL ifSetNavLeftOpenMenu;
@end

@implementation CourseScheduleViewController


#pragma mark - Setter & Getter
-(NSArray *)MondaySchedule
{
    if (nil == _MondaySchedule) {
        _MondaySchedule = @[
                            @{
                                @"idx":@"1",
                                @"time":@"08:00-09:00",
                                @"subject":@"语文"
                                },
                            @{
                                @"idx":@"2",
                                @"time":@"08:00-09:00",
                                @"subject":@"语文"
                                },
                            @{
                                @"idx":@"3",
                                @"time":@"08:00-09:00",
                                @"subject":@"语文"
                                },
                            @{
                                @"idx":@"4",
                                @"time":@"08:00-09:00",
                                @"subject":@"语文"
                                },
                            @{
                                @"idx":@"5",
                                @"time":@"08:00-09:00",
                                @"subject":@"语文"
                                },
                            @{
                                @"idx":@"6",
                                @"time":@"08:00-09:00",
                                @"subject":@"中午休息"
                                },
                            @{
                                @"idx":@"7",
                                @"time":@"08:00-09:00",
                                @"subject":@"语文"
                                },
                            @{
                                @"idx":@"8",
                                @"time":@"08:00-09:00",
                                @"subject":@"语文"
                                },
                            @{
                                @"idx":@"9",
                                @"time":@"08:00-09:00",
                                @"subject":@"语文"
                                },
                            @{
                                @"idx":@"10",
                                @"time":@"08:00-09:00",
                                @"subject":@"语文"
                                },
                            @{
                                @"idx":@"11",
                                @"time":@"08:00-09:00",
                                @"subject":@"语文"
                                }
                            ];
    }
    return _MondaySchedule;
}

-(NSArray *)TuesdaySchedule
{
    return self.MondaySchedule;
}

-(NSArray *)WednesdaySchedule
{
    return self.MondaySchedule;
}

-(NSArray *)ThursaySchedule
{
    return self.MondaySchedule;
}

-(NSArray *)FridaySchedule
{
    return self.MondaySchedule;
}

-(NSArray *)SaturdaySchedule
{
    return @[];
}

-(NSArray *)SundaySchedule
{
    return @[];
}

#pragma mark - IBAction
-(void)popBack:(id)sender
{
    NSArray *stackOfVC = self.navigationController.viewControllers;
    NSUInteger index = [stackOfVC indexOfObject:self];
    
    if (index == 0) {
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];;
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}

#pragma mark - Public Method

- (void)setNavLeft_Popback
{
    self.ifSetNavLeftPopback = YES;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.title = @"课程表";
    
    self.view.backgroundColor= [UIColor whiteColor];
    self.titleInfoArry = @[NSLocalizedString(@"Monday", nil),
                           NSLocalizedString(@"Tuesday", nil),
                           NSLocalizedString(@"Wednesday", nil),
                           NSLocalizedString(@"Thursay", nil),
                           NSLocalizedString(@"Friday", nil),
                           NSLocalizedString(@"Saturday", nil),
                           NSLocalizedString(@"Sunday", nil)];
   
    
    self.contentInfoArry = @[self.MondaySchedule, self.TuesdaySchedule, self.WednesdaySchedule,
                             self.ThursaySchedule, self.FridaySchedule, self.SaturdaySchedule, self.SundaySchedule];
    
    self.titleView = [[APMSTitleView alloc] initWithFrame:CGRectZero];
    self.contentView = [[APMSContentView alloc] initWithFrame:CGRectZero];
    self.titleView.titleViewDelegate = self;
    self.titleView.titleViewDataSource = self;
    self.contentView.contentViewDelegate = self;
    self.contentView.contentViewDataSource = self;
    
    [self.titleView setupDefaultSelectAnimation:YES];
    [self.titleView setupLeadingSpace:50 trailingSpace:50 intervalSpeace:10.0];
    [self.titleView setupIndicateViewToFlexibleWidth];
    
    [self.view addSubview:_titleView];
    [self.view addSubview:_contentView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.titleView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 40.0);
    self.contentView.frame = CGRectMake(0, 40.0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - 64 - 40);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.titleView loadData];
    [self.contentView loadData];
    
    self.titleView.contentSize = CGSizeMake(406.0, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - APMSTitleViewDelegate

- (void)msTitleView:(APMSTitleView *)titleView didSelectIndex:(NSInteger)index
{
    [self.contentView showSubViewAtIndex:index];
}

#pragma mark - APMSTitleViewDataSource

- (NSArray *)titlesForMSTitleView:(APMSTitleView *)titleView
{
    return self.titleInfoArry;
}

-(CGFloat)msTitleView:(APMSTitleView *)titleView normalFontSizeAtIndex:(NSInteger)index
{
    return 15.0;
}

-(CGFloat)msTitleView:(APMSTitleView *)titleView selectedFontSizeAtIndex:(NSInteger)index
{
    return 20.0;
}

- (UIColor *)msTitleView:(APMSTitleView *)titleView normalFontColorAtIndex:(NSInteger)index
{
    return [UIColor grayColor];
}

- (UIColor *)msTitleView:(APMSTitleView *)titleView selectedFontColorAtIndex:(NSInteger)index
{
    return [UIColor redColor];
}

#pragma mark - APMSContentDelegate

- (void)msContentView:(APMSContentView *)contentView showingSubViewHadChangedFromIndex:(NSInteger)fromIndex ToIndex:(NSInteger)toIndex
{
    [self.titleView selectTitleAtIndex:toIndex];
}

- (void)msContentView:(APMSContentView *)contentView scrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex persent:(CGFloat)persent
{
    [self.titleView willSelectTitleFromIndex:fromIndex toIndex:toIndex percent:persent];
}

#pragma mark - APMSContentDataSource

- (NSUInteger)numberOfViewControllersInContentView:(APMSContentView *)contentView
{
    return self.titleInfoArry.count;
}

- (UIViewController<ContentSubViewProtocol> *)msContentView:(APMSContentView *)contentView viewControllerAtIndex:(NSInteger)index
{
    NSArray *scheduleArry = _contentInfoArry[index];
    
    if (scheduleArry.count == 0) {
        CourseScheduleContentEmptyViewController *vc = [[CourseScheduleContentEmptyViewController alloc] init];
        return vc;
    }
    else{
        CourseScheduleContentViewController *vc = [[CourseScheduleContentViewController alloc] init];
        vc.scheduleArry = scheduleArry;
        return vc;
    }
}


@end
