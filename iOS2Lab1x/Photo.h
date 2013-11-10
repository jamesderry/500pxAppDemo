//
//  Photo.h
//  iOS2Lab1x
//
//  Created by James Derry on 11/4/13.
//  Copyright (c) 2013 James Derry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *user;
@property(nonatomic, copy) NSString *imageURL;
@property(nonatomic, strong) UIImage *image;

@end
