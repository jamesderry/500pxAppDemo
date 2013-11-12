//
//  PhotoMapViewController.m
//  iOS2Lab1x
//
//  Created by James Derry on 11/9/13.
//  Copyright (c) 2013 James Derry. All rights reserved.
//

#import "PhotoMapViewController.h"

@interface PhotoMapAnnotation : NSObject <MKAnnotation>
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *key;
@end

@implementation PhotoMapAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate
{
    self = [super init];
    if (self) {
        _coordinate = aCoordinate;
    }
    return self;
}

@end


//now on to our view controller

@interface PhotoMapViewController ()
{
    NSMutableDictionary *photosGroupedByLocationKey;
}
@end

@implementation PhotoMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.mapView.delegate = self;
    [[PhotoGeocodeManager sharedManager] setDelegate:self];
    photosGroupedByLocationKey = [[NSMutableDictionary alloc] init];
    [self geocodeImages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)geocodeImages
{
    if ([self.gallery count] > 0) {
        NSLog(@"self.gallery array size = %lu", (unsigned long)[self.gallery count]);

        for (Photo *photo in self.gallery) {
            NSString *locationKey;
            //NSLog(@"photo.city=%@, photo.country=%@", photo.city, photo.country);
            //store the locations
            if ([photo.city isKindOfClass:[NSNull class]]  || [photo.country isKindOfClass:[NSNull class]])
            {
                NSLog(@"*warning* aborting geocode due to null city/country");
                continue;
            }
            if ([photo.city length]>0) {
                if ([photo.country length]>0) {
                    locationKey = [NSString stringWithFormat:@"%@, %@", [photo.city uppercaseString], [photo.country uppercaseString]];
                    [self groupPhoto:photo byLocationKey:locationKey];
                    [[PhotoGeocodeManager sharedManager] placemarkForLocation:locationKey];
                    
                } else {
                    locationKey = [NSString stringWithFormat:@"%@", [photo.city uppercaseString]];
                    [self groupPhoto:photo byLocationKey:locationKey];
                    [[PhotoGeocodeManager sharedManager] placemarkForLocation:locationKey];
                }
            } else {
                if ([photo.country length]>0) {
                    locationKey = [NSString stringWithFormat:@"%@", [photo.country uppercaseString]];
                    [self groupPhoto:photo byLocationKey:locationKey];
                    [[PhotoGeocodeManager sharedManager] placemarkForLocation:locationKey];
                }
            }
        }
    }
}

- (void)groupPhoto:(Photo *)photo byLocationKey:(NSString *)key
{
    //check if location key is already in dictionary
    NSMutableArray *photos = [photosGroupedByLocationKey objectForKey:key];
    if (photos == nil) {
        // key does not exist or does not have photos yet
        NSMutableArray *group = [[NSMutableArray alloc] initWithObjects:photo, nil];
        [photosGroupedByLocationKey setObject:group forKey:key];
    } else {
        [photos addObject:photo];
        [photosGroupedByLocationKey setObject:photos forKey:key];
    }
}

#pragma mark PhotoGeocodeManagerDelegate

- (void)didObtainPlacemark:(MKPlacemark *)mark forLocation:(NSString *)key
{
    // grab the photo object and set the annotation properties for later display
    NSMutableArray *photos = [photosGroupedByLocationKey objectForKey:key];
    if (photos != nil) {
        if (mark != nil) {
            PhotoMapAnnotation *annotation = [[PhotoMapAnnotation alloc] initWithCoordinate:mark.location.coordinate];
            annotation.title = [(Photo *)[photos objectAtIndex:0] name];
            annotation.subtitle = key;
            annotation.key = key;
            [self.mapView addAnnotation:annotation];
        }
    }
    //NSLog(@"PhotoGeocodeManagerDelegate called.");
    
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MKPinAnnotationView *annotationView in views) {
        // grab the location key from the annotation
        PhotoMapAnnotation *annotation = (PhotoMapAnnotation *)[annotationView annotation];
        NSMutableArray *photos = [photosGroupedByLocationKey objectForKey:annotation.key];
        Photo *photo = [photos objectAtIndex:0];
        
        // construct our thumbnail
        UIImageView *thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 70.0, 70.0)];
        thumbnailView.image = photo.image;
        thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
        
        // set the view accessory to the image
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.rightCalloutAccessoryView = thumbnailView;
    }
}


@end
