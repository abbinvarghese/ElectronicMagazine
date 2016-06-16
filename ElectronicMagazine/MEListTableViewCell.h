//
//  MEListTableViewCell.h
//  ElectronicMagazine
//
//  Created by Abbin Varghese on 15/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MERoundedImageView.h"
#import "MEArticle.h"

@interface MEListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MERoundedImageView *authorPhotoImageView;
@property (weak, nonatomic) IBOutlet UITextView *headingTextView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIButton *websiteLabel;
@property (strong, nonatomic) MEArticle *articleObject;
@property (strong, nonatomic) MEArticle *articleObject2;


@end
