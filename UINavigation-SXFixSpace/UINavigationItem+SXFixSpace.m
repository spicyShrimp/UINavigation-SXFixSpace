//
//  UINavigationItem+SXFixSpace.m
//  UINavigation-SXFixSpace
//
//  Created by charles on 2018/4/20.
//  Copyright © 2018年 None. All rights reserved.
//

#import "UINavigationItem+SXFixSpace.h"
#import "NSObject+SXRuntime.h"
#import "UINavigationConfig.h"

#ifndef sx_deviceVersion
#define sx_deviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

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
    if (sx_deviceVersion >= 11) {
        [self sx_setLeftBarButtonItem:leftBarButtonItem];
    } else {
        if (![UINavigationConfig shared].sx_disableFixSpace && leftBarButtonItem) {//存在按钮且需要调节
            [self setLeftBarButtonItems:@[leftBarButtonItem]];
        } else {//不存在按钮,或者不需要调节
            [self sx_setLeftBarButtonItem:leftBarButtonItem];
        }
    }
}

-(void)sx_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    if (leftBarButtonItems.count) {
        NSMutableArray *items = [NSMutableArray arrayWithObject:[self fixedSpaceWithWidth:[UINavigationConfig shared].sx_defaultFixSpace-20]];//可修正iOS11之前的偏移
        [items addObjectsFromArray:leftBarButtonItems];
        [self sx_setLeftBarButtonItems:items];
    } else {
        [self sx_setLeftBarButtonItems:leftBarButtonItems];
    }
}

-(void)sx_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
    if (sx_deviceVersion >= 11) {
        [self sx_setRightBarButtonItem:rightBarButtonItem];
    } else {
        if (![UINavigationConfig shared].sx_disableFixSpace && rightBarButtonItem) {//存在按钮且需要调节
            [self setRightBarButtonItems:@[rightBarButtonItem]];
        } else {//不存在按钮,或者不需要调节
            [self sx_setRightBarButtonItem:rightBarButtonItem];
        }
    }
}

-(void)sx_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems{
    if (rightBarButtonItems.count) {
        NSMutableArray *items = [NSMutableArray arrayWithObject:[self fixedSpaceWithWidth:[UINavigationConfig shared].sx_defaultFixSpace-20]];//可修正iOS11之前的偏移
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
