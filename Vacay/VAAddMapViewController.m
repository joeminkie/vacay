//
//  VAAddMapViewController.m
//  Vacay
//
//  Created by Joe Minkiewicz on 5/15/13.
//  Copyright (c) 2013 Beard, Beard & Beard. All rights reserved.
//

#import "VAAddMapViewController.h"
#import "Maps.h"

@interface VAAddMapViewController ()

@end

@implementation VAAddMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(IBAction)addMap:(id)sender {
    
    [self showLoader];
    
    NSURL *url = [NSURL URLWithString:self.urlField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [self dismissLoader];
        
        if (data) {
            
            Maps *maps = [Maps init];
            
            if([maps addMapFromURL:url withData:data]) {
                [self closeAddMapView:nil];
            }
            
        } else {
            NSLog(@"connection error");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"There was an retrieveing the file from the given URL" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }];
}




-(void)showLoader {
    // TODO
}

-(void)dismissLoader {
    // TODO
}





-(IBAction) closeAddMapView:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
