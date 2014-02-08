//
//  SignUpViewController.m
//  MyConference
//
//  Created by Pedro Morgado on 07/02/14.
//  Copyright (c) 2014 MyConference. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

- (IBAction)signUp:(id)sender;

@end

@implementation SignUpViewController

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
    
    //Dismiss the keyboard when press the screen
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.emailTextField){
        UIResponder* nextResponder = [textField.superview viewWithTag:1];
        [nextResponder becomeFirstResponder];
    } else if(textField == self.passwordTextField) {
        UIResponder* nextResponder = [textField.superview viewWithTag:2];
        [nextResponder becomeFirstResponder];
    } else if(textField == self.repeatPasswordTextField){
        [textField resignFirstResponder];
        [self signUp:self];
    }
    return YES;
}

-(void)dismissKeyboard {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.repeatPasswordTextField resignFirstResponder];
}

- (IBAction)signUp:(id)sender {
    if(self.passwordTextField.text.length >= 8){
        if([self.passwordTextField.text isEqualToString:self.repeatPasswordTextField.text]){
            NSLog(@"BETA SIGNUP");
            
            //Shows activity indicator
            self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            self.activityIndicator.center=self.view.center;
            [self.activityIndicator startAnimating];
            [self.view addSubview:self.activityIndicator];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://myconf-api-dev.herokuapp.com/auth/signup"]];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
            
            //Create dictionary with the data of the login
            NSMutableDictionary *signupDictionary = [[NSMutableDictionary alloc] init];
            [signupDictionary setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"application_id_heroku_dev"] forKey:@"application_id"];
            [signupDictionary setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"device_id"] forKey:@"device_id"];
            NSMutableDictionary *userDataDictionary = [[NSMutableDictionary alloc] init];
            [userDataDictionary setObject:self.emailTextField.text forKey:@"email"];
            [userDataDictionary setObject:self.passwordTextField.text forKey:@"password"];
            [signupDictionary setObject:userDataDictionary forKey:@"user_data"];
            
            //Generate JSON
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:signupDictionary options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString;
            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
            [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
            
            //Send to API
            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if (connection) {
                // Create the NSMutableData to hold the received data.
                self.responseData = [NSMutableData data];
            } else {
                // Inform the user that the connection failed.
                [self.activityIndicator stopAnimating];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"The connection to the server has failed" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
                [alert show];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Passwords are diferent" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Password must be at least 8 characters long" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)login {
    if(self.passwordTextField.text.length > 8){
        NSLog(@"BETA LOGIN");
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://myconf-api-dev.herokuapp.com/auth"]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        
        //Create dictionary with the data of the login
        NSMutableDictionary *loginDictionary = [[NSMutableDictionary alloc] init];
        [loginDictionary setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"application_id_heroku_dev"] forKey:@"application_id"];
        [loginDictionary setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"device_id"] forKey:@"device_id"];
        NSMutableDictionary *credentialsDictionary = [[NSMutableDictionary alloc] init];
        [credentialsDictionary setObject:@"password" forKey:@"type"];
        [credentialsDictionary setObject:self.emailTextField.text forKey:@"email"];
        [credentialsDictionary setObject:self.passwordTextField.text forKey:@"password"];
        [loginDictionary setObject:credentialsDictionary forKey:@"credentials"];
        
        //Generate JSON and set HTTP body with the JSON
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:loginDictionary options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString;
        if (!jsonData) {
            NSLog(@"Got an error: %@", error);
        } else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
        //Send to API
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection) {
            // Create the NSMutableData to hold the received data.
            self.responseData = [NSMutableData data];
        } else {
            // Inform the user that the connection failed.
            [self.activityIndicator stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"The connection to the server has failed" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Wrong email or password" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    
    self.responseData = [[NSMutableData alloc] init];
    [self.responseData setLength:0];
    
    NSURL *urlConnection = [[connection currentRequest] URL];
    NSString *urlConnectionString = [urlConnection absoluteString];
    NSArray* componentsUrlConnection = [urlConnectionString componentsSeparatedByString: @"/"];
    NSString* apiService1 = [componentsUrlConnection objectAtIndex:3];
    NSString *apiService2;
    if(componentsUrlConnection.count > 4){
        apiService2 = [componentsUrlConnection objectAtIndex:4];
    }
    
    if ([response respondsToSelector:@selector(statusCode)])
    {
        int statusCode = [((NSHTTPURLResponse *)response) statusCode];
        
        if([apiService1 isEqualToString:@"auth"] && [apiService2 isEqualToString:@"signup"]){
            if (statusCode == 200){
                //Success
                [self login];
            } else if (statusCode > 200) {
                //Failed
                [self.activityIndicator stopAnimating];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Can't sign up with this credentials" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                [alert show];
            }
        }
        
        if([apiService1 isEqualToString:@"auth"] && apiService2 == NULL){
            if (statusCode == 200){
                //Success
                [self.activityIndicator stopAnimating];
                [self performSegueWithIdentifier:@"SignUpToConferencesSegue" sender:self];
            } else if (statusCode > 200) {
                //Failed
                [self.activityIndicator stopAnimating];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Can't log in with this credentials" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *dataString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    
    NSURL *urlConnection = [[connection currentRequest] URL];
    NSString *urlConnectionString = [urlConnection absoluteString];
    NSArray* componentsUrlConnection = [urlConnectionString componentsSeparatedByString: @"/"];
    NSString* apiService1 = [componentsUrlConnection objectAtIndex:3];
    NSString *apiService2;
    if(componentsUrlConnection.count > 4){
        apiService2 = [componentsUrlConnection objectAtIndex:4];
    }
    
    if([apiService1 isEqualToString:@"auth"] && [apiService2 isEqualToString:@"signup"]){
        NSLog(@"SIGNUP DATA: %@", dataString);
    } else if ([apiService1 isEqualToString:@"auth"] && apiService2 == NULL){
        NSLog(@"LOGIN DATA: %@", dataString);
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&error];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:[json objectForKey:@"access_token"] forKey:@"access_token"];
        [ud setObject:[json objectForKey:@"access_token_expires"] forKey:@"access_token_expires"];
        [ud setObject:[json objectForKey:@"refresh_token"] forKey:@"refresh_token"];
        [ud setObject:[json objectForKey:@"refresh_token_expires"] forKey:@"refresh_token_expires"];
        [ud synchronize];
    } else {
        NSLog(@"ERROR DATA: %@", dataString);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Inform the user if the connection failed
    [self.activityIndicator stopAnimating];
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}
@end
