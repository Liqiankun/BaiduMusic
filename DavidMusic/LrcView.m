//
//  LrcView.m
//  
//
//  Created by DavidLee on 15/10/25.
//
//

#import "LrcView.h"
#import "LrcLine.h"
#import "LrcCell.h"
#import "UIView+Extension.h"
@interface LrcView()<UITabBarControllerDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *lrcLines;

@property(nonatomic,assign) NSInteger currentIndex;
@end

@implementation LrcView

-(NSMutableArray*)lrcLines
{
    if (!_lrcLines) {
        _lrcLines = [[NSMutableArray alloc] init];
    }
    
    return _lrcLines;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    
    return self;
}

-(void)setUp
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableView];
    self.tableView = tableView;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.height * 0.5, 0,self.tableView.height * 0.5, 0);
}

-(void)setLrcFilename:(NSString *)lrcFilename
{

    _lrcFilename = [lrcFilename copy];
    
    [self.lrcLines removeAllObjects];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:lrcFilename withExtension:nil];
    
    NSString *lrcStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *lrcArray = [lrcStr componentsSeparatedByString:@"\n"];
    
    for (NSString *line in lrcArray) {
        LrcLine *lrcLine = [[LrcLine alloc] init];
        
        [self.lrcLines addObject:lrcLine];
        
        if (![line hasPrefix:@"["]) continue;
        
        if ([line hasPrefix:@"[ti:"] || [line hasPrefix:@"[ar:"] || [line hasPrefix:@"[al:"]) {
            NSString *word = [[line componentsSeparatedByString:@":"] lastObject];
            lrcLine.word = [word substringToIndex:word.length - 1];
            
        }else{
            
            NSArray *array = [line componentsSeparatedByString:@"]"];
            lrcLine.time = [[array firstObject] substringFromIndex:1];
            
            lrcLine.word = [array lastObject];
        }
       
    }
    
    [self.tableView reloadData];

}

-(void)setCurrentTime:(NSTimeInterval)currentTime
{
    
    if (self.currentTime < currentTime) {
        self.currentIndex = -1;
    }
    _currentTime = currentTime;
    int minute = _currentTime / 60;
    int second = (int)_currentTime % 60;
    int msecond = (_currentTime - (int)_currentTime) * 100;
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02d:%02d.%02d",minute,second,msecond];
    
    
    NSInteger count = self.lrcLines.count;
    for (int idx = self.currentIndex + 1 ; idx < count; idx++){
        
        LrcLine *lrcLine = self.lrcLines[idx];
         NSString *currentLineTime = lrcLine.time;
         NSString *nextLineTime = nil;
         
         NSInteger nextIdx = idx + 1;
         
         if (nextIdx < self.lrcLines.count) {
             nextLineTime = [self.lrcLines[nextIdx] time];
         }
         
         
         
         if ([currentTimeStr compare:currentLineTime] != NSOrderedAscending && [currentTimeStr compare:nextLineTime] == NSOrderedAscending && self.currentIndex != idx) {
             NSArray *reloadArray = @[
                                      [NSIndexPath indexPathForRow:self.currentIndex inSection:0],
                                     [NSIndexPath indexPathForRow:idx inSection:0]
                                      ];
              self.currentIndex = idx;
             
             [self.tableView reloadRowsAtIndexPaths:reloadArray withRowAnimation:UITableViewRowAnimationNone];
            
            
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
             [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
             
            
         }
         
         
     };
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcLines.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    LrcCell *cell = [LrcCell cellWithTableView:tableView];
    cell.lrcLine = self.lrcLines[indexPath.row];
    
    if (self.currentIndex == indexPath.row) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    }else{
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return cell;
    
}
@end
























