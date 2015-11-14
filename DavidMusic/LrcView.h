//
//  LrcView.h
//  
//
//  Created by DavidLee on 15/10/25.
//
//

#import "DRNRealTimeBlurView.h"

@interface LrcView : DRNRealTimeBlurView

/**
 *  歌词文件名
 */
@property(nonatomic,copy) NSString *lrcFilename;

@property(nonatomic,assign) NSTimeInterval currentTime;

@end
