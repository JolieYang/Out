//
//  RunningWeekViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningWeekViewController.h"
#import "UIView+LoadFromNib.h"
#import "RunningRecordTitleTableViewCell.h"
#import "RunningRecordColumnTableViewCell.h"
#import "RunningMemberRecordTableViewCell.h"
#import "RunningRecordFundsTableViewCell.h"
#import "RunningRecordManager.h"
#import "RunningWeekManager.h"
#import "RunningWeek.h"

static NSString *recordTitleTableViewCellIdentifier = @"RunningMemberRecordColumnTitleTableViewCell";
static NSString *recordTableViewCellIdentifier = @"RunningMemberRecordTableViewCell";
static NSArray *fundsTitleArray = nil;

@interface RunningWeekViewController ()<UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *recordsArray;
@end

@implementation RunningWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupViews];
    [self setupDatas];
}

- (void)setupViews {
    [self addNavRightItem];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setupDatas {
    fundsTitleArray = @[@"当前经费", @"上期经费", @"累计经费"];
    NSArray *recordsArray = [RunningRecordManager getRecordsWithWeekId:self.week.weekId];
    if (recordsArray.count == 0) {
        recordsArray = [RunningRecordManager addAllMembersRecordWithWeekId:self.week.weekId];
    }
    self.recordsArray = [NSMutableArray arrayWithArray:recordsArray];
}

- (void)addNavRightItem {
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:@"归档" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = titleItem;
}

- (void)rightItemAction {
    // 归档
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 8.0;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 36;
    } else if (indexPath.section == 1) {
        return 36;
    } else {
        return 32;
    }
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *fromDate = [self timeStringFromUnix:self.week.fromUnix];
        NSString *endDate = [self timeStringFromUnix:self.week.endUnix];
        NSString *title = [NSString stringWithFormat:@"%ld月第%ld周(%@~%@)", (long)self.week.month, (long)self.week.weekOfMonth, fromDate, endDate];
        RunningRecordTitleTableViewCell *cell = [RunningRecordTitleTableViewCell initWithTitle: title];
        return cell;
    } else if (indexPath.section == 1) {
        RunningRecordColumnTableViewCell *cell = [RunningRecordColumnTableViewCell loadFromNib];
        return cell;
    } else if (indexPath.section == 2) {
        RunningMemberRecordTableViewCell *cell = [[RunningMemberRecordTableViewCell alloc] initWithDataModel:self.recordsArray[indexPath.row]];
        cell.updateContributionBlock = ^(NSInteger preContributionMoney, NSInteger contributionMoney) {
            NSInteger currentWeekContribution = self.week.weekContribution + (contributionMoney - preContributionMoney);
            self.week = [RunningWeekManager updateContributionWithWeekId:self.week.weekId weekContribution: currentWeekContribution];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
        };
        return cell;
    } else if (indexPath.section == 3) {
        NSInteger sum;
        if (indexPath.row == 0) {
            sum = self.week.weekContribution;
        } else if (indexPath.row == 1) {
            sum = self.week.preSumContribution;
        } else {
            sum = self.week.sumContribution;
        }
        RunningRecordFundsTableViewCell *cell = [[RunningRecordFundsTableViewCell alloc] initWithTitle:fundsTitleArray[indexPath.row] sum:sum];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return self.recordsArray.count;
    } else if (section == 3) {
        return fundsTitleArray.count;
    }else {
        return 0;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark Date Tool
- (NSString *)timeStringFromUnix:(NSTimeInterval)unix {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy.MM.dd"];
    NSString *timeString = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:unix]];
    return timeString;
}
@end
