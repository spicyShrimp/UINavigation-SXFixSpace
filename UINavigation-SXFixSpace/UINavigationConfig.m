//
//  UINavigationConfig.m
//  UINavigation-SXFixSpace
//
//  Created by charles on 2018/4/20.
//  Copyright © 2018年 None. All rights reserved.
//

#import "UINavigationConfig.h"

@implementation UINavigationConfig

+ (instancetype)shared {
    static UINavigationConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self configBase];
    }
    return self;
}

-(void)configBase {
    self.sx_defaultFixSpace = 0.f;
    self.sx_fixedSpaceWidth = -20.f;
    self.sx_disableFixSpace = NO;
}

@end
