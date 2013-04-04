//
//  RagDoll.h
//  FMDebugDrawDemo
//
//  Created by Maurizio Cremaschi on 27/02/2013.
//  Copyright (c) 2013 Flubber Media Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <Box2D/Box2D.h>

@interface RagDoll : NSObject

@property (assign, nonatomic) b2Body *torso;
@property (assign, nonatomic) b2Body *neck;
@property (assign, nonatomic) b2Body *head;
@property (assign, nonatomic) b2Body *leftUpperArm;
@property (assign, nonatomic) b2Body *rightUpperArm;
@property (assign, nonatomic) b2Body *leftLowerArm;
@property (assign, nonatomic) b2Body *rightLowerArm;
@property (assign, nonatomic) b2Body *leftLeg;
@property (assign, nonatomic) b2Body *rightLeg;
@property (assign, nonatomic) b2Body *leftCalf;
@property (assign, nonatomic) b2Body *rightCalf;

- (id)initWithWorld:(b2World *)world worldSpace:(CGSize)worldSpace pixelsPerMeter:(int)pixelsPerMeter;

@end
