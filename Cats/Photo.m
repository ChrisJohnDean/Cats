//
//  Photo.m
//  Cats
//
//  Created by Chris Dean on 2018-03-01.
//  Copyright © 2018 Chris Dean. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)initWithDict:(NSDictionary*)photo {
    self = [super init];
    if (self) {
        
        NSNumber *farm = photo[@"farm"];
        NSNumber *server = photo[@"server"];
        NSNumber *photoId = photo[@"id"];
        NSString *secret = photo[@"secret"];
        
        NSString *urlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farm, server, photoId, secret];
        
        _url = [NSURL URLWithString:urlString];
    }
    return self;
}

@end
