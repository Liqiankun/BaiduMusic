//
//  PlayingViewController.h
//  
//
//  Created by DavidLee on 15/10/24.
//
//

#import <UIKit/UIKit.h>
#import "LrcView.h"
@interface PlayingViewController : UIViewController
-(void)show;
- (IBAction)exit;
- (IBAction)lyricOrImg:(UIButton*)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UILabel *songName;

@property (weak, nonatomic) IBOutlet UILabel *singerName;

@property (weak, nonatomic) IBOutlet UILabel *durationTime;

@property (weak, nonatomic) IBOutlet UIButton *slider;
@property (weak, nonatomic) IBOutlet UIView *progressView;

- (IBAction)tapProgressView:(UITapGestureRecognizer *)sender;

- (IBAction)panSlider:(UIPanGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIButton *currentView;
- (IBAction)playOrPause:(UIButton *)sender;

- (IBAction)previous:(UIButton *)sender;
- (IBAction)next:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet LrcView *lrcView;


@end
