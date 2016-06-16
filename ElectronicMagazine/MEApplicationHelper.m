//
//  MEApplicationHelper.m
//  MAG-E
//
//  Created by Abbin Varghese on 09/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "MEApplicationHelper.h"
#import "AppDelegate.h"


NSString *const articleImageUrl = @"articleImageUrl";
NSString *const articleHeading = @"articleHeading";
NSString *const articleAuthor = @"articleAuthor";
NSString *const articleTimeStamp = @"articleTimestamp";
NSString *const articlePath = @"Articles";
NSString *const ArticlesForReview = @"ArticlesForReview";
NSString *const articleWebsite = @"articleWebsite";
NSString *const articleUID = @"articleuUID";
NSString *const articleWebpageUrl = @"articleWebpageUrl";
NSString *const articleAuthorPhotoUrl = @"articleAuthorPhotoUrl";
NSString *const articleFlag = @"articleFlag";

@implementation MEApplicationHelper

+ (MEApplicationHelper*)sharedHelper {
    static MEApplicationHelper *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = appDelegate.managedObjectContext;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)startListeningToBDChanges:(void (^)(NSArray *modifiedArray))success{
    
    FIRDatabaseQuery *recentPostsQuery = [[[[FIRDatabase database] reference] child:articlePath] queryLimitedToLast:100];
    [recentPostsQuery keepSynced:YES];
    
    [recentPostsQuery observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"%@",snapshot.value);
        if (![snapshot.value isEqual:[NSNull null]]) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
            dispatch_async(queue, ^{
                
                NSArray *array = [snapshot.value allObjects];
                NSMutableArray *newArray = [NSMutableArray new];
                
                NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:articleTimeStamp  ascending:NO];
                array=[array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
                
                for (NSDictionary *dict in array) {
                    MEArticle *newArt = [[MEArticle alloc]init];
                    @try {
                        newArt.articleAuthor = [dict valueForKey:articleAuthor];
                    } @catch (NSException *exception) {
                        newArt.articleAuthor = @"";
                        NSLog(@"author exception");
                    }
                    @try {
                        newArt.articleHeading = [dict valueForKey:articleHeading];
                    } @catch (NSException *exception) {
                        newArt.articleHeading = @"";
                        NSLog(@"heading exception");
                    }
                    @try {
                        newArt.articleImageUrl = [dict valueForKey:articleImageUrl];
                    } @catch (NSException *exception) {
                        newArt.articleImageUrl = @"";
                        NSLog(@"imageurl exception");
                    }
                    @try {
                        newArt.articleTimestamp = [NSNumber numberWithDouble:[[dict valueForKey:articleTimeStamp] doubleValue]];
                    } @catch (NSException *exception) {
                        newArt.articleTimestamp = 0;
                        NSLog(@"timestamp exception");
                    }
                    @try {
                        newArt.articleuUID = [dict valueForKey:articleUID];
                    } @catch (NSException *exception) {
                        newArt.articleuUID = @"";
                        NSLog(@"uID exception");
                    }
                    @try {
                        newArt.articleWebsite = [dict valueForKey:articleWebsite];
                    } @catch (NSException *exception) {
                        newArt.articleWebsite = @"";
                        NSLog(@"website exception");
                    }
                    @try {
                        newArt.articleWebpageUrl = [dict valueForKey:articleWebpageUrl];
                    } @catch (NSException *exception) {
                        newArt.articleWebpageUrl = @"";
                        NSLog(@"website exception");
                    }
                    @try {
                        newArt.articleAuthorPhotoUrl = [dict valueForKey:articleAuthorPhotoUrl];
                    } @catch (NSException *exception) {
                        newArt.articleAuthorPhotoUrl = @"";
                        NSLog(@"website exception");
                    }
                    
                    [newArray addObject:newArt];
                    
                }
                
                success(newArray);
                
            });
        }
        else{
            success([NSMutableArray new]);
        }
        
    }];
}

- (void)_mocDidSaveNotification:(NSNotification *)notification
{
    NSManagedObjectContext *savedContext = [notification object];
    
    // ignore change notifications for the main MOC
    if (_managedObjectContext == savedContext)
    {
        return;
    }
    
    if (_managedObjectContext.persistentStoreCoordinator != savedContext.persistentStoreCoordinator)
    {
        // that's another database
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [_managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    });
}

+(void)postArticleForReview:(NSURL*)articleUrl withHeading:(NSString*)heading{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{

        FIRDatabaseReference *ref = [[FIRDatabase database] reference];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              heading,articleHeading,
                              @"Dummy Author",articleAuthor,
                              [self getRootDomain:articleUrl],articleWebsite,
                              [NSString stringWithFormat:@"%@",articleUrl],articleWebpageUrl,
                              @"Dummy Url", articleAuthorPhotoUrl, nil];
        [[[ref child:ArticlesForReview] childByAutoId] setValue:dict];
        
    });
}

+(NSString *)getRootDomain:(NSURL *)domain{
    NSString *host = domain.host;
    NSArray *arra = [host componentsSeparatedByString:@"."];
    @try {
        NSString *name = [arra objectAtIndex:1];
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
        
        /* get first char */
        NSString *firstChar = [name substringToIndex:1];
        
        /* remove any diacritic mark */
        NSString *folded = [firstChar stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:locale];
        
        /* create the new string */
        host = [[folded uppercaseString] stringByAppendingString:[name substringFromIndex:1]];
        
    } @catch (NSException *exception) {
        host = @"";
    }
    return host;
}

+(void)flagArticle:(MEArticle*)article{
    FIRDatabaseReference *ref = [[[[FIRDatabase database] reference] child:articlePath]child:article.articleuUID];

    [ref runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
        NSMutableDictionary *post = currentData.value;
        if (!post || [post isEqual:[NSNull null]]) {
            return [FIRTransactionResult successWithValue:currentData];
        }

        int starCount = [post[articleFlag] intValue];
        starCount++;
        post[articleFlag] = [NSNumber numberWithInt:starCount];
        
        // Set value and report transaction success
        [currentData setValue:post];
        return [FIRTransactionResult successWithValue:currentData];
    } andCompletionBlock:^(NSError * _Nullable error,
                           BOOL committed,
                           FIRDataSnapshot * _Nullable snapshot) {
        // Transaction completed
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thank you!" message:@"This article has been sent for review and will be removed if it failes" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            UIWindow *window=[UIApplication sharedApplication].keyWindow;
            UIViewController *root = [window rootViewController];
            [root presentViewController:alert animated:YES completion:^{
                
            }];
        }
    }];
}

+(void)saveArticle:(MEArticle*)article{
    
}

@end
