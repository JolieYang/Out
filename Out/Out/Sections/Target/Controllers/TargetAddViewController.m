//
//  TargetAddViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/3/16.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//
// [todo] 进入该页面时自动弹出键盘

#import "TargetAddViewController.h"
#import "IconTextFieldTableViewCell.h"
#import "MonoTextViewTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "TargetRecordAddLogTableViewCell.h"
#import "Target.h"
#import "TargetManager.h"
#import "DateHelper.h"
#import "UITextView+JY.h"

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
    self.title = @"创建Target";
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self customBackItemWithImageName:Gray_Nav_Back_Icon_Name action:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationController.navigationBar.barTintColor = System_Nav_White;
    [self setNavigationBarTitleColor:System_Nav_Gray];
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
    self.configTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.configTableView];
    [self addResignKeyboardGestures];
}

- (void)addDoneNavigationItem {
    [self customRightItemWithImageName:Gray_Nav_Check_Icon_Name action:^{
        [self doneItemAction];
    }];
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
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 220;
        } else {
            return 58;
        }
    } else if(indexPath.section == 1) {
        return 140;
    }else {
        return 0;
    }
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UITableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MonoTextViewTableViewCell *cell = [MonoTextViewTableViewCell loadFromNib];
            
            return cell;
        } else if (indexPath.row == 1) {
            TextFieldTableViewCell *cell = [TextFieldTableViewCell loadFromNib];
            cell.textField.placeholder = @"Target名称，如看电影，跑步";
            
            return cell;
        } else if(indexPath.row == 2) {
            TextFieldTableViewCell *cell = [TextFieldTableViewCell loadFromNib];
            cell.textField.placeholder = @"一句激励自己的话";
            
            return cell;
        } else {
            
        }
    } else if(indexPath.section == 1) {
        TargetRecordAddLogTableViewCell *cell = [TargetRecordAddLogTableViewCell loadFromNib];
        cell.logTextView.font = [UIFont systemFontOfSize:14.0];
        [cell.logTextView setPlaceHolder: @"描述这个Target"];
        
        return cell;
    } else {
        
        if (indexPath.row == 0) {
            IconTextFieldTableViewCell *firstCell = [IconTextFieldTableViewCell loadFromNib];
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
    }
    
    return cell;
}

- (Target *)addedTarget {
    return [TargetManager addTargetWithTargetName:self.targetName createUnix:[DateHelper getCurrentTimeInterval]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark Tool
- (void)enableDoneBtn {
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}
- (void)disableDoneBtn {
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

@end
