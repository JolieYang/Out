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
    self.recordsArray = [NSMutableArray array];
    for (int i = 0; i < 23; i++) {
        RunningRecord *model = [RunningRecord new];
        model.memberName = @"花木兰";
        [self.recordsArray addObject:model];
    }
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
        RunningRecordTitleTableViewCell *cell = [RunningRecordTitleTableViewCell initWithTitle:@"04月第一周(2017.04.03~2017.04.09)"];
        return cell;
    } else if (indexPath.section == 1) {
        RunningRecordColumnTableViewCell *cell = [RunningRecordColumnTableViewCell loadFromNib];
        return cell;
    } else if (indexPath.section == 2) {
        RunningMemberRecordTableViewCell *cell = [[RunningMemberRecordTableViewCell alloc] initWithDataModel:self.recordsArray[indexPath.row]];
        return cell;
    } else if (indexPath.section == 3) {
        RunningRecordFundsTableViewCell *cell = [[RunningRecordFundsTableViewCell alloc] initWithTitle:fundsTitleArray[indexPath.row] sum:50];
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

@end
