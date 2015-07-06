//
//  QYBook.m
//  XMLDemo
//
//  Created by qingyun on 14-11-27.
//  Copyright (c) 2014年 hnqingyun. All rights reserved.
//

#import "QYBook.h"

@implementation QYBook

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"Book Info:\rCategory:<%@>\rTitle:<%@>\rLanguage:<%@>\rAuthor:<%@>\rYear:<%@>\rPrice:<%@>", _category, _title, _lang, _author, _year, _price];
    
    return desc;
}

@end
