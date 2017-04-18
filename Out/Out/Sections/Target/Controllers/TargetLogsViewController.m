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
#import "Target.h"

@interface TargetLogsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
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
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)setupDatas {
    self.dataArray = @[@"hello", @"hell"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 8;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 210;
    } else if (indexPath.section == 1) {
        if (indexPath.row == self.dataArray.count - 1) {
            return 38;
        } else {
            return 128;
        }
    } else {
        return 44;
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
        if (indexPath.row == self.dataArray.count - 1) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"已显示全部内容";
            
            return cell;
        } else {
            TargetLogShowTableViewCell *cell = [TargetLogShowTableViewCell loadFromNib];
            
            return cell;
        }
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
    if (section == 0) {
        return 1;
    } else {
        return self.dataArray.count + 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

@end
