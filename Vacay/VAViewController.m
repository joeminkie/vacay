//
//  VAViewController.m
//  Vacay
//
//  Created by Joe Minkiewicz on 5/15/13.
//  Copyright (c) 2013 Beard, Beard & Beard. All rights reserved.
//

#import "VAViewController.h"
#import "Maps.h"

@interface VAViewController ()

@property (strong, nonatomic) MKUserTrackingBarButtonItem *currentLocationButton;

@property (nonatomic, weak) KMLDocument *document;
@property (nonatomic, weak) Maps *MapModel;

@property (nonatomic, weak) KMLPlacemark *placemark;

- (void)reloadMapAnnotations;

@end

@implementation VAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.MapModel = [Maps init];
    self.document = [self.mapInfo valueForKey:@"document"];
    
    self.title = self.document.name;
    
    // add the currentLocation button
    self.currentLocationButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    NSMutableArray *toolbarButtons = [NSMutableArray arrayWithArray:self.toolbar.items];
    [toolbarButtons insertObject:self.currentLocationButton atIndex:0];
    self.toolbar.items = toolbarButtons;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self reloadMapAnnotations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Vacay 

- (IBAction)flipView:(id)sender {
    
    // TODO flip self.flipButton
    
    BOOL tableIsVisible = [[[self.currentView subviews] objectAtIndex:1] isKindOfClass:[UITableView class]] ? YES : NO;
    [UIView transitionWithView:self.currentView
                      duration:1.0f
                       options:tableIsVisible ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^(void) {
                        if (tableIsVisible) {
                            [self.currentView insertSubview:self.mapView atIndex:1];
                        } else {
                            [self.currentView insertSubview:self.tableView atIndex:1];
                        }
                        
                    }
                    completion:^(BOOL finished) {
                        if (finished) {
                            // TODO anything?
                        }
                    }
     ];
}

- (IBAction)refreshMapInfo:(id)sender {
    
    // TODO showSpinner
    
    NSDictionary *newMapInfo = [self.MapModel refreshMapInfo:self.mapInfo];
    
    if (newMapInfo) {
        
        self.mapInfo = newMapInfo;
        [self.tableView reloadData];
        [self reloadMapAnnotations];
        
        NSLog(@"refreshed");
        // TODO reload MapView as well
        
    } else {
        NSLog(@"NOT refreshed");
    }
    
    // TODO hideSpinner
    
}

- (void)reloadMapAnnotations {
    
    // remove all pins except the user location
    // from http://stackoverflow.com/questions/3027392/how-to-delete-all-annotations-on-a-mkmapview
    
    id userLocation = [self.mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
    if (userLocation != nil) {
        [pins removeObject:userLocation];
    }
    [self.mapView removeAnnotations:pins];
    
    // add all the (new) points back
    NSMutableArray *annotations = [NSMutableArray array];
    // assuming all features are points not shapes for MVP
    KMLRoot *kml = (KMLRoot *)self.mapInfo[@"kml"];
    for (KMLPlacemark *placemark in kml.placemarks) {
        MKPointAnnotation *point = [MKPointAnnotation new];
        KMLPoint *kmlPoint = (KMLPoint *)placemark.geometry;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(kmlPoint.coordinate.latitude, kmlPoint.coordinate.longitude);
        point.coordinate = coordinate;
        point.title = placemark.name;
        [annotations addObject:point];
    }
    
    [self.mapView addAnnotations:annotations];
    
    // from http://kmlframework.com sample app:
    // set zoom in next run loop.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //
        // Thanks for elegant code!
        // https://gist.github.com/915374
        //
        MKMapRect zoomRect = MKMapRectNull;
        id<MKAnnotation> userLocation = [self.mapView userLocation];
        for (id<MKAnnotation> annotation in self.mapView.annotations) {
            if (userLocation != annotation) {
                MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
                MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
                if (MKMapRectIsNull(zoomRect)) {
                    zoomRect = pointRect;
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect);
                }
            }
        }
        [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(10, 10, 10, 10) animated:YES];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.document.features count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"locationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    KMLPlacemark *placemark = [self.document.features objectAtIndex:indexPath.row];
    cell.textLabel.text = placemark.name;
    cell.detailTextLabel.text = placemark.descriptionValue;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = nil;
    if (annotation.title) {
        static NSString * identifier = @"testPin";
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.canShowCallout = YES;
        }
        annotationView.annotation = annotation;
    }
    return annotationView;
}


@end
