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
#import "RunningRecordManager.h"
#import "RunningWeekManager.h"
#import "RunningWeek.h"

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
    NSArray *recordsArray = [RunningRecordManager getRecordsWithWeekId:self.week.weekId];
    if (recordsArray.count == 0) {
        recordsArray = [RunningRecordManager addAllMembersRecordWithWeekId:self.week.weekId];
    }
    self.recordsArray = [NSMutableArray arrayWithArray:recordsArray];
}

- (void)addNavRightItem {
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:@"截图" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = titleItem;
}

- (void)rightItemAction {
    // 截图--自定义截屏位置大小
    [self sreenShotTableView];
}

- (BOOL)sreenShotTableView {
    UIImage* image = nil;
    UIGraphicsBeginImageContext(self.tableView.contentSize);
//    UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, YES, 0.0);
    
    //保存tableView当前的偏移量
    CGPoint savedContentOffset = self.tableView.contentOffset;
    CGRect saveFrame = self.tableView.frame;
    
    //将tableView的偏移量设置为(0,0)
    self.tableView.contentOffset = CGPointZero;
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.contentSize.width, self.tableView.contentSize.height);
    
    //在当前上下文中渲染出tableView
    [self.tableView.layer renderInContext: UIGraphicsGetCurrentContext()];
    //截取当前上下文生成Image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    //恢复tableView的偏移量
    self.tableView.contentOffset = savedContentOffset;
    self.tableView.frame = saveFrame;
    
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
        return YES;
    }else {
        return NO;
    }
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
        NSString *fromDate = [self timeStringFromUnix:self.week.fromUnix];
        NSString *endDate = [self timeStringFromUnix:self.week.endUnix];
        NSString *title = [NSString stringWithFormat:@"%ld月第%ld周(%@~%@)", (long)self.week.month, (long)self.week.weekOfMonth, fromDate, endDate];
        RunningRecordTitleTableViewCell *cell = [RunningRecordTitleTableViewCell initWithTitle: title];
        return cell;
    } else if (indexPath.section == 1) {
        RunningRecordColumnTableViewCell *cell = [RunningRecordColumnTableViewCell loadFromNib];
        return cell;
    } else if (indexPath.section == 2) {
        RunningMemberRecordTableViewCell *cell = [[RunningMemberRecordTableViewCell alloc] initWithDataModel:self.recordsArray[indexPath.row]];
        cell.updateContributionBlock = ^(NSInteger preContributionMoney, NSInteger contributionMoney) {
            NSInteger currentWeekContribution = self.week.weekContribution + (contributionMoney - preContributionMoney);
            self.week = [RunningWeekManager updateContributionWithWeekId:self.week.weekId weekContribution: currentWeekContribution];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
        };
        return cell;
    } else if (indexPath.section == 3) {
        NSInteger sum;
        if (indexPath.row == 0) {
            sum = self.week.weekContribution;
        } else if (indexPath.row == 1) {
            sum = self.week.preSumContribution;
        } else {
            sum = self.week.sumContribution;
        }
        RunningRecordFundsTableViewCell *cell = [[RunningRecordFundsTableViewCell alloc] initWithTitle:fundsTitleArray[indexPath.row] sum:sum];
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

#pragma mark Date Tool
- (NSString *)timeStringFromUnix:(NSTimeInterval)unix {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy.MM.dd"];
    NSString *timeString = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:unix]];
    return timeString;
}

- (NSString *)timeStringFromDate:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd:HH:ss"];
    NSString *timeString = [df stringFromDate:[NSDate date]];
    return timeString;
    
}
@end
