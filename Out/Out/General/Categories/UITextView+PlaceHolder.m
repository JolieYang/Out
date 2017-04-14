//
//  UITextView+PlaceHolder.m
//  Out
//
//  Created by Jolie_Yang on 2017/4/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "UITextView+PlaceHolder.h"

@implementation UITextView (PlaceHolder)
- (void)setPlaceHolder:(NSString *)text {
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = text;
    placeHolderLabel.numberOfLines = 0;
//    placeHolderLabel.textColor = [UIColor lightGrayColor];
    placeHolderLabel.textColor = PlaceHolder_Gray;
    [placeHolderLabel sizeToFit];
    [self addSubview:placeHolderLabel];
    placeHolderLabel.font = self.font;
    
    [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}
@end
