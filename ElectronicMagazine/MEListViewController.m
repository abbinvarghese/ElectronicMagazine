//
//  MEListViewController.m
//  ElectronicMagazine
//
//  Created by Abbin Varghese on 15/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "MEListViewController.h"
#import "MEListTableViewCell.h"
#import "MEApplicationHelper.h"
#import "MEAddViewController.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface MEListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *articleArray;
@property (strong, nonatomic) NSArray *subArticleArray;
@property (weak, nonatomic) IBOutlet UITableView *articleTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation MEListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:UIColorFromRGB(0x5856D6),
       NSFontAttributeName:[UIFont fontWithName:@"Questrial-Regular" size:20]}];
    
     _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.articleTableView addSubview:_refreshControl];
    
    [[MEApplicationHelper sharedHelper]startListeningToBDChanges:^(NSArray *modifiedArray) {
        if (_articleArray==nil) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _articleArray = modifiedArray;
                [_articleTableView reloadData];
            });
        }
        else{
            _subArticleArray = modifiedArray;
        }

    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _articleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MEListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MEListTableViewCell"];
    cell.articleObject = [_articleArray objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.frame.size.height;
}

- (IBAction)refresh:(UIBarButtonItem *)sender {
    if (_subArticleArray.count>0) {
        _articleArray = _subArticleArray;
    }
    [_refreshControl endRefreshing];
    [_articleTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [_articleTableView reloadData];
    
}

@end
