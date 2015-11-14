//
//  MusicTool.h
//  
//
//  Created by DavidLee on 15/10/24.
//
//

#import <Foundation/Foundation.h>

@interface MusicTool : NSObject
+(NSArray*)musics;
+(NSDictionary*)playingMusic;
+(NSDictionary*)nextMusic;
+(NSDictionary*)perviousMusic;

+(void)setPlayingMusic:(NSDictionary*)music;
@end
