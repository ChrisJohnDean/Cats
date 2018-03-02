//
//  PhotoCollectionViewCell.m
//  Cats
//
//  Created by Chris Dean on 2018-03-01.
//  Copyright © 2018 Chris Dean. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.downloadTask cancel];
    self.photoView.image = nil;
}

@end
