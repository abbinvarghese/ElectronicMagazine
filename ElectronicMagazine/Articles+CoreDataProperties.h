//
//  Articles+CoreDataProperties.h
//  ElectronicMagazine
//
//  Created by Abbin Varghese on 15/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Articles.h"

NS_ASSUME_NONNULL_BEGIN

@interface Articles (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *articleAuthor;
@property (nullable, nonatomic, retain) NSString *articleAuthorPhotoUrl;
@property (nullable, nonatomic, retain) NSString *articleHeading;
@property (nullable, nonatomic, retain) NSString *articleImageUrl;
@property (nullable, nonatomic, retain) NSNumber *articleTimestamp;
@property (nullable, nonatomic, retain) NSString *articleuUID;
@property (nullable, nonatomic, retain) NSString *articleWebpageUrl;
@property (nullable, nonatomic, retain) NSString *articleWebsite;

@end

NS_ASSUME_NONNULL_END
