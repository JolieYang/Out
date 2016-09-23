//
//  JYPhoto.h
//  JYPhotoKit
//
//  Created by Jolie_Yang on 16/9/23.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYPhotoConfig.h"

@interface JYPhoto : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, assign) BOOL isSelect;

+ (UIImage *)fetchThumbnailImageWithAsset:(PHAsset *)asset;
@end
