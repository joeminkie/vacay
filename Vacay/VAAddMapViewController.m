//
//  VAAddMapViewController.m
//  Vacay
//
//  Created by Joe Minkiewicz on 5/15/13.
//  Copyright (c) 2013 Beard, Beard & Beard. All rights reserved.
//

#import "VAAddMapViewController.h"

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
    
    NSLog(@"Add URL: %@", url);
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [self dismissLoader];
        
        if (data) {
            NSLog(@"success");
            [self saveData:data];
        } else {
            NSLog(@"error");
        }
        
    }];
}

-(void)saveData:(NSData *)data {
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", s);
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
