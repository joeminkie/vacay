//
//  VAAddMapViewController.h
//  Vacay
//
//  Created by Joe Minkiewicz on 5/15/13.
//  Copyright (c) 2013 Beard, Beard & Beard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KML/KML.h>

@interface VAAddMapViewController : UIViewController

@property (nonatomic, weak) KMLRoot *kml;
@property (nonatomic, weak) KMLDocument *document;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, weak) IBOutlet UITextField *urlField;
@property (nonatomic, weak) IBOutlet UIButton *addButton;

@end
