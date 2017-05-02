//
//  RunningAddMemberViewController.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/18.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "RunningAddMemberViewController.h"
#import "IconTextFieldTableViewCell.h"
#import "RunningMemberManager.h"
#import "StringHelper.h"

@interface RunningAddMemberViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString *memberName;
@property (nonatomic, strong) UITableView *configTableView;
@end

@implementation RunningAddMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addDoneNavigationItem];
    [self disableDoneBtn];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)setupViews {
    self.title = @"添加成员";
    self.view.backgroundColor = App_Bg;
    self.configTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, kAppHeight) style: UITableViewStylePlain];
    self.configTableView.backgroundColor = App_Bg;
    self.configTableView.delegate = self;
    self.configTableView.dataSource = self;
    self.configTableView.scrollEnabled = NO;
    self.configTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.configTableView];
    
    [self addResignKeyboardGestures];
}

- (void)addDoneNavigationItem {
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithImage: Default_Image style:UIBarButtonItemStylePlain target:self action:@selector(doneItemAction)];
    self.navigationItem.rightBarButtonItem = doneItem;
}

- (void)doneItemAction {
    BOOL successAdd = [self addRunningMember];
    // 添加项目
    if (self.successAddRunningMemberBlock && successAdd) {
        self.successAddRunningMemberBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    
    if (indexPath.row == 0) {
        IconTextFieldTableViewCell *firstCell = [IconTextFieldTableViewCell loadFromNib];
        firstCell.iconImageView.image = Default_Image;
        firstCell.inputTextField.returnKeyType = UIReturnKeyDone;
        firstCell.inputTextField.placeholder = @"请输入成员名称";
        firstCell.textFieldReturnBlock = ^(NSString *text) {
            [self.view endEditing:YES];
        };
        firstCell.textFieldDidChangeBlock = ^(NSString *text) {
            self.memberName = text;
            if (text.length > 0) {
                [self enableDoneBtn];
            } else {
                [self disableDoneBtn];
            }
        };
        return firstCell;
    } else {
        static NSString *identifier = @"UITableViewCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [IconTextFieldTableViewCell reusableCellWithTableView:tableView];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"tool_icon_01"];
        
        return cell;
    }
}

- (BOOL)addRunningMember {
    NSString *memberName = [StringHelper trim:self.memberName];
    if (memberName.length > 0) {
        return [RunningMemberManager addMemberWithName: memberName];
    }
    return NO;
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
