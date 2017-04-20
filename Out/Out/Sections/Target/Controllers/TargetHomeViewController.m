//
//  TargetHomeViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/1/5.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetHomeViewController.h"
#import "TargetAddRecordViewController.h"
#import "TargetLogsViewController.h"
#import "TargetShowTableViewCell.h"
#import "TargetAddViewController.h"
#import "TargetManager.h"
#import "Target.h"
#import "TargetRecordManager.h"

@interface TargetHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<Target *> *targetList;
@end

@implementation TargetHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.tableView reloadData];
    self.title = @"Target";
    self.navigationController.navigationBar.barTintColor = System_Nav_Black;
    [self setNavigationBarTitleColor:System_Nav_White];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self setupData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupData {
    self.targetList = [NSMutableArray arrayWithArray:[TargetManager getTargetList]];
}

- (void)setupViews {
    [self setupNavigation];
    self.view.backgroundColor = App_Bg;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight - kTabbarHeight - kNavigationBarHeight - kStatusHeight) style: UITableViewStylePlain];
    self.tableView.backgroundColor = App_Bg;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

- (void)setupNavigation {
    [self.navigationController setNavigationBarHidden:NO];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItemAction)];
    self.navigationItem.rightBarButtonItem = addItem;
}

// 添加项目
- (void)addItemAction {
    [self jumpToTargetAddVC];
}

- (void)jumpToTargetAddVC {
    TargetAddViewController *vc = [TargetAddViewController new];
    vc.successAddTargetBlock = ^(Target *newData) {
        [self.targetList addObject:newData];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TargetAddRecordViewController *addRecordVC = [[TargetAddRecordViewController alloc] init];
    addRecordVC.hidesBottomBarWhenPushed = YES;
    addRecordVC.target = self.targetList[indexPath.section];
    addRecordVC.updateTargetBlock = ^(Target *target) {
        [self.targetList removeObjectAtIndex:indexPath.section];
        [self.targetList insertObject:target atIndex:0];
    };
    [self.navigationController pushViewController:addRecordVC animated:YES];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UITableViewCellIdentifier";
    TargetShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [TargetShowTableViewCell loadFromNib];
    }
    cell.dataModel = self.targetList[indexPath.section];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.targetList.count;
}
@end
