//
//  JYPhotoListViewController.m
//  JYPhotoKit
//
//  Created by Jolie_Yang on 16/9/23.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "JYPhotoListViewController.h"
#import <Photos/Photos.h>

@interface JYPhotoListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *albumTable;
@property (nonatomic, strong) PHPhotoLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *albums;

@end

@implementation JYPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action
- (IBAction)closeBarButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDelegate

#pragma mark UITableViewDataSource
@end
