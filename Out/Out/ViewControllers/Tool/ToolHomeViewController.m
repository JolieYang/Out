//
//  HomeViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "ToolHomeViewController.h"
#import "ScanViewController.h"
#import "ScanResultViewController.h"

@interface ToolHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ToolHomeViewController
static NSArray *TOOL_TTTLE = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TOOL_TTTLE = @[@[@"天气预报", @"扫一扫"]];
    [self configView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configView {
    self.title = @"Tool";
    self.view.backgroundColor = UIColorFromRGB(0xF1F3F5);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self configTableView];
}
- (void)configTableView {
//    self.tableView.backgroundColor =
//    self.tableView.tableFooterView = [UIView alloc] initW
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            ScanViewController *vc = [ScanViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UITableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"tool_icon_01"];
    cell.textLabel.text = TOOL_TTTLE[indexPath.section][indexPath.row];
    
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
