//
//  UINavigation+SXFixSpace.m
//  UINavigation-SXFixSpace
//
//  Created by charles on 2017/9/8.
//  Copyright © 2017年 None. All rights reserved.
//

#import "UINavigation+SXFixSpace.h"
#import "NSObject+SXRuntime.h"
#import <UIKit/UIKit.h>
#import <Availability.h>

#ifndef deviceVersion
#define deviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

static BOOL sx_disableFixSpace = NO;

static BOOL sx_tempDisableFixSpace = NO;
static NSInteger sx_tempBehavior = 0;

@implementation UINavigationController (SXFixSpace)
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(viewWillAppear:)
                                     swizzledSel:@selector(sx_viewWillAppear:)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(viewWillDisappear:)
                                     swizzledSel:@selector(sx_viewWillDisappear:)];
        //FIXME:修正iOS11之后push或者pop动画为NO 系统不主动调用UINavigationBar的layoutSubviews方法
        if (deviceVersion >= 11) {
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
        sx_tempDisableFixSpace = sx_disableFixSpace;
        sx_disableFixSpace = YES;
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            sx_tempBehavior = [UIScrollView appearance].contentInsetAdjustmentBehavior;
            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
#endif
    }
    [self sx_viewWillAppear:animated];
}

-(void)sx_viewWillDisappear:(BOOL)animated{
    if ([self isKindOfClass:[UIImagePickerController class]]) {
        sx_disableFixSpace = sx_tempDisableFixSpace;
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = sx_tempBehavior;
        }
#endif
    }
    [self sx_viewWillDisappear:animated];
}

//FIXME:修正iOS11之后push或者pop动画为NO 系统不主动调用UINavigationBar的layoutSubviews方法
-(void)sx_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self sx_pushViewController:viewController animated:animated];
    if (!animated) {
        [self.navigationBar layoutSubviews];
    }
}

- (nullable UIViewController *)sx_popViewControllerAnimated:(BOOL)animated{
    UIViewController *vc = [self sx_popViewControllerAnimated:animated];
    if (!animated) {
        [self.navigationBar layoutSubviews];
    }
    return vc;
}

- (nullable NSArray<__kindof UIViewController *> *)sx_popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSArray *vcs = [self sx_popToViewController:viewController animated:animated];
    if (!animated) {
        [self.navigationBar layoutSubviews];
    }
    return vcs;
}

- (nullable NSArray<__kindof UIViewController *> *)sx_popToRootViewControllerAnimated:(BOOL)animated{
    NSArray *vcs = [self sx_popToRootViewControllerAnimated:animated];
    if (!animated) {
        [self.navigationBar layoutSubviews];
    }
    return vcs;
}

- (void)sx_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated NS_AVAILABLE_IOS(3_0){
    [self sx_setViewControllers:viewControllers animated:animated];
    if (!animated) {
        [self.navigationBar layoutSubviews];
    }
}

@end

@implementation UINavigationBar (SXFixSpace)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(layoutSubviews)
                                     swizzledSel:@selector(sx_layoutSubviews)];
    });
}

-(void)sx_layoutSubviews{
    [self sx_layoutSubviews];
    
    if (deviceVersion >= 11 && !sx_disableFixSpace) {//需要调节
        self.layoutMargins = UIEdgeInsetsZero;
        CGFloat space = sx_defaultFixSpace;
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass(subview.class) containsString:@"ContentView"]) {
                subview.layoutMargins = UIEdgeInsetsMake(0, space, 0, space);//可修正iOS11之后的偏移
                break;
            }
        }
    }
}

@end

@implementation UINavigationItem (SXFixSpace)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(setLeftBarButtonItem:)
                                     swizzledSel:@selector(sx_setLeftBarButtonItem:)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(setLeftBarButtonItems:)
                                     swizzledSel:@selector(sx_setLeftBarButtonItems:)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(setRightBarButtonItem:)
                                     swizzledSel:@selector(sx_setRightBarButtonItem:)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(setRightBarButtonItems:)
                                     swizzledSel:@selector(sx_setRightBarButtonItems:)];
    });
    
}

-(void)sx_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    if (deviceVersion >= 11) {
        [self sx_setLeftBarButtonItem:leftBarButtonItem];
    } else {
        if (!sx_disableFixSpace && leftBarButtonItem) {//存在按钮且需要调节
            [self setLeftBarButtonItems:@[leftBarButtonItem]];
        } else {//不存在按钮,或者不需要调节
            [self sx_setLeftBarButtonItem:leftBarButtonItem];
        }
    }
}

-(void)sx_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    if (leftBarButtonItems.count) {
        NSMutableArray *items = [NSMutableArray arrayWithObject:[self fixedSpaceWithWidth:sx_defaultFixSpace-20]];//可修正iOS11之前的偏移
        [items addObjectsFromArray:leftBarButtonItems];
        [self sx_setLeftBarButtonItems:items];
    } else {
        [self sx_setLeftBarButtonItems:leftBarButtonItems];
    }
}

-(void)sx_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
    if (deviceVersion >= 11) {
        [self sx_setRightBarButtonItem:rightBarButtonItem];
    } else {
        if (!sx_disableFixSpace && rightBarButtonItem) {//存在按钮且需要调节
            [self setRightBarButtonItems:@[rightBarButtonItem]];
        } else {//不存在按钮,或者不需要调节
            [self sx_setRightBarButtonItem:rightBarButtonItem];
        }
    }
}

-(void)sx_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems{
    if (rightBarButtonItems.count) {
        NSMutableArray *items = [NSMutableArray arrayWithObject:[self fixedSpaceWithWidth:sx_defaultFixSpace-20]];//可修正iOS11之前的偏移
        [items addObjectsFromArray:rightBarButtonItems];
        [self sx_setRightBarButtonItems:items];
    } else {
        [self sx_setRightBarButtonItems:rightBarButtonItems];
    }
}

-(UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}

@end

