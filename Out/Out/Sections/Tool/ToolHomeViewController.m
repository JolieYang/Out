//
//  HomeViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "ToolHomeViewController.h"
#import "ScanViewController.h"
#import "ScanDemoViewController.h"
#import "ScanResultViewController.h"
#import "RunningViewController.h"

@interface ToolHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ToolHomeViewController
static NSArray *TOOL_TTTLE = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    TOOL_TTTLE = @[@[@"扫一扫", @"跑团"]];
    TOOL_TTTLE = @[@[@"跑团"]];
    [self configView];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configView {
    self.title = @"Tool";
    self.view.backgroundColor = Table_Bg;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 取消cell被选中的状态
            [self jumpToRunning];
        } else if (indexPath.row == 1) {
        } else if (indexPath.row == 2) {
        } else {
            
        }
    }
}

- (void)jumpToRunning {
    RunningViewController *vc = [RunningViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToScan {
    ScanViewController *vc = [ScanViewController new];
    vc.hidesBottomBarWhenPushed = YES;
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
    cell.textLabel.text = TOOL_TTTLE[indexPath.section][indexPath.row];
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"running_icon"];
    } else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"scan_icon"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"tab_icon_01_normal"];
    }
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowsTitle = TOOL_TTTLE[section];
    return rowsTitle.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TOOL_TTTLE.count;
}

@end
