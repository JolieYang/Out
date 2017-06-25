//
//  RunningAddPartyViewController.h
//  Out
//
//  Created by Jolie on 2017/6/25.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunningWeek.h"

@interface RunningAddPartyViewController : UIViewController
@property (nonatomic, assign) NSInteger weekId;
@property (nonatomic, copy) void (^successAddPartyCostBlock)(RunningWeek *week);
@end
