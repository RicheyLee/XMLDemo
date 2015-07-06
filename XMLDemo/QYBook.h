//
//  QYBook.h
//  XMLDemo
//
//  Created by qingyun on 14-11-27.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYBook : NSObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *price;

@end
