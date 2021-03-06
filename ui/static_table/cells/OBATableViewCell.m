//
//  OBATableViewCell.m
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 2/21/16.
//  Copyright © 2016 OneBusAway. All rights reserved.
//

#import "OBATableViewCell.h"
#import "OBATableRow.h"

@implementation OBATableViewCell
@synthesize tableRow = _tableRow;

- (void)prepareForReuse {
    [super prepareForReuse];

    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.imageView.image = nil;
}

- (void)setTableRow:(OBATableRow *)tableRow
{
    OBAGuardClass(tableRow, OBATableRow) else {
        return;
    }

    _tableRow = [tableRow copy];

    self.textLabel.text = [self tableDataRow].title;
    self.textLabel.textAlignment = [self tableDataRow].textAlignment;
    self.detailTextLabel.text = [self tableDataRow].subtitle;
    self.accessoryType = [self tableDataRow].accessoryType;
    self.imageView.image = [self tableDataRow].image;
}

- (OBATableRow*)tableDataRow {
    return (OBATableRow*)self.tableRow;
}
@end

@implementation OBATableViewCellValue1
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];

    if (self) {
        // no-op, i suppose?
    }
    return self;
}
@end

@implementation OBATableViewCellValue2
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];

    if (self) {
        // no-op, i suppose?
    }
    return self;
}
@end

@implementation OBATableViewCellSubtitle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];

    if (self) {
        // no-op, i suppose?
    }
    return self;
}
@end
