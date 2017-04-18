//
//  TargetLogsViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/18.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetLogsViewController.h"
#import "TargetLogHeaderTableViewCell.h"
#import "TargetLogShowTableViewCell.h"
#import "CenterTitleTableViewCell.h"
#import "Target.h"
#import "TargetRecordManager.h"
#import "TargetRecord.h"

@interface TargetLogsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray<TargetRecord *> *dataArray;
@end

@implementation TargetLogsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupDatas];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)setupViews {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -100, kAppWidth, kAppHeight+kStatusHeight)];
    bgView.backgroundColor = Apple_Black;
    [self.view addSubview:bgView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)setupDatas {
    self.dataArray = [TargetRecordManager getLogRecordWithTargetId:self.target.targetId];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        return 8;
    } else if (section == 2) {
        return 0;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 210;
    } else if (indexPath.section == 1) {
        return 128;
    } else {
        return 38;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TargetLogHeaderTableViewCell *cell = [TargetLogHeaderTableViewCell loadFromNib];
        cell.targetNameLable.text = self.target.targetName;
        cell.insistHoursLabel.text = [NSString stringWithFormat:@"- 坚持了%d小时 -", (int)self.target.insistHours];
        cell.remarksLabel.text = self.target.remarks == nil? @"暂无描述" : self.target.remarks;
        cell.popBlock = ^(){
            [self.navigationController popViewControllerAnimated:YES];
        };
        
        return cell;
    } else if (indexPath.section == 1) {
        TargetRecord *record = self.dataArray[indexPath.row];
        TargetLogShowTableViewCell *cell = [TargetLogShowTableViewCell initWithTargetRecord:record];
        
        return cell;
    } else {
        CenterTitleTableViewCell *cell = [CenterTitleTableViewCell loadFromNib];
        cell.titleLabel.text = @"已显示全部内容";
        cell.titleLabel.textColor = Apple_Silver;
        cell.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        return cell;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return self.dataArray.count;
    } else {
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

@end
