//
//  MusicResultsCell.h
//  MusicSearchChallenge
//
//  Created by Victor Wei on 2/21/18.
//  Copyright © 2018 vDub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicResultsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *albumImgView;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;

@end
