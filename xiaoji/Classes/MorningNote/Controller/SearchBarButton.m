//
//  SearchBarButton.m
//  xiaoji
//
//  Created by xiaotei's on 16/4/7.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

#import "SearchBarButton.h"

@implementation SearchBarButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    CGPoint center = self.imageView.center;
    self.imageView.frame = CGRectMake(0, 0, 24, 24);
    self.imageView.center = center;
}

@end
