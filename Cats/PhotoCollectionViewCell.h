//
//  PhotoCollectionViewCell.h
//  Cats
//
//  Created by Chris Dean on 2018-03-01.
//  Copyright © 2018 Chris Dean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (nonatomic) NSURLSessionDownloadTask *downloadTask;

@end
