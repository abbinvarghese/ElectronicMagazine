//
//  MESignInViewController.m
//  ElectronicMagazine
//
//  Created by Abbin Varghese on 16/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "MESignInViewController.h"

@interface MESignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation MESignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0.0f, 44.0 - 1, self.emailTextField.frame.size.width, 0.3f);
    bottomBorder2.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    [_emailTextField.layer addSublayer:bottomBorder2];
    
    CALayer *bottomBorder3 = [CALayer layer];
    bottomBorder3.frame = CGRectMake(0.0f, 44.0 - 1, self.passwordTextField.frame.size.width, 0.3f);
    bottomBorder3.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    [_passwordTextField.layer addSublayer:bottomBorder3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismiss:(UIButton *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
