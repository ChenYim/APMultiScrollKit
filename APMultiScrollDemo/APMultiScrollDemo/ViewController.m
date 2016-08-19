//
//  ViewController.m
//  APMultiScrollDemo
//
//  Created by ChenYim on 16/8/17.
//  Copyright © 2016年 ChenYim. All rights reserved.
//

#import "ViewController.h"

#import "CourseScheduleViewController.h"
#import "CourseAnalysisMainVC.h"
#import "StageAnalysisMainVC.h"

#define DEFAULT_DATA nil

@interface ViewController ()
<
    UITableViewDataSource , UITableViewDelegate
>

@property (nonatomic, strong) NSArray *listNames;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.listNames = @[@"CourseSchedule",@"CourseAnalysis",@"StageAnalysis"];
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
