//
//  LrcCell.m
//  
//
//  Created by DavidLee on 15/10/25.
//
//

#import "LrcCell.h"
#import "LrcLine.h"
@implementation LrcCell


+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *cellid = @"lrcLine";
    LrcCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[LrcCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = self.bounds;
}

- (void)setLrcLine:(LrcLine *)lrcLine
{
    _lrcLine = lrcLine;
    
    self.textLabel.text = lrcLine.word;
}
@end
