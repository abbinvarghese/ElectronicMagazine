//
//  METabBarViewController.m
//  ElectronicMagazine
//
//  Created by Abbin Varghese on 15/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "METabBarViewController.h"

@interface METabBarViewController ()

@end

@implementation METabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIFont *f = [UIFont fontWithName:@"" size:20];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item.tag==0){
        [self.tabBar setTintColor:[UIColor blackColor]];
    }
    else if (item.tag == 1){
        [self.tabBar setTintColor:[UIColor blackColor]];
    }
    else{
        [self.tabBar setTintColor:[UIColor blackColor]];
    }
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
