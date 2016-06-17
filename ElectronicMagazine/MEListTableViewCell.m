//
//  MEListTableViewCell.m
//  ElectronicMagazine
//
//  Created by Abbin Varghese on 15/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "MEListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MEApplicationHelper.h"
#import "MEUserSignINUPViewController.h"

@implementation MEListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setArticleObject:(MEArticle *)articleObject{
    
    _articleObject2 = articleObject;
    _authorLabel.text = articleObject.articleAuthor;
    
    NSTimeInterval theTimeInterval = [articleObject.articleTimestamp doubleValue];
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    // Create the NSDates
    NSDate *date2 = [[NSDate alloc] init];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:theTimeInterval];
    // Get conversion to months, days, hours, minutes
    NSCalendarUnit unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth;
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    if ([breakdownInfo month]>0) {
        _timeLabel.text = [NSString stringWithFormat:@"%ldm",(long)[breakdownInfo month]];
    }
    else if ([breakdownInfo day]>0){
        _timeLabel.text = [NSString stringWithFormat:@"%ldd",(long)[breakdownInfo day]];
    }
    else if ([breakdownInfo hour]>0){
        _timeLabel.text = [NSString stringWithFormat:@"%ldhr",(long)[breakdownInfo hour]];
    }
    else{
        _timeLabel.text = [NSString stringWithFormat:@"%ldmin",(long)[breakdownInfo minute]];
    }
    _headingTextView.text = articleObject.articleHeading;
    
    _headingTextView.font = [UIFont fontWithName:@".SFUIDisplay-Light" size:self.frame.size.height/20];
    
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:articleObject.articleImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [_authorPhotoImageView sd_setImageWithURL:[NSURL URLWithString:articleObject.articleAuthorPhotoUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [_websiteLabel setTitle:articleObject.articleWebsite forState:UIControlStateNormal];

}

- (IBAction)flag:(UIButton *)sender {
    [MEApplicationHelper flagArticle:_articleObject2];
}

- (IBAction)share:(UIButton *)sender {

    NSURL *myWebsite = [NSURL URLWithString:_articleObject2.articleWebpageUrl];
    
    NSArray *objectsToShare = @[myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo,
                                   UIActivityTypePostToTencentWeibo,
                                   UIActivityTypeOpenInIBooks];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    UITableView *tv = (UITableView *) self.superview.superview;
    UIViewController *vc = (UITableViewController *) tv.dataSource;
    
    [vc presentViewController:activityVC animated:YES completion:nil];
}


- (IBAction)save:(UIButton *)sender {
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                    FIRUser *_Nullable user) {
        if (user != nil && !user.anonymous) {
            
        } else {
            UITableView *tv = (UITableView *) self.superview.superview;
            UIViewController *vc = (UITableViewController *) tv.dataSource;
            MEUserSignINUPViewController *purchaseContr = (MEUserSignINUPViewController *)[vc.storyboard instantiateViewControllerWithIdentifier:@"MEUserSignINUPViewController"];
            [vc presentViewController:purchaseContr animated:YES completion:nil];
        }
    }];
}

@end
