//
//  ViewController.m
//  UINavigation-SXFixSpace
//
//  Created by charles on 2017/10/11.
//  Copyright © 2017年 None. All rights reserved.
//

#import "ViewController.h"
#import "UIBarButtonItem+SXCreate.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    
    [self configUI];
}

- (void)configNavigationBar {
    NSInteger count = self.navigationController.viewControllers.count;
    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    if (count % 2) {
        self.navigationItem.title = self.titleString;
    } else {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        label.backgroundColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.titleString;
        self.navigationItem.titleView = label;
    }
    
    if (self.type == DemoVCTypeCustomBack) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popAction) image:[UIImage imageNamed:@"nav_back"]];
    }
    
    if (count % 5 == 0) { //此方式为系统方法不可以自定义多个按钮之间的间距
        self.navigationItem.rightBarButtonItems = @[
                                                    [UIBarButtonItem itemWithTarget:self action:nil image:[UIImage imageNamed:@"nav_add"]],
                                                    [UIBarButtonItem itemWithTarget:self action:nil image:[UIImage imageNamed:@"nav_add"]]
                                                    ];
        
    } else if (count % 5 == 1) { //单个按钮
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:nil image:[UIImage imageNamed:@"nav_add"]];
    } else if (count % 5 == 2) { //此方式initWithCustomView 可以自定义任何样式或者间距
        UISlider *slr = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:slr];
    } else if (count % 5 == 3) { //此方式initWithCustomView 可以自定义任何样式或者间距
        UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
        
        UISwitch *swh1 = [[UISwitch alloc]init];
        swh1.frame = CGRectMake(0, 5, 50, 30);
        [barView addSubview:swh1];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(50, 0, 40, 40);
        [btn1 setImage:[UIImage imageNamed:@"nav_add"] forState:UIControlStateNormal];
        [barView addSubview:btn1];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barView];
        
    } else if (count % 5 == 4) { //此方式initWithCustomView 可以自定义任何样式或者间距
        UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 0, 40, 40);
        [btn1 setImage:[UIImage imageNamed:@"nav_add"] forState:UIControlStateNormal];
        [barView addSubview:btn1];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(40, 0, 40, 40);
        [btn2 setImage:[UIImage imageNamed:@"nav_add"] forState:UIControlStateNormal];
        [barView addSubview:btn2];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:barView];
    }
    
    
}

- (void)configUI {
    self.dataArray = @[
                       @"进入相册",
                       @"系统自带返回按钮",
                       @"自定义返回按钮"
                       ];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:UITableViewCell.description];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"有动画";
    } else {
        return @"无动画";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCell.description forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL animated = indexPath.section == 0;
    if (indexPath.row == DemoVCTypeIntoAlbum) {
        self.animated = animated;
        UIImagePickerController *pick = [[UIImagePickerController alloc]init];
        pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pick.delegate = self;
        [self presentViewController:pick animated:animated completion:nil];
    } else {
        ViewController *vc = [ViewController new];
        vc.type = indexPath.row;
        vc.titleString = self.dataArray[indexPath.row];
        vc.animated = animated;
        [self.navigationController pushViewController:vc animated:animated];
    }
}

-(void)popAction{
    [self.navigationController popViewControllerAnimated:self.animated];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:self.animated completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:self.animated completion:nil];
}

@end
