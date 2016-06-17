//
//  MEUserSignINUPViewController.m
//  ElectronicMagazine
//
//  Created by Abbin Varghese on 16/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "MEUserSignINUPViewController.h"
#import "MESignInViewController.h"
#import <GoogleSignIn/GoogleSignIn.h>
@import Firebase;

typedef NS_ENUM(NSInteger, SignUpType) {
    EmailSignUpType,
    FacebookSignUpType,
    GoogleSignUpType,
    TwitterSignUpType
};

@interface MEUserSignINUPViewController ()<GIDSignInUIDelegate,GIDSignInDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (assign, nonatomic) SignUpType signUpType;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation MEUserSignINUPViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 44.0 - 1, self.nameTextField.frame.size.width, 0.3f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    [_nameTextField.layer addSublayer:bottomBorder];
    
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0.0f, 44.0 - 1, self.nameTextField.frame.size.width, 0.3f);
    bottomBorder2.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
    [_emailTextField.layer addSublayer:bottomBorder2];
    
    CALayer *bottomBorder3 = [CALayer layer];
    bottomBorder3.frame = CGRectMake(0.0f, 44.0 - 1, self.nameTextField.frame.size.width, 0.3f);
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
- (IBAction)goToSignIn:(id)sender {
    MESignInViewController *purchaseContr = (MESignInViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MESignInViewController"];
    [self.navigationController pushViewController:purchaseContr animated:YES];
     
     }

- (IBAction)creatUser:(UIButton *)sender {
    if (_emailTextField.text.length>0 && _nameTextField.text.length>0 && _passwordTextField.text.length>0) {
        
        FIRAuthCredential *credential =
        [FIREmailPasswordAuthProvider credentialWithEmail:_emailTextField.text
                                                 password:_passwordTextField.text];
        
        
        [[FIRAuth auth].currentUser linkWithCredential:credential
                                              completion:^(FIRUser *_Nullable user,
                                                           NSError *_Nullable error) {
                                                  
                                                  if (error == nil) {
                                                      FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
                                                      changeRequest.displayName = _nameTextField.text;
                                                      [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                                                          if (error == nil) {
                                                              UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"Add a profile photo?" message:@"Select a photo from gallery or use the camera to take one now" preferredStyle:UIAlertControllerStyleActionSheet];
                                                              UIAlertAction *gallery =[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                                  picker.delegate = self;
                                                                  picker.allowsEditing = YES;
                                                                  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                  
                                                                  [self presentViewController:picker animated:YES completion:NULL];
                                                              }];
                                                              UIAlertAction *camera =[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                                  picker.delegate = self;
                                                                  picker.allowsEditing = YES;
                                                                  picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                  
                                                                  [self presentViewController:picker animated:YES completion:NULL];
                                                              }];
                                                              UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"No, dont upload photo" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                                              }];
                                                              [aler addAction:gallery];
                                                              [aler addAction:camera];
                                                              [aler addAction:cancel];
                                                              [self presentViewController:aler animated:YES completion:^{
                                                                  
                                                              }];
                                                          } else {
                                                              UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"Sign Up error!" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                                              UIAlertAction *OK =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                                              [aler addAction:OK];
                                                              [self presentViewController:aler animated:YES completion:nil];
                                                          }
                                                      }];
                                                  }
                                                  else{
                                                      UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"Sign Up error!" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                                      UIAlertAction *OK =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                                      [aler addAction:OK];
                                                      [self presentViewController:aler animated:YES completion:nil];
                                                  }
                                                  
                                              }];
    }
    else{
        
    }
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error == nil) {
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential =
        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
                                         accessToken:authentication.accessToken];
        
        [[FIRAuth auth].currentUser linkWithCredential:credential
                                            completion:^(FIRUser *_Nullable user,
                                                         NSError *_Nullable error) {
                                                if (error == nil) {
                                                    id<FIRUserInfo> profile = [user.providerData firstObject];
                                                    if (profile.photoURL) {
                                                        
                                                        FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
                                                        changeRequest.displayName = profile.displayName;
                                                        changeRequest.photoURL = profile.photoURL;
                                                        [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                                                            if (!error) {
                                                                [self dismissViewControllerAnimated:YES completion:nil];
                                                            }
                                                            else{
                                                                UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"Sign Up error!" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                                                UIAlertAction *OK =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                    [self dismissViewControllerAnimated:YES completion:nil];
                                                                }];
                                                                [aler addAction:OK];
                                                                [self presentViewController:aler animated:YES completion:nil];
                                                            }
                                                        }];
                                                    }
                                                    else{
                                                        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"Add a profile photo?" message:@"Select a photo from gallery or use the camera to take one now" preferredStyle:UIAlertControllerStyleActionSheet];
                                                        UIAlertAction *gallery =[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                            picker.delegate = self;
                                                            picker.allowsEditing = YES;
                                                            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                            
                                                            [self presentViewController:picker animated:YES completion:NULL];
                                                        }];
                                                        
                                                        UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"No, dont upload photo" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                            FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
                                                            changeRequest.displayName = profile.displayName;
                                                            [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                                                                if (!error) {
                                                                    [self dismissViewControllerAnimated:YES completion:nil];
                                                                }
                                                                else{
                                                                    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"Sign Up error!" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                                                    UIAlertAction *OK =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                                    }];
                                                                    [aler addAction:OK];
                                                                    [self presentViewController:aler animated:YES completion:nil];
                                                                }
                                                            }];

                                                        }];
                                                        
                                                        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                            UIAlertAction *camera =[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                                picker.delegate = self;
                                                                picker.allowsEditing = YES;
                                                                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                
                                                                [self presentViewController:picker animated:YES completion:NULL];
                                                            }];
                                                            [aler addAction:camera];
                                                        }
                                                        
                                                        [aler addAction:gallery];
                                                        [aler addAction:cancel];
                                                        [self presentViewController:aler animated:YES completion:^{
                                                            
                                                        }];

                                                    }
                                                    
                                                }
                                                else{
                                                    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"Sign Up error!" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                                                    UIAlertAction *OK =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                                    [aler addAction:OK];
                                                    [self presentViewController:aler animated:YES completion:nil];
                                                }
                                            }];
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIImage *croppedImage = [self imageWithImage:chosenImage scaledToSize:CGSizeMake(150, 150)];
    id<FIRUserInfo> profile = [[FIRAuth auth].currentUser.providerData firstObject];
    
    switch (_signUpType) {
        case GoogleSignUpType:{
            
            FIRStorageReference *storageRef = [[FIRStorage storage] referenceForURL:[NSString stringWithFormat:@"gs://project-6315208343721683318.appspot.com/author_image/%@.jpg",profile.uid]];
            [storageRef putData:UIImageJPEGRepresentation(croppedImage, 0.1) metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata2, NSError * _Nullable error) {
                if (!error) {
                    FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
                    changeRequest.displayName = profile.displayName;
                    changeRequest.photoURL = metadata2.downloadURL;
                    [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                        if (!error) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                        else{
                            UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"Sign Up error!" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *OK =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [self dismissViewControllerAnimated:YES completion:nil];
                            }];
                            [aler addAction:OK];
                            [self presentViewController:aler animated:YES completion:nil];
                        }
                    }];
                    
                }
                else{
                    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"Sign Up error!" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *OK =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [aler addAction:OK];
                    [self presentViewController:aler animated:YES completion:nil];
                }
            }];
        }
            break;
            
            
        case EmailSignUpType:{
            FIRStorageReference *storageRef = [[FIRStorage storage] referenceForURL:[NSString stringWithFormat:@"gs://project-6315208343721683318.appspot.com/author_image/%@.jpg",profile.uid]];
            [storageRef putData:UIImageJPEGRepresentation(croppedImage, 0.1) metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata2, NSError * _Nullable error) {
                if (!error) {
                    FIRUserProfileChangeRequest *changeRequest = [[FIRAuth auth].currentUser profileChangeRequest];
                    changeRequest.photoURL = metadata2.downloadURL;
                    [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                        if (!error) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                        else{
                            UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"Sign Up error!" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *OK =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [self dismissViewControllerAnimated:YES completion:nil];
                            }];
                            [aler addAction:OK];
                            [self presentViewController:aler animated:YES completion:nil];
                        }
                    }];
                }
                else{
                    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"Sign Up error!" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *OK =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [aler addAction:OK];
                    [self presentViewController:aler animated:YES completion:nil];
                }
            }];
        }
            break;
            
        default:
            break;
    }
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
