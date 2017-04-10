//
//  TargetHomeViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/1/5.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetHomeViewController.h"
#import "TargetShowTableViewCell.h"
#import "TargetAddViewController.h"
#import "UIView+LoadFromNib.h"
#import "TargetShowModel.h"

@interface TargetHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<TargetShowModel *> *dataArray;
@end

@implementation TargetHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    self.title = @"Target";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self setupData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupData {
    TargetShowModel *model = [[TargetShowModel alloc] init];
    model.targetName = @"瑜伽";
    model.insistHours = @"17";
    model.insistDays = @"1";
    model.beginTime = @"2017年3月7日";
    self.dataArray = [NSMutableArray arrayWithObject:model];
}

- (void)setupViews {
    [self setupNavigation];
    self.view.backgroundColor = App_Bg;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight) style: UITableViewStylePlain];
    self.tableView.backgroundColor = App_Bg;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

- (void)setupNavigation {
    [self.navigationController setNavigationBarHidden:NO];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage: Default_Image style:UIBarButtonItemStylePlain target:self action:@selector(addItemAction)];
    self.navigationItem.rightBarButtonItem = addItem;
}

// 添加项目
- (void)addItemAction {
    [self jumpToTargetAddVC];
}

- (void)jumpToTargetAddVC {
    TargetAddViewController *vc = [TargetAddViewController new];
    vc.successAddTargetBlock = ^(TargetShowModel *newData) {
        [self.dataArray addObject:newData];
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

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UITableViewCellIdentifier";
    TargetShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [TargetShowTableViewCell loadFromNib];
    }
    cell.dataModel = self.dataArray[indexPath.section];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
@end
