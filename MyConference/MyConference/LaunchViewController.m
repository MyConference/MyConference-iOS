//
//  LaunchViewController.m
//  MyConference
//
//  Created by Pedro Morgado on 07/02/14.
//  Copyright (c) 2014 MyConference. All rights reserved.
//

#import "LaunchViewController.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

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
}

- (void) viewDidAppear:(BOOL)animated{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] == NULL){
        [self performSegueWithIdentifier:@"LaunchToAccessSegue" sender:self];
    } else {
        [self performSegueWithIdentifier:@"LaunchToConferencesSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
