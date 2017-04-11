//
//  RunningViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningViewController.h"
#import "RunningWeekViewController.h"
#import "RunningMember.h"
#import "RunningWeek.h"
#import "RunningWeekManager.h"

@interface RunningViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *weeksList;
@end

@implementation RunningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupViews];
    [self setupDatas];
}

- (void)setupViews {
    self.title = @"跑团";
    [self addNavRightItem];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
}

- (void)addNavRightItem {
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:@"下一周" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = titleItem;
}
- (void)rightItemAction {
    //  下一周
    [RunningWeekManager updateData];
    NSArray *newRecords = [RunningWeekManager addWeekRecord];
    if (newRecords) {
        [self.weeksList addObjectsFromArray:newRecords];
        [self.tableView reloadData];
    } else {
        // 弹窗显示时间未到，无法添加新纪录
    }
}
- (void)setupDatas {
    self.weeksList = [NSMutableArray arrayWithArray:[RunningWeekManager getRecentTwentyWeekRecords]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RunningWeekViewController *vc = [[RunningWeekViewController alloc] initWithNibName:NSStringFromClass([RunningWeekViewController class]) bundle:nil];
    vc.week = self.weeksList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UITableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    RunningWeek *weekRecord = self.weeksList[indexPath.row];
    NSString *recordTitle = [NSString stringWithFormat:@"%li年%li月第%li周", (long)weekRecord.year, (long)weekRecord.month, (long)weekRecord.weekOfMonth];
    cell.textLabel.text = recordTitle;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.weeksList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
