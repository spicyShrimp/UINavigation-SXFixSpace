//
//  UIViewController+SXFixSpace.m
//  UINavigation-SXFixSpace
//
//  Created by charles on 2018/4/20.
//  Copyright © 2018年 None. All rights reserved.
//

#import "UIViewController+SXFixSpace.h"
#import "NSObject+SXRuntime.h"

@implementation UIViewController (SXFixSpace)

+(void)load {
    if (@available(iOS 11.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSArray <NSString *>*oriSels = @[@"viewWillAppear:"];
            
            [oriSels enumerateObjectsUsingBlock:^(NSString * _Nonnull oriSel, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *swiSel = [NSString stringWithFormat:@"sx_%@", oriSel];
                [self swizzleInstanceMethodWithOriginSel:NSSelectorFromString(oriSel) swizzledSel:NSSelectorFromString(swiSel)];
            }];
        });
    }
}


-(void)sx_viewWillAppear:(BOOL)animated {
    [self sx_viewWillAppear:animated];
    if (!animated && self.navigationController) {
        [self.navigationController.navigationBar setNeedsLayout];
    }
}

@end
