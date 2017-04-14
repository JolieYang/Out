//
//  TargetAddRecordViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetAddRecordViewController.h"
#import "TargetRecordLogTableViewCell.h"
#import "HcdDateTimePickerView.h"
#import "TargetRecordInsistHoursTableViewCell.h"
#import "Target.h"
#import "TargetRecord.h"
#import "TargetManager.h"
#import "TargetRecordManager.h"
#import "UIView+loadFromNib.h"

@interface TargetAddRecordViewController ()<UITableViewDelegate, UITableViewDataSource> {
    HcdDateTimePickerView *dateTimePickerView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) float insistHours;
@property (nonatomic, strong) NSString *datetimeStr;
@property (nonatomic, strong) NSString *log;
@end

@implementation TargetAddRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupDatas];
    [self setupViews];
}

- (void)setupViews {
    self.title = self.target.targetName;
    [self addNavRightItem];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupDatas {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNavRightItem {
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:@"添加纪录" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = titleItem;
    [self enabledRightItem:NO];
}

- (void)rightItemAction {
    // 添加纪录
    self.target = [TargetRecordManager addTargetRecordAndReturnTargetWithTarget:self.target insistHours:self.insistHours log:self.log];
    if (self.updateTargetBlock) {
        self.updateTargetBlock(self.target);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)enabledRightItem:(BOOL)enabled {
    self.navigationItem.rightBarButtonItem.enabled = enabled;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else if (indexPath.section == 1) {
        return 140;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // todo 先判断键盘是否打开，打开则先回收键盘，未打开则显示时间选择器
        [self.view endEditing:YES];
        [self showHourMinutePickerView];
    }
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TargetRecordInsistHoursTableViewCell *cell = [TargetRecordInsistHoursTableViewCell loadFromNib];
        if (self.datetimeStr) {
            NSArray *array = [self.datetimeStr componentsSeparatedByString:@":"];
            NSInteger hour = [array[0] integerValue];
            NSInteger minute = [array[1] integerValue];
            if (hour == 0 && minute == 0) {
                cell.insistHoursLable.text = @"坚持了多久";
                cell.insistHoursLable.textColor = [UIColor lightGrayColor];
            } else {
                cell.insistHoursLable.text = [NSString stringWithFormat:@"坚持了%ld小时%ld分钟", (long)hour, (long)minute];
                cell.insistHoursLable.textColor = [UIColor blackColor];
            }
        } else {
            cell.insistHoursLable.text = @"坚持了多久";
        }
        
        return cell;
    } else if (indexPath.section == 1) {
         TargetRecordLogTableViewCell *cell = [TargetRecordLogTableViewCell loadFromNib];
        
        return cell;
    } else {
        static NSString *identifier = @"UITableViewCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark -- 小时分钟选择器
- (void)showHourMinutePickerView {
    if (!dateTimePickerView) {
        dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerHourMinuteMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:0]];
    }
    __weak typeof(self) weakSelf = self;
    dateTimePickerView.clickedOkBtn = ^(NSString *datetimeStr) {// 00:38
        weakSelf.datetimeStr = datetimeStr;
        NSArray *array = [datetimeStr componentsSeparatedByString:@":"];
        NSInteger hour = [array[0] integerValue];
        NSInteger minute = [array[1] integerValue];
        weakSelf.insistHours = [[NSString stringWithFormat:@"%.1f", (float)(hour+minute/60)] floatValue];
        if (weakSelf.insistHours > 0) {
            // 才可添加纪录
            [weakSelf enabledRightItem:YES];
        } else {
            [weakSelf enabledRightItem:NO];
        }
        [weakSelf.tableView reloadData];
    };
    [self.view addSubview:dateTimePickerView];
    [dateTimePickerView showHcdDateTimePicker];
}

@end
