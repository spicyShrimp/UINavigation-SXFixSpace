//
//  UINavigationController+SXFixSpace.m
//  UINavigation-SXFixSpace
//
//  Created by charles on 2018/4/20.
//  Copyright © 2018年 None. All rights reserved.
//

#import "UINavigationController+SXFixSpace.h"
#import "UINavigationConfig.h"
#import <UIKit/UIImagePickerController.h>
#import "NSObject+SXRuntime.h"

#ifndef sx_deviceVersion
#define sx_deviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

static BOOL sx_tempDisableFixSpace = NO;

@implementation UINavigationController (SXFixSpace)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(viewWillAppear:)
                                     swizzledSel:@selector(sx_viewWillAppear:)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(viewWillDisappear:)
                                     swizzledSel:@selector(sx_viewWillDisappear:)];
        //FIXME:修正iOS11之后push或者pop动画为NO 系统不主动调用UINavigationBar的layoutSubviews方法
        if (sx_deviceVersion >= 11) {
            [self swizzleInstanceMethodWithOriginSel:@selector(pushViewController:animated:)
                                         swizzledSel:@selector(sx_pushViewController:animated:)];
            
            [self swizzleInstanceMethodWithOriginSel:@selector(popViewControllerAnimated:)
                                         swizzledSel:@selector(sx_popViewControllerAnimated:)];
            
            [self swizzleInstanceMethodWithOriginSel:@selector(popToViewController:animated:)
                                         swizzledSel:@selector(sx_popToViewController:animated:)];
            
            [self swizzleInstanceMethodWithOriginSel:@selector(popToRootViewControllerAnimated:)
                                         swizzledSel:@selector(sx_popToRootViewControllerAnimated:)];
            
            [self swizzleInstanceMethodWithOriginSel:@selector(setViewControllers:animated:)
                                         swizzledSel:@selector(sx_setViewControllers:animated:)];
        }
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
    if (![UINavigationConfig shared].sx_disableFixSpace) {
        if (!animated) {
            [self.navigationBar layoutSubviews];
        }
    }
}

- (nullable UIViewController *)sx_popViewControllerAnimated:(BOOL)animated{
    UIViewController *vc = [self sx_popViewControllerAnimated:animated];
    if (![UINavigationConfig shared].sx_disableFixSpace) {
        if (!animated) {
            [self.navigationBar layoutSubviews];
        }
    }
    return vc;
}

- (nullable NSArray<__kindof UIViewController *> *)sx_popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSArray *vcs = [self sx_popToViewController:viewController animated:animated];
    if (![UINavigationConfig shared].sx_disableFixSpace) {
        if (!animated) {
            [self.navigationBar layoutSubviews];
        }
    }
    return vcs;
}

- (nullable NSArray<__kindof UIViewController *> *)sx_popToRootViewControllerAnimated:(BOOL)animated{
    NSArray *vcs = [self sx_popToRootViewControllerAnimated:animated];
    if (![UINavigationConfig shared].sx_disableFixSpace) {
        if (!animated) {
            [self.navigationBar layoutSubviews];
        }
    }
    return vcs;
}

- (void)sx_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated NS_AVAILABLE_IOS(3_0){
    [self sx_setViewControllers:viewControllers animated:animated];
    if (![UINavigationConfig shared].sx_disableFixSpace) {
        if (!animated) {
            [self.navigationBar layoutSubviews];
        }
    }
}

@end
