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

#ifndef deviceVersion
#define deviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

static CGFloat sx_tempFixSpace = 0;

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
    
    if (deviceVersion >= 11) {
        self.layoutMargins = UIEdgeInsetsZero;
        CGFloat space = sx_tempFixSpace !=0 ? sx_tempFixSpace : sx_defaultFixSpace;
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
    if (leftBarButtonItem.customView) {
        if (deviceVersion >= 11) {
            sx_tempFixSpace = 0;
            [self sx_setLeftBarButtonItem:leftBarButtonItem];
        } else {
            [self setLeftBarButtonItems:@[leftBarButtonItem]];
        }
    } else {
        sx_tempFixSpace = 20;
        [self sx_setLeftBarButtonItem:leftBarButtonItem];
    }
}

-(void)sx_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    NSMutableArray *items = [NSMutableArray arrayWithObject:[self fixedSpaceWithWidth:sx_defaultFixSpace-20]];//可修正iOS11之前的偏移
    [items addObjectsFromArray:leftBarButtonItems];
    [self sx_setLeftBarButtonItems:items];
}

-(void)sx_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
    if (rightBarButtonItem.customView) {
        if (deviceVersion >= 11) {
            sx_tempFixSpace = 0;
            [self sx_setRightBarButtonItem:rightBarButtonItem];
        } else {
            [self setRightBarButtonItems:@[rightBarButtonItem]];
        }
    } else {
        sx_tempFixSpace = 20;
        [self sx_setRightBarButtonItem:rightBarButtonItem];
    }
}

-(void)sx_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems{
    NSMutableArray *items = [NSMutableArray arrayWithObject:[self fixedSpaceWithWidth:sx_defaultFixSpace-20]];//可修正iOS11之前的偏移
    [items addObjectsFromArray:rightBarButtonItems];
    [self sx_setRightBarButtonItems:items];
}

-(UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}

@end
