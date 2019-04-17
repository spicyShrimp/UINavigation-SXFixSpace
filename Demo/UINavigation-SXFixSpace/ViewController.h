//
//  ViewController.h
//  UINavigation-SXFixSpace
//
//  Created by charles on 2017/10/11.
//  Copyright © 2017年 None. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DemoVCType) {
    DemoVCTypeIntoAlbum = 0,
    DemoVCTypeSysBack,
    DemoVCTypeCustomBack,
};

@interface ViewController : UIViewController

@property (nonatomic, assign) DemoVCType type;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, assign) BOOL animated;

@end

