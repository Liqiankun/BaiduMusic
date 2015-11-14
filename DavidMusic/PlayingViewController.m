//
//  PlayingViewController.m
//  
//
//  Created by DavidLee on 15/10/24.
//
//

#import "PlayingViewController.h"
#import "UIView+Extension.h"
#import "MusicTool.h"
#import "HMAudioTool.h"
#import <AVFoundation/AVFoundation.h>
#import "LrcView.h"
#import <MediaPlayer/MediaPlayer.h>
@interface PlayingViewController ()<AVAudioPlayerDelegate>

@property(nonatomic,strong) NSDictionary *playingMusic;
@property(nonatomic,strong) NSTimer *progressTime;
@property(nonatomic,strong) AVAudioPlayer *player;
@property(nonatomic,strong) CADisplayLink *lrcTimer;
@end

@implementation PlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentView.y = self.currentView.superview.height - 15 - self.currentView.height;
    self.currentView.layer.cornerRadius = 10;
}

-(void)addProgressTimer
{
    
    if (self.player.isPlaying == NO) {
        return;
    }
     
    [self removeProgressTimer];
    [self updateCurrentTime];
    self.progressTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.progressTime forMode:NSRunLoopCommonModes];
}

-(void)removeProgressTimer
{
    [self.progressTime invalidate];
    self.progressTime = nil;
}


-(void)addLrcTimer
{
    
    if (self.player.isPlaying == NO || self.lrcView.isHidden) {
        return;
    }
    
    [self removeLrcTimer];
    //[self updateCurrentTime];
    [self updateLrcLine];
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcLine)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}


-(void)updateLrcLine
{
    self.lrcView.currentTime = self.player.currentTime;
}

-(void)updateCurrentTime
{
    double progress = self.player.currentTime / self.player.duration;
    
    CGFloat sliderMaxX = self.view.width - self.slider.width;
    self.slider.x = sliderMaxX * progress;
    
    [self.slider setTitle:[self stringWithTime:self.player.currentTime] forState:UIControlStateNormal];
    
    self.progressView.width = self.slider.center.x;
}
-(void)show{
    UIWindow *win = [[UIApplication sharedApplication].windows lastObject];
    self.view.hidden = NO;
    self.view.frame = win.bounds;
    self.view.y = self.view.height;
    [win addSubview:self.view];
    win.userInteractionEnabled = NO;
    
    if (self.playingMusic != [MusicTool playingMusic]) {
        [self resetPlayingMusic];
    }
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        
        
        [self setupPlayingMusic];
        win.userInteractionEnabled = YES;
        
    }];
}

-(void)setupPlayingMusic
{
    if (self.playingMusic == [MusicTool playingMusic]) {
         [self addProgressTimer];
        [self addLrcTimer];
        return;
    }
    
    self.playingMusic = [MusicTool playingMusic];
    self.backImage.image = [UIImage imageNamed:self.playingMusic[@"icon"]];
    self.singerName.text = self.playingMusic[@"singer"];
    self.songName.text = self.playingMusic[@"name"];
    
    self.player =  [HMAudioTool playMusic:self.playingMusic[@"filename"]];
    
    self.player.delegate = self;
    self.durationTime.text = [self stringWithTime:self.player.duration];
    [self addProgressTimer];
    [self addLrcTimer];
    self.playOrPauseButton.selected = YES;
    
    self.lrcView.lrcFilename = self.playingMusic[@"lrcname"];
    
    [self updateLockedScreenMusic];
}

-(void)updateLockedScreenMusic
{
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[MPMediaItemPropertyAlbumTitle] = self.playingMusic[@"name"];
    info[MPMediaItemPropertyAlbumArtist] = self.playingMusic[@"singer"];
    info[MPMediaItemPropertyTitle] = self.playingMusic[@"name"];
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:self.playingMusic[@"icon"]]];
    info[MPMediaItemPropertyPlaybackDuration] = @(self.player.duration);
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.player.currentTime);
    center.nowPlayingInfo = info;
    
    //远程控制事件
    
    //加速控制事件
    
    //触摸事件
    
    //检测远程事件
    //1,必须成为第一响应者
    [self becomeFirstResponder];
    //2，开始监控
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

-(NSString*)stringWithTime:(NSTimeInterval)time
{
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%d:%d",minute,second];
}
-(void)resetPlayingMusic
{
    self.backImage.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.singerName.text = @"";
    self.songName.text = @"";
    self.durationTime.text = @"";
    
    [HMAudioTool stopMusic:self.playingMusic[@"filename"]];
    self.player = nil;
    [self removeProgressTimer];
    [self removeLrcTimer];
    self.playOrPauseButton.selected = NO;
}

- (IBAction)exit {
    
    [self removeProgressTimer];
    [self removeLrcTimer];
    UIWindow *win = [[UIApplication sharedApplication].windows lastObject];
    win.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.y = self.view.height;
    } completion:^(BOOL finished) {
        self.view.hidden = YES;
        win.userInteractionEnabled = YES;
    }];
}

- (IBAction)lyricOrImg:(UIButton*)sender {
    
    if (self.lrcView.isHidden) {
        self.lrcView.hidden = NO;
        sender.selected = YES;
        [self addLrcTimer];
    }else{
        self.lrcView.hidden = YES;
          sender.selected = NO;
        [self removeLrcTimer];
    }
}



- (IBAction)tapProgressView:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:sender.view];
    
    self.player.currentTime = (point.x / sender.view.width) * self.player.duration;
    [self updateCurrentTime];
    
}

- (IBAction)panSlider:(UIPanGestureRecognizer *)sender {
    
    
    CGPoint point = [sender translationInView:sender.view];
    [sender setTranslation:CGPointZero inView:sender.view];
    
    
    self.slider.x += point.x;
    
    self.progressView.width = self.slider.center.x;
    
    CGFloat sliderMaxX = self.view.width - self.slider.width;
    double progress = self.slider.x / sliderMaxX;
    NSTimeInterval time = self.player.duration * progress;
    
    self.currentView.x = self.slider.x;
    //self.currentView.y = self.currentView.superview.height - 5 - self.currentView.height;
    [self.slider setTitle:[self stringWithTime:time] forState:UIControlStateNormal];
    
    //设置指示
     [self.currentView setTitle:[self stringWithTime:time] forState:UIControlStateNormal];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self removeProgressTimer];
        self.currentView.hidden = NO;
        
    }else if (sender.state == UIGestureRecognizerStateEnded){
        
        
        //设置播放时间2
        self.player.currentTime = time;
        if (self.player.isPlaying) {
                [self addProgressTimer];
        }
        
    
        
        self.currentView.hidden = YES;
    }

}



- (IBAction)playOrPause:(UIButton *)sender {
    
    if (self.player.isPlaying  ) {
        self.playOrPauseButton.selected = NO;
        [self removeProgressTimer];
        //[self removeLrcTimer];
        [HMAudioTool pauseMusic:self.playingMusic[@"filename"]];
    }else {
        self.playOrPauseButton.selected = YES;
        [self addProgressTimer];
        [self addLrcTimer];
        [HMAudioTool playMusic:self.playingMusic[@"filename"]];
        
        [self updateLockedScreenMusic];

    }
   
}

- (IBAction)previous:(UIButton *)sender {
    
    UIWindow *win = [[UIApplication sharedApplication].windows lastObject];
    win.userInteractionEnabled = NO;
    
    [self resetPlayingMusic];
    [MusicTool setPlayingMusic:[MusicTool perviousMusic]];
    [self setupPlayingMusic];
    
    win.userInteractionEnabled = YES;
}

- (IBAction)next:(UIButton *)sender {
    
    UIWindow *win = [[UIApplication sharedApplication].windows lastObject];
    win.userInteractionEnabled = NO;
    
    [self resetPlayingMusic];
    [MusicTool setPlayingMusic:[MusicTool nextMusic]];
    [self setupPlayingMusic];
    
     win.userInteractionEnabled = YES; 
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self next:nil];
}


-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    if (self.player.isPlaying) {
        [self playOrPause:nil];
    }
}

//远程控制事件监听
-(BOOL)canBecomeFirstResponder
{
    return YES;
}


-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
//    
//    UIEventSubtypeRemoteControlPlay                 = 100,
//    UIEventSubtypeRemoteControlPause                = 101,
//    UIEventSubtypeRemoteControlStop                 = 102,
//    UIEventSubtypeRemoteControlTogglePlayPause      = 103,
//    UIEventSubtypeRemoteControlNextTrack            = 104,
//    UIEventSubtypeRemoteControlPreviousTrack        = 105,
//    UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
//    UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
//    UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
//    UIEventSubtypeRemoteControlEndSeekingForward    = 109,
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPause:
        case UIEventSubtypeRemoteControlPlay:
            [self playOrPause:nil];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self next:nil];
            
        case  UIEventSubtypeRemoteControlPreviousTrack :
            [self previous:nil];
        default:
            break;
    }
}






@end
