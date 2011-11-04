/**
 * Copyright (c) 2011 Moodstocks SAS
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) loadView {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UINavigationItem *navItem = [[[UINavigationItem alloc] initWithTitle:@"MSApi Sample"] autorelease];
    
    UINavigationBar* navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44.0)];
    navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [navigationBar pushNavigationItem:navItem animated:NO];
    [self.view addSubview:navigationBar];
    [navigationBar release];
    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchDown];
    [scanButton setTitle:@"Scan" forState:UIControlStateNormal];
    scanButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:scanButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Scanning

- (void)scanAction {
    MSScannerController *scannerController = [[MSScannerController alloc] init];
    scannerController.delegate = self;
    [self presentModalViewController:scannerController animated:YES];
    [scannerController release];
}

#pragma mark - MSScannerControllerDelegate

- (void)scannerController:(MSScannerController*)scanner didFinishScanningWithInfo:(NSDictionary *)info {
    [self dismissModalViewControllerAnimated:YES];
    
    /**
     * NOTE: adapt according to your application logic
     * In most cases you'll have now to retrieve related metadata (e.g. URL, product title)
     * 
     * Such data could:
     * 
     * * be decoded from the objectID if you've chosen to do so (e.g. obtain an URL from base64url encoded ID)
     *    see "Step 5 - Decode ID and open the URL" from tutorial:
     *    https://github.com/Moodstocks/moodstocks-api/wiki/usnap-like-application
     * 
     *  * be fetched from a local database
     *  * be fetched from a remote database via an HTTP call to your web server
     *    see https://github.com/Moodstocks/moodstocks-api/wiki/api-v2-help-appmodel
     */
    if ([info objectForKey:@"error"] == nil) {
        BOOL found = [[info objectForKey:@"found"] boolValue];
        [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Done", @"")
                                     message:(found ? [NSString stringWithFormat:@"Match found with ID = %@", [info objectForKey:@"id"]] : @"No match found")
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil] autorelease] show];
    }
    else {
        [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                     message:[info objectForKey:@"error"]
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil] autorelease] show];
    }
}

- (void)scannerControllerDidCancel:(MSScannerController*)scanner {
    [self dismissModalViewControllerAnimated:YES];
}

@end
