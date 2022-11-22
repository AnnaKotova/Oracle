//
//  HistoryTableViewController.m
//  Oracle
//
//  Created by Ann Kotova on 12/14/16.
//  Copyright © 2016 Anna Kotova. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "History.h"
#import "NSFileManagerExtension.h"
#import "DetailsViewController.h"
#import "LocalStorageManager.h"
#import "BaseViewController.h"
#import "DecorationManager.h"

static NSString * const kReusableCellWithIdentifier = @"kReusableCellWithIdentifier";

@interface HistoryTableViewController ()
{
    NSMutableArray * _historyArray;
    UIImageView * _backgroundImageView;
    UILabel * _noResultLabel;
}
@end

@implementation HistoryTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:179.0f/255.0f green:186.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    
    _historyArray = [History allHistory].mutableCopy;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kReusableCellWithIdentifier];
    if (_historyArray.count == 0) {
        _noResultLabel = [UILabel new];
        _noResultLabel.textColor = [UIColor blackColor];
        _noResultLabel.font = _BoldFont();
        _noResultLabel.textAlignment = NSTextAlignmentCenter;
        _noResultLabel.text = NSLocalizedString( @"HistoryTableViewController_No_Result_Label", nil);
        [self.tableView addSubview:_noResultLabel];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _noResultLabel.frame = self.view.frame;
    _noResultLabel.center = self.view.center;

//    CGRect frame = self.view.frame;
//    frame.origin.x = kNavigationBarHeight;
//    frame.size.height -= kNavigationBarHeight;
//    self.tableView.frame = frame;
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
    [tableView setEditing:YES animated:YES];
    History * info = _historyArray[indexPath.row];
    DetailsViewController * detailsViewController = [[DetailsViewController alloc] initWithInfo:info];
    [self.navigationController pushViewController:detailsViewController animated:YES];
    [tableView setEditing:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        History * deleledObject = _historyArray[indexPath.row];
        [[LocalStorageManager sharedManager] removeObject:deleledObject inContext:nil];
        [[LocalStorageManager sharedManager] saveContext];
        [_historyArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
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

@end
