//
//  UIViewController+SXFixSpace.m
//  UINavigation-SXFixSpace
//
//  Created by charles on 2018/4/20.
//  Copyright © 2018年 None. All rights reserved.
//

#import "UIViewController+SXFixSpace.h"
#import <UIKit/UIImagePickerController.h>
#import "UINavigationConfig.h"
#import "NSObject+SXRuntime.h"

static BOOL sx_tempDisableFixSpace = NO;

@implementation UIViewController (SXFixSpace)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray <NSString *>*oriSels = @[
                                         @"viewWillAppear:",
                                         @"viewWillDisappear:"
                                         ];

        
        [oriSels enumerateObjectsUsingBlock:^(NSString * _Nonnull oriSel, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *swiSel = [NSString stringWithFormat:@"sx_%@", oriSel];
            [self swizzleInstanceMethodWithOriginSel:NSSelectorFromString(oriSel)
                                         swizzledSel:NSSelectorFromString(swiSel)];
        }];
    });
}


-(void)sx_viewWillAppear:(BOOL)animated {
    if ([self isKindOfClass:[UIImagePickerController class]]) {
        sx_tempDisableFixSpace = [UINavigationConfig shared].sx_disableFixSpace;
        [UINavigationConfig shared].sx_disableFixSpace = YES;
    }
    [self sx_viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        if (!animated && self.navigationController) {
            [self.navigationController.navigationBar layoutSubviews];
        }
    }
}

-(void)sx_viewWillDisappear:(BOOL)animated{
    if ([self isKindOfClass:[UIImagePickerController class]]) {
        [UINavigationConfig shared].sx_disableFixSpace = sx_tempDisableFixSpace;
    }
    [self sx_viewWillDisappear:animated];
}

@end
