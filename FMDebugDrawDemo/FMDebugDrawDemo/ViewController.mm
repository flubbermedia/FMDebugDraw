//
//  ViewController.m
//  FMDebugDrawDemo
//
//  Created by Maurizio Cremaschi on 27/02/2013.
//  Copyright (c) 2013 Flubber Media Ltd. All rights reserved.
//

#import "ViewController.h"
#import "RagDoll.h"
#import "FMDebugDraw.h"
#include <Box2D/Box2D.h>

#define PTM_RATIO 16

@interface ViewController ()
{
    b2World *world;
    FMDebugDraw debugDraw;
    RagDoll *ragDoll;
    NSTimer *tickTimer;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup timers
    tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    
    // setup accelerometers
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60.0)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    // setup physics world
    [self createPhysicsWorld];
    
    // add the rag doll
    ragDoll = [[RagDoll alloc] initWithWorld:world worldSpace:self.view.bounds.size pixelsPerMeter:PTM_RATIO];
}

#pragma mark - Timer

- (void)tick:(NSTimer *)timer
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
    
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
    
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(1.0f/60.0f, velocityIterations, positionIterations);

    // TODO: move this in the FMDebugDraw
    UIGraphicsBeginImageContext(self.view.bounds.size);
    debugDraw.DrawDebugData(world, UIGraphicsGetCurrentContext(), self.view.bounds.size, PTM_RATIO);
    _debugView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - Accelerometer

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	b2Vec2 gravity;
	gravity.Set( acceleration.x * 9.81,  acceleration.y * 9.81 );
	world->SetGravity(gravity);
}

#pragma mark - Physics

- (void)createPhysicsWorld
{
	CGSize screenSize = self.view.bounds.size;
    
	// Define the gravity vector.
	b2Vec2 gravity;
	gravity.Set(0.0f, -9.81f);
    
	// Construct a world object, which will hold and simulate the rigid bodies.
	world = new b2World(gravity);
    
    // We don't want to let bodies sleep
    world->SetAllowSleeping(false);
    
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
    
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
    
	// Define the ground box shape.
	b2EdgeShape groundBox;
    
	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox, 0);
    
	// top
	groundBox.Set(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox, 0);
    
	// left
	groundBox.Set(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox, 0);
    
	// right
	groundBox.Set(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox, 10.);
    
    // debug draw
    debugDraw.SetFlags(b2Draw::e_shapeBit|b2Draw::e_jointBit|b2Draw::e_centerOfMassBit);
    world->SetDebugDraw(&debugDraw);
}

@end
