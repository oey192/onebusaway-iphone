//
//  OBAStaticTableViewController.m
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 12/6/15.
//  Copyright © 2015 OneBusAway. All rights reserved.
//

#import "OBAStaticTableViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "OBATableCell.h"
#import "OBAViewModelRegistry.h"

@interface OBAStaticTableViewController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(nonatomic,strong,readwrite) UITableView *tableView;
@end

@implementation OBAStaticTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = ({
        UITableView *tv = [[UITableView alloc] initWithFrame:self.view.bounds];
        tv.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        tv.delegate = self;
        tv.dataSource = self;
        tv.tableFooterView = [UIView new];

        tv;
    });

    NSArray *registered = [OBAViewModelRegistry registeredClasses];

    for (Class c in registered) {
        [c registerViewsWithTableView:self.tableView];
    }

    [self.view addSubview:self.tableView];

    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

#pragma mark - Public Methods

- (OBABaseRow*)rowAtIndexPath:(NSIndexPath*)indexPath {
    OBATableSection *section = self.sections[indexPath.section];
    OBABaseRow *row = section.rows[indexPath.row];

    return row;
}

#pragma mark - UITableView Section Headers

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    UIView *headerView = [self tableView:tableView viewForHeaderInSection:section];

    if (headerView) {
        return CGRectGetHeight(headerView.frame);
    }
    else {
        return UITableViewAutomaticDimension;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sections[section].headerView;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section].title;
}

#pragma mark - UITableView Section Footers

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    UIView *footerView = [self tableView:tableView viewForFooterInSection:section];

    if (footerView) {
        return CGRectGetHeight(footerView.frame);
    }
    else {
        return 0.f;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.sections[section].footerView;
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    OBATableSection *section = self.sections[sectionIndex];
    return section.rows.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OBABaseRow *row = [self rowAtIndexPath:indexPath];
    NSString *reuseIdentifier = [row cellReuseIdentifier];

    UITableViewCell<OBATableCell> *cell = (UITableViewCell<OBATableCell> *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];

    OBAGuard([cell conformsToProtocol:@protocol(OBATableCell)]) else {
        return nil;
    }

    cell.tableRow = row;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self rowAtIndexPath:indexPath] indentationLevel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    OBABaseRow *row = [self rowAtIndexPath:indexPath];

    if (tableView.editing && row.editAction) {
        row.editAction();
    }
    else if (!tableView.editing && row.action) {
        row.action();
    }
}

#pragma mark - DZNEmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {

    if (!self.emptyDataSetTitle) {
        return nil;
    }

    NSDictionary *attributes = @{NSFontAttributeName: [OBATheme titleFont],
                                 NSForegroundColorAttributeName: [OBATheme darkDisabledColor]};

    return [[NSAttributedString alloc] initWithString:self.emptyDataSetTitle attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (!self.emptyDataSetDescription) {
        return nil;
    }

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSFontAttributeName: [OBATheme bodyFont],
                                 NSForegroundColorAttributeName: [OBATheme lightDisabledColor],
                                 NSParagraphStyleAttributeName: paragraph};

    return [[NSAttributedString alloc] initWithString:self.emptyDataSetDescription attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    // Totally arbitrary value. It just 'looks right'.
    return -44;
}

@end
