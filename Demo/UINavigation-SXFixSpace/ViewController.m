//
//  ViewController.m
//  UINavigation-SXFixSpace
//
//  Created by charles on 2017/10/11.
//  Copyright © 2017年 None. All rights reserved.
//

#import "ViewController.h"
#import "UIBarButtonItem+SXCreate.h"
#import "UINavigationSXFixSpace.h"

@interface ViewController() <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"进入相册" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(intoAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self configBarItem];
}

- (void)configBarItem {
    NSInteger count = self.navigationController.viewControllers.count;
    self.navigationItem.title = @(count).stringValue;
    if (count % 2 != 0) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self
                                                                          action:@selector(pushAction)
                                                                           image:[UIImage imageNamed:@"nav_add"]];
    } else {
        //系统默认多个item(有间距)
        self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem itemWithTarget:self
                                                                             action:@selector(pushAction)
                                                                              image:[UIImage imageNamed:@"nav_add"]],
                                                    [UIBarButtonItem itemWithTarget:self
                                                                             action:@selector(pushAction)
                                                                              image:[UIImage imageNamed:@"nav_add"]]];
        
        //自定义多个item(自定义间距)
//        UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
//
//        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn1.frame = CGRectMake(0, 0, 40, 40);
//        [btn1 setImage:[UIImage imageNamed:@"nav_add"] forState:UIControlStateNormal];
//        [btn1 addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
//        [barView addSubview:btn1];
//
//        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn2.frame = CGRectMake(40, 0, 40, 40);
//        [btn2 setImage:[UIImage imageNamed:@"nav_add"] forState:UIControlStateNormal];
//        [btn2 addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
//        [barView addSubview:btn2];
//
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barView];
    }
    
    if (count > 1) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self
                                                                         action:@selector(popAction)
                                                                          image:[UIImage imageNamed:@"nav_back"]];
    }
}

- (void)pushAction {
    ViewController *vc = [ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)intoAlbum {
    UIImagePickerController *pick = [[UIImagePickerController alloc]init];
    [UINavigationConfig shared].sx_disableFixSpace = YES;
    pick.delegate = self;
    [self presentViewController:pick animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [UINavigationConfig shared].sx_disableFixSpace = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [UINavigationConfig shared].sx_disableFixSpace = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
