//
//  TargetAddViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/16.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetAddViewController.h"
#import "TargetAddTableViewCell.h"
#import "UIView+LoadFromNib.h"

@interface TargetAddViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *configTableView;
@property (nonatomic, strong) UICollectionView *iconCollectionView;
@end

@implementation TargetAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}
- (void)setupViews {
    self.view.backgroundColor = App_Bg;
    self.configTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight) style: UITableViewStylePlain];
    self.configTableView.backgroundColor = App_Bg;
    self.configTableView.delegate = self;
    self.configTableView.dataSource = self;
    self.configTableView.tableFooterView = [UIView new];
    self.configTableView.scrollEnabled = NO;
    [self.view addSubview:self.configTableView];
}

- (void)addDoneNavigationItem {
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithImage: Default_Image style:UIBarButtonItemStylePlain target:self action:@selector(doneItemAction)];
    self.navigationItem.rightBarButtonItem = doneItem;
}

- (void)doneItemAction {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16.0;
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UITableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (indexPath.row == 0) {
        TargetAddTableViewCell *firstCell = [TargetAddTableViewCell loadFromNib];
        firstCell.iconImageView.image = Default_Image;
        firstCell.inputTextField.returnKeyType = UIReturnKeyDone;
        return firstCell;
    }
    if (!cell) {
        cell = [[TargetAddTableViewCell alloc] init];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"tool_icon_01"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
