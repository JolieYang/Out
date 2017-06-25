//
//  TargetAddRecordViewController.m
//  Spider
//
//  Created by Jolie_Yang on 2017/4/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetAddRecordViewController.h"
#import "TargetLogsViewController.h"
#import "TextViewTableViewCell.h"
#import "HcdDateTimePickerView.h"
#import "TargetRecordInsistHoursTableViewCell.h"
#import "Target.h"
#import "TargetRecord.h"
#import "TargetManager.h"
#import "TargetRecordManager.h"
#import "UIViewController+JY.h"
#import "UITextView+JY.h"

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

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = System_Nav_Black;
    [self setNavigationBarTitleColor:System_Nav_White];
    
    self.title = self.target.targetName;
    [self customBackItemWithImageName:White_Back_Icon_Name action:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self addNavRightItem];
}

// 跳转到Log页面
- (IBAction)logAction:(id)sender {
    TargetLogsViewController *vc = [[TargetLogsViewController alloc] init];
    vc.target = self.target;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupViews {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addResignKeyboardGestures];
}

- (void)setupDatas {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNavRightItem {
    [self customRightItemsWithFirstImageName:White_Detail_Icon_Name action:^{
        // 详情页面
    } secondImageName:White_Check_Icon_Name action:^{
        // 添加
        [self rightItemAction];
    }];
    [self enabledRightItem:NO];
}

- (void)rightItemAction {
    // 添加纪录
    TextViewTableViewCell *cell = self.tableView.visibleCells[1];
    self.log = cell.textView.text;
    
    self.target = [TargetRecordManager addTargetRecordAndReturnTargetWithTarget:self.target insistHours:self.insistHours log:self.log];
    if (self.updateTargetBlock) {
        self.updateTargetBlock(self.target);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 4.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else if (indexPath.section == 1) {
        return 120;
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
                cell.insistHoursLable.textColor = Apple_Gold;
            } else {
                cell.insistHoursLable.text = [NSString stringWithFormat:@"坚持了%ld小时%ld分钟", (long)hour, (long)minute];
                cell.insistHoursLable.textColor = [UIColor blackColor];
            }
        } else {
            cell.insistHoursLable.text = @"坚持了多久";
        }
        
        return cell;
    } else {
         TextViewTableViewCell *cell = [TextViewTableViewCell loadFromNib];
        [cell.textView setPlaceHolder:@"输入你想说的"];
        
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
        dateTimePickerView.topViewColor = HourMinute_Bg;
    }
    __weak typeof(self) weakSelf = self;
    dateTimePickerView.clickedOkBtn = ^(NSString *datetimeStr) {// 00:38
        weakSelf.datetimeStr = datetimeStr;
        NSArray *array = [datetimeStr componentsSeparatedByString:@":"];
        NSInteger hour = [array[0] integerValue];
        NSInteger minute = [array[1] integerValue];
        weakSelf.insistHours = [[NSString stringWithFormat:@"%.1f",(hour+(float)minute/60)] floatValue];
        if (weakSelf.insistHours > 0) {
            // 才可添加纪录
            [weakSelf enabledRightItem:YES];
        } else {
            [weakSelf enabledRightItem:NO];
        }
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.view addSubview:dateTimePickerView];
    [dateTimePickerView showHcdDateTimePicker];
}

@end
