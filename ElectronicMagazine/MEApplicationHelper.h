//
//  MEApplicationHelper.h
//  MAG-E
//
//  Created by Abbin Varghese on 09/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

FOUNDATION_EXPORT NSString *const articleImageUrl;
FOUNDATION_EXPORT NSString *const articleHeading;
FOUNDATION_EXPORT NSString *const articleWebsite;
FOUNDATION_EXPORT NSString *const articleAuthor;
FOUNDATION_EXPORT NSString *const articleTimeStamp;
FOUNDATION_EXPORT NSString *const articlePath;
FOUNDATION_EXPORT NSString *const ArticlesForReview;
FOUNDATION_EXPORT NSString *const articleUID;
FOUNDATION_EXPORT NSString *const articleWebpageUrl;
FOUNDATION_EXPORT NSString *const articleAuthorPhotoUrl;

@interface MEApplicationHelper : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *tmpContext;

+ (MEApplicationHelper*)sharedHelper;

-(void)startListeningToBDChanges:(void (^)(NSArray *modifiedArray))success;

+(void)postArticleForReview:(NSURL*)articleUrl withHeading:(NSString*)heading;

@end
