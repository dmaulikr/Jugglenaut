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

#import "GameController.h"

@interface GameController (Private) 

- (void)initController;

@end

@implementation GameController

#pragma mark -
#pragma mark Init


- (id)init
{
  self = [super init];
  if (self)
  {
    [self initController];
  }
  
  return self;
}


- (void)initController
{
  //load the data when the app starts
  [self loadData];
  
  //create the standard settings
  settings = [NSUserDefaults  standardUserDefaults];
  
  //load settings
  [self loadSettings];
  
  [self setReady];
}


- (kGameState)state
{
  return m_state;
}


- (BOOL)isReady
{
  return (m_state == kGameStateReady);
}


- (BOOL)isRunning
{
  return (m_state == kGameStateRunning);
}


- (BOOL)isPaused
{
  return (m_state == kGameStatePaused);
}


- (BOOL)isOver
{
  return (m_state == kGameStateOver);
}


- (void)setReady
{
  m_prevState = m_state;
  m_state = kGameStateReady;
}


- (void)setRunning
{
  m_prevState = m_state;
  m_state = kGameStateRunning;
}


- (void)setPaused
{
  m_prevState = m_state;
  m_state = kGameStatePaused;
}


- (void)setOver
{
  m_prevState = m_state;
  m_state = kGameStateOver;
}


#pragma mark -
#pragma mark Data Functions


- (void)saveData
{
  //create the appropriate file path
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *gameDataPath = [documentsDirectory stringByAppendingPathComponent:@"GameController.dat"];
	
  //create game data and a keyed archiver
	NSMutableData *gameData;
	NSKeyedArchiver *encoder;
	gameData = [NSMutableData data];
	encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:gameData];
	
  //encode it
  
	
	[encoder finishEncoding];
  
  //create it
	[gameData writeToFile:gameDataPath atomically:YES];
}


- (void)loadData
{
  //create the appropriate file path
  NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *documentPath = [documentsDirectory stringByAppendingPathComponent:@"GameController.dat"];
  
  //if there is a file then decode it. If not, then set empty values and create one
  if ([fileManager fileExistsAtPath:documentPath])
  {
    NSData *gameData;
    NSKeyedUnarchiver *decoder;
    
    gameData = [NSData dataWithContentsOfFile:documentPath];
    
    decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:gameData];
    
    
  }
  else
  {
    //create new data
    
  }
  
  [self saveData];
}


- (void)resetData
{
  //create the appropriate file path
  NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *documentPath = [documentsDirectory stringByAppendingPathComponent:@"GameController.dat"];
  
  //if there is a file then remove it and create another one by loading data. If not, display error
  if ([fileManager fileExistsAtPath:documentPath])
  {
    [fileManager removeItemAtPath:documentPath error:NULL];
    [self loadData];
  }
  else
  {
    //no file
  }
}


#pragma mark -
#pragma mark Settings Functions


- (void)saveSettings
{
  //set settings values
  
  [settings synchronize];
}


- (void)loadSettings
{
  //if there isn't a true value for userDefaultsSet then it's the first time creating settings
  if (![settings boolForKey:@"userDefaultsSet"])
  {
		[settings setBool:YES       forKey:@"userDefaultsSet"];
    [self setSettings];
	}
  else
  {
    [self setSettings];
	}
}


- (void)setSettings
{
  //assign values
}


- (void)resetSettings
{ 
  //reset the settings by setting userDefaultsSet to NO and load settings twice to actually set the values
  [settings setBool:NO forKey:@"userDefaultsSet"];
  [self loadSettings];
}


#pragma mark -
#pragma mark Singleton


+ (instancetype)sharedGameController
{
  static dispatch_once_t pred = 0;
  static GameController *sharedGameController = nil;
  
  dispatch_once( &pred, ^{
    sharedGameController = [[super alloc] init];
  });
  return sharedGameController;
}


@end
