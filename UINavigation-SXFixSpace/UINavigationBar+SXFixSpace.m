//
//  UINavigationBar+SXFixSpace.m
//  UINavigation-SXFixSpace
//
//  Created by charles on 2018/4/20.
//  Copyright © 2018年 None. All rights reserved.
//

#import "UINavigationBar+SXFixSpace.h"
#import "UINavigationConfig.h"
#import "NSObject+SXRuntime.h"

#ifndef sx_deviceVersion
#define sx_deviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

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
    if (sx_deviceVersion >= 11 && ![UINavigationConfig shared].sx_disableFixSpace) {//需要调节
//        self.layoutMargins = UIEdgeInsetsZero;
        CGFloat space = [UINavigationConfig shared].sx_defaultFixSpace;
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass(subview.class) containsString:@"ContentView"]) {
                subview.layoutMargins = UIEdgeInsetsMake(0, space, 0, space);//可修正iOS11之后的偏移
                break;
            }
        }
    }
}

@end
