//
//  MEArticle.h
//  ElectronicMagazine
//
//  Created by Abbin Varghese on 15/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEArticle : NSObject

@property (nullable, nonatomic, retain) NSString *articleAuthor;
@property (nullable, nonatomic, retain) NSString *articleAuthorPhotoUrl;
@property (nullable, nonatomic, retain) NSString *articleHeading;
@property (nullable, nonatomic, retain) NSString *articleImageUrl;
@property (nullable, nonatomic, retain) NSNumber *articleTimestamp;
@property (nullable, nonatomic, retain) NSString *articleuUID;
@property (nullable, nonatomic, retain) NSString *articleWebpageUrl;
@property (nullable, nonatomic, retain) NSString *articleWebsite;

@end
