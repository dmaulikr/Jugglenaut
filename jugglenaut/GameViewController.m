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

#import "GameViewController.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
  /* Retrieve scene file path from the application bundle */
  NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
  /* Unarchive the file to an SKScene object */
  NSData *data = [NSData dataWithContentsOfFile:nodePath
                                        options:NSDataReadingMappedIfSafe
                                          error:nil];
  NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
  [arch setClass:self forClassName:@"SKScene"];
  SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
  [arch finishDecoding];
  
  return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Configure the view.
  SKView * skView = (SKView *)self.view;
  //skView.showsFPS = YES;
  //skView.showsNodeCount = YES;
  /* Sprite Kit applies additional optimizations to improve rendering performance */
  skView.ignoresSiblingOrder = YES;
  
  // Create and configure the scene.
  m_scene = [GameScene sceneWithSize:self.view.frame.size];
  m_scene.scaleMode = SKSceneScaleModeAspectFill;
  
  // Present the scene.
  [skView presentScene:m_scene];
  
  m_pause = [[PausedViewController alloc] init];
  m_pause.delegate = self;
  
  [self pauseAnimations];
}


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [self resumeAnimations];
}


- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [self pauseAnimations];
}


- (void)pauseAnimations
{
  SKView * skView = (SKView *)self.view;
  
  skView.paused = YES;
  skView.scene.paused = YES;
  skView.scene.physicsWorld.speed = 0;
}


- (void)resumeAnimations
{
  SKView * skView = (SKView *)self.view;
  
  skView.paused = NO;
  skView.scene.paused = NO;
  skView.scene.physicsWorld.speed = 1;
}


- (IBAction)buttonPausePressed:(id)sender
{
  if (m_pause.isShowing == NO)
  {
    [self pauseAnimations];
    
    [m_pause showInViewController:self];
  }
}


- (void)pausedViewController:(PausedViewController *)sender didExitWithOption:(kPauseOption)aOption
{
  switch (aOption)
  {
    case kPauseOptionRetry:
      [m_scene reset];
      
    case kPauseOptionResume:
      [self resumeAnimations];
      break;
      
    case kPauseOptionExit:
      [self dismissViewControllerAnimated:YES completion:nil];
      break;
      
    default:
      break;
  }
}


- (BOOL)shouldAutorotate
{
  return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return UIInterfaceOrientationMaskAllButUpsideDown;
  } else {
    return UIInterfaceOrientationMaskAll;
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

@end
