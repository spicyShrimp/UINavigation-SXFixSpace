//
//  UINavigation+SXFixSpace.h
//  UINavigation-SXFixSpace
//
//  Created by charles on 2017/9/8.
//  Copyright © 2017年 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationConfig: NSObject

+ (instancetype)shared;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property(nonatomic, assign)CGFloat sx_defaultFixSpace;//默认距离两端的间距,可以修改,

@end

@interface UINavigationController (SXFixSpace)
@end

@interface UINavigationBar (SXFixSpace)
@end

@interface UINavigationItem (SXFixSpace)
@end

