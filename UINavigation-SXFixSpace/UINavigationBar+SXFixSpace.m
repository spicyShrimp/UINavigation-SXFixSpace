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

@implementation UINavigationBar (SXFixSpace)

+(void)load {
    if (@available(iOS 11.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSArray <NSString *>*oriSels = @[
                                             @"layoutSubviews"
                                             ];
            
            [oriSels enumerateObjectsUsingBlock:^(NSString * _Nonnull oriSel, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *swiSel = [NSString stringWithFormat:@"sx_%@", oriSel];
                [self swizzleInstanceMethodWithOriginSel:NSSelectorFromString(oriSel)
                                             swizzledSel:NSSelectorFromString(swiSel)];
            }];
        });
    }
}

-(void)sx_layoutSubviews{
    [self sx_layoutSubviews];
    if (![UINavigationConfig shared].sx_disableFixSpace) {//需要调节
        CGFloat space = [UINavigationConfig shared].sx_defaultFixSpace;
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass(subview.class) containsString:@"ContentView"]) {
                subview.layoutMargins = UIEdgeInsetsMake(0, space, 0, space);
                break;
            }
        }
    }
}

@end
