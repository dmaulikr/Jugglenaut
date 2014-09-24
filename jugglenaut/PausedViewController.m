/*
 * Copyright (c) 2014 Nicholas Trampe
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

#import "PausedViewController.h"

@interface PausedViewController (Private)

- (void)hideWithOption:(kPauseOption)aOption;

@end

@implementation PausedViewController


- (id)init
{
  self = [super initWithNibName:@"PausedViewController" bundle:[NSBundle mainBundle]];
  if (self)
  {
    
  }
  return self;
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (IBAction)buttonResumePressed:(id)sender
{
  [self hideWithOption:kPauseOptionResume];
}


- (IBAction)buttonRetryPressed:(id)sender
{
  [self hideWithOption:kPauseOptionRetry];
}


- (IBAction)buttonExitPressed:(id)sender
{
  [self hideWithOption:kPauseOptionExit];
}


- (void)showInViewController:(UIViewController *)aViewController
{
  self.view.center = CGPointMake(aViewController.view.center.x, aViewController.view.center.y + aViewController.view.frame.size.height);
  
  [aViewController.view addSubview:self.view];
  
  [UIView animateWithDuration:0.8f delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:0.5f options:UIViewAnimationOptionAllowAnimatedContent animations:^
   {
     self.view.center = aViewController.view.center;
   }
                   completion:^(BOOL finished)
   {
     
   }];
}


- (BOOL)isShowing
{
  return (self.view.superview != nil);
}


- (void)hideWithOption:(kPauseOption)aOption
{
  [UIView animateWithDuration:0.4f animations:^
   {
     self.view.center = CGPointMake(self.view.center.x, self.view.center.y - self.view.superview.frame.size.height);
   }
   completion:^(BOOL finished)
   {
     [self.view removeFromSuperview];
     
     if (self.delegate != nil)
       [self.delegate pausedViewController:self didExitWithOption:aOption];
   }];
}


@end
