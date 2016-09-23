//
//  JYPhotoListViewController.h
//  JYPhotoKit
//
//  Created by Jolie_Yang on 16/9/23.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYPhotoListViewController : UIViewController

@property (nonatomic, assign) NSInteger selectNum;
@property (nonatomic, strong) void (^photoResult)(id responseObject);

@end
