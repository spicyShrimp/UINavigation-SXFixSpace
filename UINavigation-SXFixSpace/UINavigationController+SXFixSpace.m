//
//  UINavigationController+SXFixSpace.m
//  UINavigation-SXFixSpace
//
//  Created by charles on 2018/4/20.
//  Copyright © 2018年 None. All rights reserved.
//

#import "UINavigationController+SXFixSpace.h"
#import <UIKit/UIImagePickerController.h>
#import "UINavigationConfig.h"
#import "NSObject+SXRuntime.h"

#ifndef sx_deviceVersion
#define sx_deviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

static BOOL sx_tempDisableFixSpace = NO;

@implementation UINavigationController (SXFixSpace)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray <NSString *>*oriSels = [NSMutableArray arrayWithArray:@[
                                                                               @"viewWillAppear:",
                                                                               @"viewWillDisappear:"
                                                                               ]];
        if (@available(iOS 11.0, *)) {
            //FIXME:修正iOS11之后push或者pop动画为NO 系统不主动调用UINavigationBar的layoutSubviews方法
            [oriSels addObjectsFromArray:@[
                                           @"pushViewController:animated:",
                                           @"popViewControllerAnimated:",
                                           @"popToViewController:animated:",
                                           @"popToRootViewControllerAnimated:",
                                           @"setViewControllers:animated:"
                                           ]];
        }
        
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
}

-(void)sx_viewWillDisappear:(BOOL)animated{
    if ([self isKindOfClass:[UIImagePickerController class]]) {
        [UINavigationConfig shared].sx_disableFixSpace = sx_tempDisableFixSpace;
    }
    [self sx_viewWillDisappear:animated];
}

//FIXME:修正iOS11之后push或者pop动画为NO 系统不主动调用UINavigationBar的layoutSubviews方法
-(void)sx_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self sx_pushViewController:viewController animated:animated];
    if (![UINavigationConfig shared].sx_disableFixSpace && !animated) {
        [self.navigationBar layoutSubviews];
    }
}

- (nullable UIViewController *)sx_popViewControllerAnimated:(BOOL)animated {
    UIViewController *vc = [self sx_popViewControllerAnimated:animated];
    if (![UINavigationConfig shared].sx_disableFixSpace && !animated) {
        [self.navigationBar layoutSubviews];
    }
    return vc;
}

- (nullable NSArray<__kindof UIViewController *> *)sx_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *vcs = [self sx_popToViewController:viewController animated:animated];
    if (![UINavigationConfig shared].sx_disableFixSpace && !animated) {
        [self.navigationBar layoutSubviews];
    }
    return vcs;
}

- (nullable NSArray<__kindof UIViewController *> *)sx_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *vcs = [self sx_popToRootViewControllerAnimated:animated];
    if (![UINavigationConfig shared].sx_disableFixSpace && !animated) {
        [self.navigationBar layoutSubviews];
    }
    return vcs;
}

- (void)sx_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    [self sx_setViewControllers:viewControllers animated:animated];
    if (![UINavigationConfig shared].sx_disableFixSpace && !animated) {
        [self.navigationBar layoutSubviews];
    }
}

@end
