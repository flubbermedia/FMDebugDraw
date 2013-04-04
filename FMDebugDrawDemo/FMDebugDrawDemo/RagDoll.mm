//
//  RagDoll.m
//  FMDebugDrawDemo
//
//  Created by Maurizio Cremaschi on 27/02/2013.
//  Copyright (c) 2013 Flubber Media Ltd. All rights reserved.
//

#import "RagDoll.h"

static const CGSize torsoSize = CGSizeMake(60, 120);
static const CGSize neckSize = CGSizeMake(10, 15);
static const CGSize headSize = CGSizeMake(50, 50);
static const CGSize upperArmSize = CGSizeMake(20, 60);
static const CGSize lowerArmSize = CGSizeMake(20, 60);
static const CGSize legSize = CGSizeMake(20, 60);
static const CGSize calfSize = CGSizeMake(20, 60);

@interface RagDoll ()
{
    b2World *world;
    int ptm_ratio;
    CGSize worldSpace;
}

@end

@implementation RagDoll

- (id)initWithWorld:(b2World *)_world worldSpace:(CGSize)_worldSpace pixelsPerMeter:(int)pixelsPerMeter
{
    self = [super init];
    if (self) {
        
        // save global stuff
        world = _world;
        worldSpace = _worldSpace;
        ptm_ratio = pixelsPerMeter;
        
        // torso
        b2Body *torso = [self createRagDollTorso];
        // head
        b2Body *neck = [self createRagDollNeckOnTorso:torso];
        [self createRagDollHeadOnNeck:neck];
        // arms
        b2Body *leftUpperArm = [self createRagDollLeftUpperArmOnTorso:torso];
        b2Body *rightUpperArm = [self createRagDollRightUpperArmOnTorso:torso];
        [self createRagDollLowerArmOnUpperArm:leftUpperArm];
        [self createRagDollLowerArmOnUpperArm:rightUpperArm];
        // legs
        b2Body *leftLeg = [self createRagDollLeftLegOnTorso:torso];
        b2Body *rightLeg = [self createRagDollRightLegOnTorso:torso];
        [self createRagDollCalfOnLeg:leftLeg];
        [self createRagDollCalfOnLeg:rightLeg];
    }
    return self;
}

- (b2Body *)createRagDollTorso
{
    CGPoint center = CGPointMake(worldSpace.width/2, worldSpace.height/2);
    CGSize size = torsoSize;
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(center.x/ptm_ratio, center.y/ptm_ratio);
    b2PolygonShape shape;
    shape.SetAsBox(size.width/2/ptm_ratio, size.height/2/ptm_ratio);
    b2FixtureDef fixtureDef;
	fixtureDef.density = 3.0;
	fixtureDef.friction = 0.3;
	fixtureDef.restitution = 0.5;
    fixtureDef.shape = &shape;
    b2Body *body = world->CreateBody(&bodyDef);
    body->CreateFixture(&fixtureDef);
    return body;
}

- (b2Body *)createRagDollNeckOnTorso:(b2Body *)torso
{
    CGPoint torsoCenter = CGPointMake(torso->GetPosition().x*ptm_ratio, torso->GetPosition().y*ptm_ratio);
    CGSize size = neckSize;
    CGPoint center = CGPointMake(torsoCenter.x, torsoCenter.y + torsoSize.height/2 + size.height/2);
    CGPoint jointCenter = CGPointMake(center.x, torsoCenter.y + torsoSize.height/2);
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(center.x/ptm_ratio, center.y/ptm_ratio);
    b2PolygonShape shape;
    shape.SetAsBox(size.width/2/ptm_ratio, size.height/2/ptm_ratio);
    b2FixtureDef fixtureDef;
	fixtureDef.density = 3.0;
	fixtureDef.friction = 0.3;
	fixtureDef.restitution = 0.5;
    fixtureDef.shape = &shape;
    b2Body *body = world->CreateBody(&bodyDef);
    body->CreateFixture(&fixtureDef);
    b2RevoluteJointDef revoluteJointDef;
    revoluteJointDef.Initialize(torso, body, b2Vec2(jointCenter.x/ptm_ratio, jointCenter.y/ptm_ratio));
    revoluteJointDef.enableLimit = true;
    revoluteJointDef.lowerAngle = -45 * M_PI/180;
    revoluteJointDef.upperAngle = 45 * M_PI/180;
    world->CreateJoint(&revoluteJointDef);
    return body;
}

- (b2Body *)createRagDollHeadOnNeck:(b2Body *)neck
{
    CGPoint neckCenter = CGPointMake(neck->GetPosition().x*ptm_ratio, neck->GetPosition().y*ptm_ratio);
    CGSize size = headSize;
    CGPoint center = CGPointMake(neckCenter.x, neckCenter.y + neckSize.height/2 + size.height/2);
    CGPoint jointCenter = CGPointMake(center.x, neckCenter.y + neckSize.height/2);
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(center.x/ptm_ratio, center.y/ptm_ratio);
    b2PolygonShape shape;
    shape.SetAsBox(size.width/2/ptm_ratio, size.height/2/ptm_ratio);
    b2FixtureDef fixtureDef;
	fixtureDef.density = 3.0;
	fixtureDef.friction = 0.3;
	fixtureDef.restitution = 0.5;
    fixtureDef.shape = &shape;
    b2Body *body = world->CreateBody(&bodyDef);
    body->CreateFixture(&fixtureDef);
    b2RevoluteJointDef revoluteJointDef;
    revoluteJointDef.Initialize(neck, body, b2Vec2(jointCenter.x/ptm_ratio, jointCenter.y/ptm_ratio));
    revoluteJointDef.enableLimit = true;
    revoluteJointDef.lowerAngle = -5 * M_PI/180;
    revoluteJointDef.upperAngle = 5 * M_PI/180;
    world->CreateJoint(&revoluteJointDef);
    return body;
}

- (b2Body *)createRagDollLeftUpperArmOnTorso:(b2Body *)torso
{
    CGPoint torsoCenter = CGPointMake(torso->GetPosition().x*ptm_ratio, torso->GetPosition().y*ptm_ratio);
    CGSize size = upperArmSize;
    CGPoint center = CGPointMake(torsoCenter.x - torsoSize.width/2, torsoCenter.y + torsoSize.height/2 - size.height/2);
    CGPoint jointCenter = CGPointMake(center.x, torsoCenter.y + torsoSize.height/2);
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(center.x/ptm_ratio, center.y/ptm_ratio);
    b2PolygonShape shape;
    shape.SetAsBox(size.width/2/ptm_ratio, size.height/2/ptm_ratio);
    b2FixtureDef fixtureDef;
	fixtureDef.density = 3.0;
	fixtureDef.friction = 0.3;
	fixtureDef.restitution = 0.5;
    fixtureDef.shape = &shape;
    b2Body *body = world->CreateBody(&bodyDef);
    body->CreateFixture(&fixtureDef);
    b2RevoluteJointDef revoluteJointDef;
    revoluteJointDef.Initialize(torso, body, b2Vec2(jointCenter.x/ptm_ratio, jointCenter.y/ptm_ratio));
    revoluteJointDef.enableLimit = true;
    revoluteJointDef.lowerAngle = 0 * M_PI/180;
    revoluteJointDef.upperAngle = -180 * M_PI/180;
    world->CreateJoint(&revoluteJointDef);
    return body;
}

- (b2Body *)createRagDollRightUpperArmOnTorso:(b2Body *)torso
{
    CGPoint torsoCenter = CGPointMake(torso->GetPosition().x*ptm_ratio, torso->GetPosition().y*ptm_ratio);
    CGSize size = upperArmSize;
    CGPoint center = CGPointMake(torsoCenter.x + torsoSize.width/2, torsoCenter.y + torsoSize.height/2 - size.height/2);
    CGPoint jointCenter = CGPointMake(center.x, torsoCenter.y + torsoSize.height/2);
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(center.x/ptm_ratio, center.y/ptm_ratio);
    b2PolygonShape shape;
    shape.SetAsBox(size.width/2/ptm_ratio, size.height/2/ptm_ratio);
    b2FixtureDef fixtureDef;
	fixtureDef.density = 3.0;
	fixtureDef.friction = 0.3;
	fixtureDef.restitution = 0.5;
    fixtureDef.shape = &shape;
    b2Body *body = world->CreateBody(&bodyDef);
    body->CreateFixture(&fixtureDef);
    b2RevoluteJointDef revoluteJointDef;
    revoluteJointDef.Initialize(torso, body, b2Vec2(jointCenter.x/ptm_ratio, jointCenter.y/ptm_ratio));
    revoluteJointDef.enableLimit = true;
    revoluteJointDef.lowerAngle = 0 * M_PI/180;
    revoluteJointDef.upperAngle = 180 * M_PI/180;
    world->CreateJoint(&revoluteJointDef);
    return body;
}

- (b2Body *)createRagDollLowerArmOnUpperArm:(b2Body *)upperArm
{
    CGPoint upperArmCenter = CGPointMake(upperArm->GetPosition().x*ptm_ratio, upperArm->GetPosition().y*ptm_ratio);
    CGSize size = lowerArmSize;
    CGPoint center = CGPointMake(upperArmCenter.x, upperArmCenter.y - upperArmSize.height/2 - size.height/2);
    CGPoint jointCenter = CGPointMake(center.x, upperArmCenter.y - upperArmSize.height/2);
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(center.x/ptm_ratio, center.y/ptm_ratio);
    b2PolygonShape shape;
    shape.SetAsBox(size.width/2/ptm_ratio, size.height/2/ptm_ratio);
    b2FixtureDef fixtureDef;
	fixtureDef.density = 3.0;
	fixtureDef.friction = 0.3;
	fixtureDef.restitution = 0.5;
    fixtureDef.shape = &shape;
    b2Body *body = world->CreateBody(&bodyDef);
    body->CreateFixture(&fixtureDef);
    b2RevoluteJointDef revoluteJointDef;
    revoluteJointDef.Initialize(upperArm, body, b2Vec2(jointCenter.x/ptm_ratio, jointCenter.y/ptm_ratio));
    revoluteJointDef.enableLimit = true;
    revoluteJointDef.lowerAngle = -45 * M_PI/180;
    revoluteJointDef.upperAngle = 45 * M_PI/180;
    world->CreateJoint(&revoluteJointDef);
    return body;
}

- (b2Body *)createRagDollLeftLegOnTorso:(b2Body *)torso
{
    CGPoint torsoCenter = CGPointMake(torso->GetPosition().x*ptm_ratio, torso->GetPosition().y*ptm_ratio);
    CGSize size = legSize;
    CGPoint center = CGPointMake(torsoCenter.x - torsoSize.width/2 + size.width/2, torsoCenter.y - torsoSize.height/2 - size.height/2);
    CGPoint jointCenter = CGPointMake(center.x, torsoCenter.y - torsoSize.height/2);
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(center.x/ptm_ratio, center.y/ptm_ratio);
    b2PolygonShape shape;
    shape.SetAsBox(size.width/2/ptm_ratio, size.height/2/ptm_ratio);
    b2FixtureDef fixtureDef;
	fixtureDef.density = 3.0;
	fixtureDef.friction = 0.3;
	fixtureDef.restitution = 0.5;
    fixtureDef.shape = &shape;
    b2Body *body = world->CreateBody(&bodyDef);
    body->CreateFixture(&fixtureDef);
    b2RevoluteJointDef revoluteJointDef;
    revoluteJointDef.Initialize(torso, body, b2Vec2(jointCenter.x/ptm_ratio, jointCenter.y/ptm_ratio));
    revoluteJointDef.enableLimit = true;
    revoluteJointDef.lowerAngle = -45 * M_PI/180;
    revoluteJointDef.upperAngle = 45 * M_PI/180;
    world->CreateJoint(&revoluteJointDef);
    return body;
}

- (b2Body *)createRagDollRightLegOnTorso:(b2Body *)torso
{
    CGPoint torsoCenter = CGPointMake(torso->GetPosition().x*ptm_ratio, torso->GetPosition().y*ptm_ratio);
    CGSize size = legSize;
    CGPoint center = CGPointMake(torsoCenter.x + torsoSize.width/2 - size.width/2, torsoCenter.y - torsoSize.height/2 - size.height/2);
    CGPoint jointCenter = CGPointMake(center.x, torsoCenter.y - torsoSize.height/2);
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(center.x/ptm_ratio, center.y/ptm_ratio);
    b2PolygonShape shape;
    shape.SetAsBox(size.width/2/ptm_ratio, size.height/2/ptm_ratio);
    b2FixtureDef fixtureDef;
	fixtureDef.density = 3.0;
	fixtureDef.friction = 0.3;
	fixtureDef.restitution = 0.5;
    fixtureDef.shape = &shape;
    b2Body *body = world->CreateBody(&bodyDef);
    body->CreateFixture(&fixtureDef);
    b2RevoluteJointDef revoluteJointDef;
    revoluteJointDef.Initialize(torso, body, b2Vec2(jointCenter.x/ptm_ratio, jointCenter.y/ptm_ratio));
    revoluteJointDef.enableLimit = true;
    revoluteJointDef.lowerAngle = -45 * M_PI/180;
    revoluteJointDef.upperAngle = 45 * M_PI/180;
    world->CreateJoint(&revoluteJointDef);
    return body;
}

- (b2Body *)createRagDollCalfOnLeg:(b2Body *)leg
{
    CGPoint legCenter = CGPointMake(leg->GetPosition().x*ptm_ratio, leg->GetPosition().y*ptm_ratio);
    CGSize size = calfSize;
    CGPoint center = CGPointMake(legCenter.x, legCenter.y - legSize.height/2 - size.height/2);
    CGPoint jointCenter = CGPointMake(center.x, legCenter.y - legSize.height/2);
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(center.x/ptm_ratio, center.y/ptm_ratio);
    b2PolygonShape shape;
    shape.SetAsBox(size.width/2/ptm_ratio, size.height/2/ptm_ratio);
    b2FixtureDef fixtureDef;
	fixtureDef.density = 3.0;
	fixtureDef.friction = 0.3;
	fixtureDef.restitution = 0.5;
    fixtureDef.shape = &shape;
    b2Body *body = world->CreateBody(&bodyDef);
    body->CreateFixture(&fixtureDef);
    b2RevoluteJointDef revoluteJointDef;
    revoluteJointDef.Initialize(leg, body, b2Vec2(jointCenter.x/ptm_ratio, jointCenter.y/ptm_ratio));
    revoluteJointDef.enableLimit = true;
    revoluteJointDef.lowerAngle = -45 * M_PI/180;
    revoluteJointDef.upperAngle = 45 * M_PI/180;
    world->CreateJoint(&revoluteJointDef);
    return body;
}

@end
