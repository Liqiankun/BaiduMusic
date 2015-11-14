//
//  MusicTool.m
//  
//
//  Created by DavidLee on 15/10/24.
//
//

#import "MusicTool.h"

@implementation MusicTool

static NSArray *_musics;
static NSDictionary *_playMusic;

+(NSArray*)musics
{
    if (!_musics) {
        NSString *str = [[NSBundle mainBundle] pathForResource:@"Musics.plist" ofType:nil];
        _musics = [NSArray arrayWithContentsOfFile:str];
    }
    
    return _musics;
}

+(NSDictionary*)playingMusic
{
    return _playMusic;
}

+(void)setPlayingMusic:(NSDictionary*)music
{
    if (!music || ![[self musics] containsObject:music]) {
        return;
    }
    if (_playMusic == music) {
        return;
    }
    
    _playMusic = music;
}

+(NSDictionary*)nextMusic
{
    NSInteger nextIndex = 0;
    if (_playMusic) {
        NSInteger index = [[self musics] indexOfObject:_playMusic];
        nextIndex = index + 1;
        if (nextIndex >= [self musics].count) {
            nextIndex = 0;
        }
    }
    
    return [self musics] [nextIndex];
    
}

+(NSDictionary*)perviousMusic
{
    NSInteger perviousIndex = 0;
    if (_playMusic) {
        NSInteger index = [[self musics] indexOfObject:_playMusic];
       perviousIndex = index - 1;
        if (perviousIndex < 0) {
            perviousIndex = [self musics].count - 1;
        }
    }
    return [self musics][perviousIndex];
}

@end
