//
//  PhotoMapViewController.h
//  iOS2Lab1x
//
//  Created by James Derry on 11/9/13.
//  Copyright (c) 2013 James Derry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Photo.h"
#import "PhotoGeocodeManager.h"

@interface PhotoMapViewController : UIViewController <MKMapViewDelegate, PhotoGeocodeManagerDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSArray *gallery;

@end
