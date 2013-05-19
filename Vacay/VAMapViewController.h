//
//  VAMapViewController.h
//  Vacay
//
//  Created by Joe Minkiewicz on 5/18/13.
//  Copyright (c) 2013 Beard, Beard & Beard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <KML/KML.h>

@interface VAMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, weak) KMLPlacemark *placemark;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
