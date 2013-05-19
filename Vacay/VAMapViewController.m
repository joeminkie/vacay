//
//  VAMapViewController.m
//  Vacay
//
//  Created by Joe Minkiewicz on 5/18/13.
//  Copyright (c) 2013 Beard, Beard & Beard. All rights reserved.
//

#import "VAMapViewController.h"

@interface VAMapViewController ()

@end

@implementation VAMapViewController

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
    
    KMLPoint *point = (KMLPoint *)self.placemark.geometry;
    NSLog(@"point: %@", point);
    
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(point.coordinate.latitude, point.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(.015, .015);
    MKCoordinateRegion reg = MKCoordinateRegionMake(loc, span);
    self.mapView.region = reg;
    
    //MKAnnotationView mapPoint
    
    MKPointAnnotation* annoation = [MKPointAnnotation new];
    annoation.coordinate = loc;
    annoation.title = self.placemark.name;
    annoation.subtitle = self.placemark.descriptionValue;
    [self.mapView addAnnotation:annoation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
