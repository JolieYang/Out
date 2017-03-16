//
//  ForecastView.h
//  Out
//
//  Created by Jolie_Yang on 2017/3/16.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastView : UIView
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *temperature;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@end
