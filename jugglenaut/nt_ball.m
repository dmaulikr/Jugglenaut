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

#import "nt_ball.h"

@implementation nt_ball

+ (instancetype)ballWithSceneNamed:(NSString *)aSceneName viewPortSize:(CGSize)aSize
{
  nt_ball* ball = [nt_ball nodeWithViewportSize:CGSizeMake(aSize.width, aSize.height)];
  
  ball.scnScene = [SCNScene sceneNamed:aSceneName];
  
  SCNNode * glowNode = [ball.scnScene.rootNode childNodeWithName:@"Glow" recursively:YES];
  
  if (glowNode != NULL)
  {
    SCNMaterial* glowMat = [SCNMaterial material];
    
    glowMat.ambient.contents = [UIColor colorWithRed:0.0 green:0.430 blue:0.800 alpha:1.0f];
    glowMat.ambient.intensity = 0.5f;
    glowMat.emission.contents = [UIColor colorWithRed:0.0 green:0.430 blue:0.800 alpha:1.0f];
    glowMat.emission.intensity = 0.5f;
    
    glowNode.geometry.firstMaterial = glowMat;
  }
  
  ball.autoenablesDefaultLighting = YES;
  
  ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:aSize.width*0.5f * 0.75f];
  ball.physicsBody.density = 0.5f;
  ball.physicsBody.mass = 0.5f;
  ball.physicsBody.restitution = 0.5f;
  
  [ball setName:@"ball"];
  
  return ball;
}


- (SCNNode *)body
{
  return self.scnScene.rootNode;
}


- (void)kickAtLocation:(CGPoint)aLocation
{
  CGVector level = CGVectorMake(aLocation.x / (self.frame.size.width / 2.0f), ((self.frame.size.height / 2.0f) - aLocation.y) / self.frame.size.height);
  CGVector normalVector = CGVectorMake(self.position.x - aLocation.x, self.position.y - aLocation.y);
  float distance = sqrtf(powf(aLocation.x - self.position.x, 2) + powf(aLocation.y - self.position.y, 2));
  CGPoint unitNormal = CGPointMake(normalVector.dx/distance, normalVector.dy/distance);
  
  //moving away velocity
  CGVector afterVelocity = CGVectorMake(-(unitNormal.x), -(unitNormal.y));
  
  self.physicsBody.velocity = CGVectorMake(afterVelocity.dx * aLocation.x * 10, level.dy * 1000);
  
  [self.physicsBody setAngularVelocity:(aLocation.x / 10)];
}


- (void)update:(CFTimeInterval)aCurrentTime
{
  self.body.transform = SCNMatrix4MakeRotation(-self.zRotation, 0.3, 1, 0.3);
}


@end
