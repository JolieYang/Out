//
//  TargetAddViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/16.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//
// [todo] 进入该页面时自动弹出键盘

#import "TargetAddViewController.h"
#import "TargetAddTableViewCell.h"
#import "UIView+LoadFromNib.h"
#import "Target.h"
#import "TargetManager.h"
#import "DateHelper.h"

@interface TargetAddViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString *targetName;
@property (nonatomic, strong) UITableView *configTableView;
@property (nonatomic, strong) UICollectionView *iconCollectionView;
@end

@implementation TargetAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addDoneNavigationItem];
    [self disableDoneBtn];
    [self becomeFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
    // 添加项目
    if (self.successAddTargetBlock) {
        self.successAddTargetBlock([self addedTarget]);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
        firstCell.textFieldReturnBlock = ^(NSString *text) {
            [self.view endEditing:YES];
        };
        firstCell.textFieldDidChangeBlock = ^(NSString *text) {
            self.targetName = text;
            if (text.length > 0) {
                [self enableDoneBtn];
            } else {
                [self disableDoneBtn];
            }
        };
        return firstCell;
    }
    if (!cell) {
        cell = [TargetAddTableViewCell reusableCellWithTableView:tableView];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"tool_icon_01"];
    
    return cell;
}

- (Target *)addedTarget {
    return [TargetManager addTargetWithTargetName:self.targetName createUnix:[DateHelper getCurrentTimeInterval]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark Tool
- (void)enableDoneBtn {
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}
- (void)disableDoneBtn {
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

@end
