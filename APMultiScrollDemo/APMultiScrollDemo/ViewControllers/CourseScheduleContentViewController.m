//
//  CourseScheduleContentViewController.m
//  APKit
//
//  Created by ChenYim on 16/4/13.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import "CourseScheduleContentViewController.h"

#import "CourseScheduleCell.h"
#import "ChartEmptyView.h"

#define GRIDLINE_HW (([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad)? 1.0 : (1.0 * [APUIKit sourceOfIPhone6Scale]))
#define GRID_H (49.0 * [APUIKit sourceOfIPhone6Scale])
#define GRID_COLUMN1_W (60.0 * [APUIKit sourceOfIPhone6Scale])
#define GRID_COLUMN2_W (127.0 * [APUIKit sourceOfIPhone6Scale])
#define GRID_COLUMN3_W [[UIScreen mainScreen] bounds].size.width - GRID_COLUMN1_W - GRID_COLUMN2_W - GRIDLINE_HW * 2

@interface CourseScheduleContentViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL didAddGrideVerticalLine;
@property (nonatomic, assign) BOOL didAddGrideHorizontalLine;
@end

static NSString * const CourseScheduleCellReuseID = @"CourseScheduleCellReuseID";

@implementation CourseScheduleContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[CourseScheduleCell class] forCellWithReuseIdentifier:CourseScheduleCellReuseID];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];

    
    self.didAddGrideVerticalLine = NO;
    self.didAddGrideHorizontalLine = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
//    CGRect bounds = self.view.bounds;
//    self.collectionView.frame = CGRectMake(0, 1, bounds.size.width, bounds.size.height);
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.collectionView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self drawCollectionViewGridLines];
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - ContentSubViewProtocol
-(void)msContentView:(APMSContentView *)contentView viewAtIndexDidAddToSuperView:(NSInteger)index
{
    
}

-(void)msContentView:(APMSContentView *)contentView viewAtIndexWillAppear:(NSInteger)index
{
    
}

-(void)msContentView:(APMSContentView *)contentView viewAtIndexWillDisappear:(NSInteger)index
{
    
}

#pragma mark - Private Method
- (void)drawCollectionViewGridLines
{
    NSInteger gridNum = self.scheduleArry.count * 3;
    NSInteger gridRowNum = 3;
    CGSize contentSize = self.collectionView.contentSize;
    
    if(_didAddGrideVerticalLine == NO) {
        
        // VerticalLine1
        CGRect rect1 = CGRectMake(GRID_COLUMN1_W, 0, GRIDLINE_HW, contentSize.height);
        UIView *verticalLine1 = [[UIView alloc]initWithFrame:rect1];
        verticalLine1.backgroundColor = [UIColor blackColor];
        verticalLine1.alpha = 0.1;
        [self.collectionView addSubview:verticalLine1];
        
        // VerticalLine2
        CGRect rect2 = CGRectMake(GRID_COLUMN1_W + GRIDLINE_HW + GRID_COLUMN2_W, 0, GRIDLINE_HW, contentSize.height);
        UIView *verticalLine2 = [[UIView alloc]initWithFrame:rect2];
        verticalLine2.backgroundColor = [UIColor blackColor];
        verticalLine2.alpha = 0.1;
        [self.collectionView addSubview:verticalLine2];

        _didAddGrideVerticalLine = YES;
    }
    
    if(_didAddGrideHorizontalLine == NO){
        
        for (NSInteger i = 0 ; i <= gridNum/gridRowNum ;i++) {
            UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0, GRID_H * i + GRIDLINE_HW * ((i-1) >= 0 ? (i - 1) : 0), contentSize.width, GRIDLINE_HW)];
            horizontalLine.backgroundColor = [UIColor blackColor];
            horizontalLine.alpha = 0.1;
            [self.collectionView addSubview:horizontalLine];
        }
        _didAddGrideHorizontalLine = YES;
    }
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _scheduleArry.count * 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CourseScheduleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CourseScheduleCellReuseID
                                                                         forIndexPath:indexPath];
    
    NSUInteger rowIdx = indexPath.row / 3;
    NSUInteger columnIdx = indexPath.row % 3;
    
    NSDictionary *singleSchedule = _scheduleArry[rowIdx];
    
    NSString *idxStr = singleSchedule[@"idx"];
    NSString *timeStr = singleSchedule[@"time"];
    NSString *subjectStr = singleSchedule[@"subject"];
    NSArray *arry = @[idxStr, timeStr, subjectStr];
    
    NSString *text = arry[columnIdx];
    cell.label.text = text;
    
    if (columnIdx == 0) {
        [cell setAppreanceStyleGray];
    }
    else{
        [cell setAppreanceStylWhite];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    switch (indexPath.row % 3) {
        case 0:
            size = CGSizeMake(GRID_COLUMN1_W, GRID_H);
            break;
        case 1:
            size = CGSizeMake(GRID_COLUMN2_W, GRID_H);
            break;
        case 2:{
            CGFloat width = MAINSCREEN_WIDTH - GRID_COLUMN1_W - GRID_COLUMN2_W - GRIDLINE_HW * 2 - 2;
            size = CGSizeMake(width, GRID_H);
        }
            break;
        default:
            break;
    }
    
    return size;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(10, 0, 0, 100);
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return GRIDLINE_HW;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return GRIDLINE_HW;
}

@end

@implementation CourseScheduleContentEmptyViewController
{
    ChartEmptyView *emptyView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (emptyView==nil) {
        emptyView = [ChartEmptyView CourseScheduleEmptyViewWithFrame:self.view.bounds];
        [self.view addSubview:emptyView];
    }
}

#pragma mark - ContentSubViewProtocol
-(void)msContentView:(APMSContentView *)contentView viewAtIndexDidAddToSuperView:(NSInteger)index
{
    
}

-(void)msContentView:(APMSContentView *)contentView viewAtIndexWillAppear:(NSInteger)index
{
    
}

-(void)msContentView:(APMSContentView *)contentView viewAtIndexWillDisappear:(NSInteger)index
{
    
}
@end