//
//  TextViewHelper.m
//  Out
//
//  Created by Jolie_Yang on 16/9/2.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "TextViewHelper.h"

@implementation TextViewHelper
+ (float)heightForTextView:(UITextView *)textView {
    float fPadding = 8.0;
    CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding*2 - 30*2, MAXFLOAT);
    CGRect rect = [textView.text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:textView.font,NSFontAttributeName, nil] context:nil];
    float fHeight = rect.size.height + 16.0;
    return fHeight;
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(textView.contentSize.width - 30*2 - fPadding, CGFLOAT_MAX);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByClipping];
    NSDictionary *attributes = @{NSFontAttributeName: textView.font, NSParagraphStyleAttributeName: style};
    CGRect rect = [strText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    float fHeight = rect.size.height + fPadding;
    return fHeight;
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}
@end
