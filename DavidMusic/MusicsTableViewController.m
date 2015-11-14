//
//  MusicsTableViewController.m
//  
//
//  Created by DavidLee on 15/10/24.
//
//

#import "MusicsTableViewController.h"
#import "UIImage+MJ.h"
#import "MusicModel.h"
#import "PlayingViewController.h"
#import "MusicTool.h"
@interface MusicsTableViewController ()

@property(nonatomic,strong)PlayingViewController *playVC;

@end

@implementation MusicsTableViewController



-(PlayingViewController*)playVC
{
    if (!_playVC) {
        
        _playVC = [[PlayingViewController alloc] init];
    }
    
    return _playVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"音乐列表";
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [MusicTool musics].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"music";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellid];
    }
    
    NSDictionary *musicDic =  [MusicTool musics][indexPath.row];
    cell.textLabel.text = musicDic[@"name"];
    cell.detailTextLabel.text = musicDic[@"singer"];
    cell.imageView.image = [UIImage circleImageWithName:musicDic[@"singerIcon"] borderWidth:2 borderColor:[UIColor cyanColor]];;
   
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MusicTool setPlayingMusic:[MusicTool musics][indexPath.row]];
    [self.playVC show];
}
@end
