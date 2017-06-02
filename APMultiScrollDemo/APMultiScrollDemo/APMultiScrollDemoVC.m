//
//  ViewController.m
//  APMultiScrollDemo
//
//  Created by ChenYim on 16/8/17.
//  Copyright © 2016年 ChenYim. All rights reserved.
//

#import "APMultiScrollDemoVC.h"

#import "CourseScheduleViewController.h"
#import "CourseAnalysisMainVC.h"
#import "StageAnalysisMainVC.h"

#define DEFAULT_DATA nil

@interface APMultiScrollDemoVC ()
<
    UITableViewDataSource , UITableViewDelegate
>

@property (nonatomic, strong) NSArray *listNames;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation APMultiScrollDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.listNames = @[@"CourseSchedule",@"CourseAnalysis",@"StageAnalysis"];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


#pragma mark - 	UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellReuseIdentifier";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = _listNames[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    
    switch (row) {
        case 0:
        {
            CourseScheduleViewController *controller = [[CourseScheduleViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }break;
        case 1:
        {
            CourseAnalysisMainVC *controller = [[CourseAnalysisMainVC alloc] init];
            [controller setupCourseStaticsData:DEFAULT_DATA];
            [self.navigationController pushViewController:controller animated:YES];
        }break;
        case 2:
        {
            StageAnalysisMainVC *controller = [[StageAnalysisMainVC alloc] init];
            [controller setupStageStaticsData:DEFAULT_DATA];
            [self.navigationController pushViewController:controller animated:YES];
        }break;
            
        default:
            break;
    }
}
@end
