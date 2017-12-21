//
//  ViewController.m
//  UINavigation-SXFixSpace
//
//  Created by charles on 2017/10/11.
//  Copyright © 2017年 None. All rights reserved.
//

#import "ViewController.h"
#import "UIBarButtonItem+SXCreate.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.navigationController.viewControllers.count % 2) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        view.backgroundColor = [UIColor redColor];
        self.navigationItem.titleView = view;
    } else {
        self.navigationItem.title = [@(self.navigationController.viewControllers.count) stringValue];
    }
    
    [self configBarItem];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"进入相册" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(intoAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self configBarItem];
}

-(void)configBarItem{
    
    if (self.navigationController.viewControllers.count % 2) {
        //单个按钮,这里增加了快捷创建的方式
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pushAction) image:[UIImage imageNamed:@"nav_add"]];
    } else {
        //多个按钮(或者其他任意控件比如segment|slider.....)可以使用自定义视图的方式
        //此方式也可以自定义多个按钮之间的间距
        UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 0, 40, 40);
        [btn1 setImage:[UIImage imageNamed:@"nav_add"] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:btn1];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(40, 0, 40, 40);
        [btn2 setImage:[UIImage imageNamed:@"nav_add"] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:btn2];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barView];
        
        //此方式为系统方法不可以自定义多个按钮之间的间距
        //        self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem itemWithTarget:self action:@selector(pushAction) image:[UIImage imageNamed:@"nav_add"]],[UIBarButtonItem itemWithTarget:self action:@selector(pushAction) image:[UIImage imageNamed:@"nav_add"]]];
        
    }
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popAction) image:[UIImage imageNamed:@"nav_back"]];
    }
}

-(void)pushAction{
    [self.navigationController pushViewController:[ViewController new] animated:arc4random_uniform(200) % 2 ? YES : NO];
}

-(void)popAction{
    [self.navigationController popViewControllerAnimated:arc4random_uniform(200) % 2 ? YES : NO];
}

-(void)intoAlbum{
    UIImagePickerController *pick = [[UIImagePickerController alloc]init];
    pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pick.delegate = self;
    [self presentViewController:pick animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
