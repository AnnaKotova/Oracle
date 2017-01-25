//
//  HistoryTableViewController.m
//  Oracle
//
//  Created by Ann Kotova on 12/14/16.
//  Copyright © 2016 Bmuse. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "History.h"
#import "NSFileManagerExtension.h"
#import "DetailsViewController.h"

static NSString * const kReusableCellWithIdentifier = @"kReusableCellWithIdentifier";

@interface HistoryTableViewController ()
{
    NSArray * _historyArray;
}
@end

@implementation HistoryTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _historyArray = [History allHistory];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kReusableCellWithIdentifier];
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(_backAction:)];
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kReusableCellWithIdentifier];
    [self _configureCell:cell forIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    History * info = _historyArray[indexPath.row];
    DetailsViewController * detailsViewController = [[DetailsViewController alloc] initWithInfo:info];
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

#pragma makr - private

- (void)_configureCell:(UITableViewCell *)cell forIndex:(NSInteger)index
{
    History * history = _historyArray[index];
    
    if (history.imagePath.length > 0)
    {
        NSString * filePath = [[[NSFileManager defaultManager] imagesDirectory] stringByAppendingString:history.imagePath];
        UIImage * icon = [UIImage imageWithContentsOfFile:filePath];
        cell.imageView.image = icon;
    }
    
    cell.textLabel.text = history.name;
}

- (void)_backAction:(UIBarButtonItem *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
