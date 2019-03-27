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
        
        [self swizzleInstanceMethodWithOriginSel:@selector(setLeftBarButtonItem:animated:)
                                     swizzledSel:@selector(sx_setLeftBarButtonItem:animated:)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(setLeftBarButtonItems:animated:)
                                     swizzledSel:@selector(sx_setLeftBarButtonItems:animated:)];

        [self swizzleInstanceMethodWithOriginSel:@selector(setRightBarButtonItem:)
                                     swizzledSel:@selector(sx_setRightBarButtonItem:)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(setRightBarButtonItems:)
                                     swizzledSel:@selector(sx_setRightBarButtonItems:)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(setRightBarButtonItem:animated:)
                                     swizzledSel:@selector(sx_setRightBarButtonItem:animated:)];
        
        [self swizzleInstanceMethodWithOriginSel:@selector(setRightBarButtonItems:animated:)
                                     swizzledSel:@selector(sx_setRightBarButtonItems:animated:)];

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
    if (sx_deviceVersion >= 11) {
        [self sx_setLeftBarButtonItems:leftBarButtonItems];
    } else {
        if (leftBarButtonItems.count) {
            
            UIBarButtonItem *firstItem = leftBarButtonItems.firstObject;
            if (firstItem != nil
                && firstItem.image == nil
                && firstItem.title == nil
                && firstItem.customView == nil)  {
                // 第一个item 为spcae
                [self sx_setLeftBarButtonItems:leftBarButtonItems];
                return;
            }
            
            NSMutableArray *items = [NSMutableArray arrayWithObject:[self fixedSpaceWithWidth:[UINavigationConfig shared].sx_fixedSpaceWidth]];//可修正iOS11之前的偏移
            [items addObjectsFromArray:leftBarButtonItems];
            [self sx_setLeftBarButtonItems:items];
        } else {
            [self sx_setLeftBarButtonItems:leftBarButtonItems];
        }
    }
}

-(void)sx_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem animated:(BOOL)animated {
    if (sx_deviceVersion >= 11) {
        [self sx_setLeftBarButtonItem:leftBarButtonItem animated:animated];
    } else {
        if (![UINavigationConfig shared].sx_disableFixSpace && leftBarButtonItem) {//存在按钮且需要调节
            [self setLeftBarButtonItems:@[leftBarButtonItem] animated:animated];
        } else {//不存在按钮,或者不需要调节
            [self sx_setLeftBarButtonItem:leftBarButtonItem animated:animated];
        }
    }
}

-(void)sx_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems animated:(BOOL)animated {
    if (sx_deviceVersion >= 11) {
        [self sx_setLeftBarButtonItems:leftBarButtonItems animated:animated];
    } else {
        if (leftBarButtonItems.count) {
            UIBarButtonItem *firstItem = leftBarButtonItems.firstObject;
            if (firstItem != nil
                && firstItem.image == nil
                && firstItem.title == nil
                && firstItem.customView == nil)  {
                // 第一个item 为spcae
                [self sx_setLeftBarButtonItems:leftBarButtonItems animated:animated];
                return;
            }
            NSMutableArray *items = [NSMutableArray arrayWithObject:[self fixedSpaceWithWidth:[UINavigationConfig shared].sx_fixedSpaceWidth]];//可修正iOS11之前的偏移
            [items addObjectsFromArray:leftBarButtonItems];
            [self sx_setLeftBarButtonItems:items animated:animated];
        } else {
            [self sx_setLeftBarButtonItems:leftBarButtonItems animated:animated];
        }
    }
}

-(void)sx_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
    
    [self standardFontSizeWithItems:@[rightBarButtonItem]];
    
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
    
    [self standardFontSizeWithItems:rightBarButtonItems];
    
    if (sx_deviceVersion >= 11) {
        [self sx_setRightBarButtonItems:rightBarButtonItems];
    } else {
        if (rightBarButtonItems.count) {
            UIBarButtonItem *firstItem = rightBarButtonItems.firstObject;
            if (firstItem != nil
                && firstItem.image == nil
                && firstItem.title == nil
                && firstItem.customView == nil)  {
                // 第一个item 为spcae
                [self sx_setRightBarButtonItems:rightBarButtonItems];
                return;
            }
            NSMutableArray *items = [NSMutableArray arrayWithObject:[self fixedSpaceWithWidth:[UINavigationConfig shared].sx_fixedSpaceWidth]];//可修正iOS11之前的偏移
            [items addObjectsFromArray:rightBarButtonItems];
            [self sx_setRightBarButtonItems:items];
        } else {
            [self sx_setRightBarButtonItems:rightBarButtonItems];
        }
    }
}

- (void)sx_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem animated:(BOOL)animated {
    
    [self standardFontSizeWithItems:@[rightBarButtonItem]];
    
    if (sx_deviceVersion >= 11) {
        [self sx_setRightBarButtonItem:rightBarButtonItem animated:animated];
    } else {
        if (![UINavigationConfig shared].sx_disableFixSpace && rightBarButtonItem) {//存在按钮且需要调节
            [self setRightBarButtonItems:@[rightBarButtonItem] animated:animated];
        } else {//不存在按钮,或者不需要调节
            [self sx_setRightBarButtonItem:rightBarButtonItem animated:animated];
        }
    }
}

- (void)sx_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems animated:(BOOL)animated {
    
    [self standardFontSizeWithItems:rightBarButtonItems];
    
    if (sx_deviceVersion >= 11) {
        [self sx_setRightBarButtonItems:rightBarButtonItems animated:animated];
    } else {
        if (rightBarButtonItems.count) {
            UIBarButtonItem *firstItem = rightBarButtonItems.firstObject;
            if (firstItem != nil
                && firstItem.image == nil
                && firstItem.title == nil
                && firstItem.customView == nil)  {
                // 第一个item 为spcae
                [self sx_setRightBarButtonItems:rightBarButtonItems animated:animated];
                return;
            }
            NSMutableArray *items = [NSMutableArray arrayWithObject:[self fixedSpaceWithWidth:[UINavigationConfig shared].sx_fixedSpaceWidth]];//可修正iOS11之前的偏移
            [items addObjectsFromArray:rightBarButtonItems];
            [self sx_setRightBarButtonItems:items animated:animated];
        } else {
            [self sx_setRightBarButtonItems:rightBarButtonItems animated:animated];
        }
    }
}

-(UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}

- (void)standardFontSizeWithItems:(NSArray <UIBarButtonItem *>*)items {
    [items enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull barButtonItem, NSUInteger idx, BOOL * _Nonnull stop) {
        UIFont *font = [UINavigationConfig shared].sx_rightBarItemTextFont;
        CGFloat width = [UINavigationConfig shared].sx_rightBarItemMiniWidth;
        if ([barButtonItem.customView isKindOfClass:[UIButton class]]) {
            UIButton *btn = barButtonItem.customView;
            if (btn.currentTitle.length > 0) {
                btn.titleLabel.font = font;
                CGSize labelSize = [btn.currentTitle sizeWithAttributes:@{NSFontAttributeName:font}];
                if (btn.frame.size.width < width) {
                    CGRect frame = btn.frame;
                    frame.size.width = width;
                    btn.frame = frame;
                }
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, (btn.frame.size.width - labelSize.width)/2, 0, 0);
            }
        }
        else {
            if (barButtonItem.title.length > 0) {
                [barButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] forState:UIControlStateNormal];
            }
        }
    }];
}

@end
