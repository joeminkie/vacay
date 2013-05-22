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

@property (nonatomic, weak) KMLDocument *document;
@property (nonatomic, weak) Maps *MapModel;

@property (nonatomic, weak) KMLPlacemark *placemark;

@end

@implementation VAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.MapModel = [Maps init];
    self.document = [self.mapInfo valueForKey:@"document"];
    
    self.title = self.document.name;
    //self.tableView = (UITableView *)[self.childViewControllers objectAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Vacay 

- (IBAction)flipView:(id)sender {
    
    //UIBarButtonItem *button = (UIBarButtonItem *)sender;
    
    //tableIsVisible = (BOOL)[self.tableView superview];
    BOOL tableIsVisible = [[[self.currentView subviews] objectAtIndex:1] isKindOfClass:[UITableView class]] ? YES : NO;
    [UIView transitionWithView:self.currentView
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^(void) {
                        //if ([self.tableView superview]) {
                        if (tableIsVisible) {
                            //[self.tableView removeFromSuperview];
                            //[self.currentView addSubview:self.mapView];
                            [self.currentView insertSubview:self.mapView atIndex:1];
                            //[self.mapView setFrame:CGRectMake(0, 0, 32, 32)];
                        } else {
                            //[self.mapView removeFromSuperview];
                            //[self.currentView addSubview:self.tableView];
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
        
        NSLog(@"refreshed");
        // TODO reload MapView as well
        
    } else {
        NSLog(@"NOT refreshed");
    }
    
    // TODO hideSpinner
    
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


@end
