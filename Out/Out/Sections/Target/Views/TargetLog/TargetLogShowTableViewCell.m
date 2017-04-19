//
//  TargetLogTableViewCell.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/18.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "TargetLogShowTableViewCell.h"
#import "TargetRecord.h"
#import "UIView+loadFromNib.h"
#import "UILabel+JY.h"
#import "DateHelper.h"

@implementation TargetLogShowTableViewCell

+ (instancetype)initWithTargetRecord:(TargetRecord *)targetRecord {
    TargetLogShowTableViewCell *cell = [self loadFromNib];
//    cell.logLabel.text = targetRecord.log;
    [cell.logLabel setText: targetRecord.log lineSpacing:LogShowLineSpacing];
    cell.timeLabel.text = [DateHelper dateStringFromTimeInterval:targetRecord.addUnix dateFormat:@"yyyy.MM.dd HH:ss"];
    cell.insistHoursLabel.text = [NSString stringWithFormat:@"坚持了%.1f小时", targetRecord.insistHours];
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.logLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForCellWithText:(NSString *)text {
    CGFloat textHeight = [UILabel text:text heightWithFontSize:LogShowSize width:kAppWidth - LeftSpacing - RightSpacing lineSpacing:LogShowLineSpacing];
    return textHeight + TopSpacing + BottomSpacing;// Log空间距离上面跟下面的间距
}

@end
