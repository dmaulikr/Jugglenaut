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

#import "GameScene.h"
#import "GameController.h"

#define N_BALLS 1
#define BALL_SIZE 100

@interface GameScene (Private)

- (void)createBoundaries;

@end

@implementation GameScene


- (void)didMoveToView:(SKView *)view
{
  sharedGC = [GameController sharedGameController];
  
  //self.view.showsPhysics = YES;
  
  //self.backgroundColor = [SKColor colorWithRed:118/255.0f green:163/255.0f blue:246/255.0f alpha:1.0f];
  
  m_player = [nt_ball ballWithSceneNamed:@"ball_modifiers.dae" viewPortSize:CGSizeMake(BALL_SIZE, BALL_SIZE)];
  [self addChild:m_player];
  
  [self createBoundaries];
  
  m_player.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
  m_player.physicsBody.dynamic = NO;
  
  [self performSelector:@selector(reset) withObject:nil afterDelay:0.5];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (touches.count > 1)
  {
    
  }
  
  UITouch* touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  NSArray* touchedNodes = [self nodesAtPoint:location];
  
  switch (sharedGC.state)
  {
    case kGameStateReady:
      
      [m_player removeAllActions];
      m_player.physicsBody.dynamic = YES;
      [sharedGC setRunning];
      
    case kGameStateRunning:
      
      for (SKSpriteNode* n in touchedNodes)
      {
        if ([m_player isEqual:n])
        {
          //TODO: find a better rotation alternative
          CGFloat rot = m_player.zRotation;
          m_player.zRotation = 0;
          CGPoint loc = [m_player convertPoint:location fromNode:self];
          m_player.zRotation = rot;
          [m_player kickAtLocation:loc];
          break;
        }
      }
      
      break;
      
    default:
      break;
  }
  
}


- (void)update:(CFTimeInterval)currentTime
{
  [m_player update:currentTime];
}


- (void)reset
{
  [m_player removeAllActions];
  
  m_player.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
  m_player.physicsBody.dynamic = NO;
  
  SKAction* move1 = [SKAction moveBy:CGVectorMake(0, 100) duration:1.0f];
  SKAction* move2 = [SKAction moveBy:CGVectorMake(0, -100) duration:1.0f];
  
  move1.timingMode = move2.timingMode = SKActionTimingEaseInEaseOut;
  
  SKAction* oscillate = [SKAction repeatAction:[SKAction sequence:[NSArray arrayWithObjects:move1, move2, nil]] count:-1];
  
  [m_player runAction:oscillate];
  [m_player runAction:[SKAction repeatAction:[SKAction rotateByAngle:1.0f duration:1.0f] count:-1]];
  
//  SKAction* scale1 = [SKAction scaleTo:2.0f duration:1.0f];
//  SKAction* scale2 = [SKAction scaleTo:1.0f duration:1.0f];
//  SKAction* scaling = [SKAction repeatAction:[SKAction sequence:[NSArray arrayWithObjects:scale1, scale2, nil]] count:-1];
//  
//  [m_player runAction:scaling];
  
  [sharedGC setReady];
}


- (void)end
{
  
}


- (void)createBoundaries
{
  SKShapeNode* floor = [SKShapeNode shapeNodeWithRect:self.frame];
  floor.position = CGPointMake(0, 0);
  [floor setName:@"floor"];
  [floor setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:floor.frame]];
  floor.physicsBody.dynamic = NO;
  floor.userInteractionEnabled = NO;
  [self addChild:floor];
}


@end
