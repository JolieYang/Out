//
//  KeyedArchiverHelper.h
//  Out
//
//  Created by Jolie_Yang on 2017/3/17.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyedArchiverHelper : NSObject
+ (BOOL)addObject:(NSObject *)dataObject;
+ (BOOL)addObject:(NSObject *)dataObject archiverPathComponent:(NSString *)path;

+ (id)readKeyedArchiverData;
+ (id)readKeyedArchiverDataWithPath:(NSString *)path;
@end