//
//  RunningViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/10.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningViewController.h"
#import "RunningWeekViewController.h"
#import "RunningMember.h"
#import "RunningWeek.h"
#import "RunningWeekManager.h"

static NSArray *initRunningMembers = nil;

@interface RunningViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *weeksList;
@end

@implementation RunningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupViews];
    [self setupDatas];
}

- (void)setupViews {
    self.title = @"跑团";
    [self addNavRightItem];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
}

- (void)addNavRightItem {
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:@"下一周" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = titleItem;
}
- (void)rightItemAction {
    //  下一周
    [RunningWeekManager weekFirstDayUnix];
}
- (void)setupDatas {
    self.weeksList = [NSMutableArray array];
    [self.weeksList addObject:@"2017年04月--W1"];
//    [self runningMember];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// first -- 初始化跑团成员
- (void)runningMember {
    initRunningMembers = @[@"孙宇翔", @"沈聪维", @"陈炜枫",@"陈明智",@"陈双",@"黄佳萍",@"杨巧伶",@"范本清",@"李旭东",@"苏忠伟",@"林思颖",@"叶金新",@"唐尧",@"曾佑杰",@"陈文静",@"刘文迪",@"赵赫",@"张波",@"林善统",@"池如海",@"王丽仙"];
    for (int i = 0; i < initRunningMembers.count; i++) {
        RunningMember *member = [[RunningMember alloc] init];
        member.memberId = i + 1;
        member.name = initRunningMembers[i];
        [member save];
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RunningWeekViewController *vc = [[RunningWeekViewController alloc] initWithNibName:NSStringFromClass([RunningWeekViewController class]) bundle:nil];
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
    cell.textLabel.text = self.weeksList[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.weeksList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
