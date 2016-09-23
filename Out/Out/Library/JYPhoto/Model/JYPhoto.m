//
//  JYPhoto.m
//  JYPhotoKit
//
//  Created by Jolie_Yang on 16/9/23.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "JYPhoto.h"

@implementation JYPhoto
+ (UIImage *)fetchThumbnailImageWithAsset:(PHAsset *)asset {
    __block UIImage *thumbnailImage;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downloadFinished = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        if (downloadFinished) {
            thumbnailImage = result;
        }
    }];
    
    
    return thumbnailImage;
}
@end
