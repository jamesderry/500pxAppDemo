//
//  Photo.h
//  iOS2Lab1x
//
//  Created by James Derry on 11/4/13.
//  Copyright (c) 2013 James Derry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Photo : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *user;
@property(nonatomic, copy) NSString *imageURL;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *country;
@property(nonatomic, copy) NSString *userPicURL;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) CLLocation *location;
@property(nonatomic, strong) MKPlacemark *placemark;

@end
