//
//  LrcCell.h
//  
//
//  Created by DavidLee on 15/10/25.
//
//

#import <UIKit/UIKit.h>
@class LrcLine;
@interface LrcCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView*)tableView;
@property(nonatomic,strong)LrcLine *lrcLine;
@end
