//
//  METabBarViewController.m
//  ElectronicMagazine
//
//  Created by Abbin Varghese on 15/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "METabBarViewController.h"
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface METabBarViewController ()

@end

@implementation METabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setTintColor:UIColorFromRGB(0x5856D6)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
