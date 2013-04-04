//
//  FMDebugDraw.cpp
//  Chime
//
//  Created by Maurizio Cremaschi on 20/02/2013.
//  Copyright (c) 2013 Myfleek Ltd. All rights reserved.
//

#import "FMDebugDraw.h"
#import <Foundation/Foundation.h>

void FMDebugDraw::DrawDebugData(b2World *world, CGContextRef draw_context, CGSize draw_space_size, int pixels_per_meter_rate)
{
    context = draw_context;
    space_size = draw_space_size;
	pixels_per_meter = pixels_per_meter_rate;
    
    world->DrawDebugData();
}

void FMDebugDraw::DrawPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color)
{
    CGContextMoveToPoint(context, v2p(vertices[0]).x, v2p(vertices[0]).y);
	for (int i=1; i<vertexCount; i++) {
        CGContextAddLineToPoint(context, v2p(vertices[i]).x, v2p(vertices[i]).y);
	}
	CGContextAddLineToPoint(context, v2p(vertices[0]).x, v2p(vertices[0]).y);
    
    CGContextSetRGBStrokeColor(context, color.r, color.g, color.b, 1.0);
    CGContextStrokePath(context);
}

void FMDebugDraw::DrawSolidPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color)
{
	DrawPolygon(vertices, vertexCount, color);
}

void FMDebugDraw::DrawCircle(const b2Vec2& center, float32 radius, const b2Color& color)
{
    CGContextAddEllipseInRect(context, CGRectMake(v2p(center).x - m2px(radius), v2p(center).y - m2px(radius), m2px(radius*2), m2px(radius*2)));
    CGContextSetRGBStrokeColor(context, color.r, color.g, color.b, 1.0);
    CGContextStrokePath(context);
}

void FMDebugDraw::DrawSolidCircle(const b2Vec2& center, float32 radius, const b2Vec2& axis, const b2Color& color)
{
	DrawCircle(center, radius, color);
    
    b2Vec2 p = center + radius * axis;
    CGContextMoveToPoint(context, v2p(center).x, v2p(center).y);
    CGContextAddLineToPoint(context, v2p(p).x, v2p(p).y);
    
    CGContextSetRGBStrokeColor(context, color.r, color.g, color.b, 1.0);
    CGContextStrokePath(context);
}

void FMDebugDraw::DrawSegment(const b2Vec2& p1, const b2Vec2& p2, const b2Color& color)
{
    CGContextMoveToPoint(context, v2p(p1).x, v2p(p1).y);
	CGContextAddLineToPoint(context, v2p(p2).x, v2p(p2).y);
    CGContextSetRGBStrokeColor(context, color.r, color.g, color.b, 1.0);
    CGContextStrokePath(context);
}

void FMDebugDraw::DrawTransform(const b2Transform& xf)
{
    b2Vec2 p1 = xf.p, p2;
	const float32 k_axisScale = 0.4f;
	
	p2 = p1 + k_axisScale * xf.q.GetXAxis();
    CGContextMoveToPoint(context, v2p(p1).x, v2p(p1).y);
    CGContextAddLineToPoint(context, v2p(p2).x, v2p(p2).y);
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextStrokePath(context);
    
	p2 = p1 + k_axisScale * xf.q.GetYAxis();
    CGContextMoveToPoint(context, v2p(p1).x, v2p(p1).y);
    CGContextAddLineToPoint(context, v2p(p2).x, v2p(p2).y);
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
    CGContextStrokePath(context);
}

void FMDebugDraw::DrawPoint(const b2Vec2& p, float32 size, const b2Color& color)
{
    CGContextAddRect(context, CGRectMake(v2p(p).x - m2px(size/2.), v2p(p).y - m2px(size/2.), m2px(size), m2px(size)));
    CGContextSetRGBFillColor(context, color.r, color.g, color.b, 1.0);
    CGContextFillPath(context);
}

void FMDebugDraw::DrawString(int x, int y, const char *string, ...)
{
	char buffer[128];
    
	va_list arg;
	va_start(arg, string);
	vsprintf(buffer, string, arg);
	va_end(arg);
    
    [[NSString stringWithUTF8String:buffer] drawAtPoint:v2p(b2Vec2(x, y))];
}

void FMDebugDraw::DrawAABB(b2AABB* aabb, const b2Color& c)
{
    CGContextMoveToPoint(context, m2px(aabb->lowerBound.x), m2px(aabb->lowerBound.y));
    CGContextAddLineToPoint(context, m2px(aabb->upperBound.x), m2px(aabb->lowerBound.y));
    CGContextAddLineToPoint(context, m2px(aabb->upperBound.x), m2px(aabb->upperBound.y));
    CGContextAddLineToPoint(context, m2px(aabb->lowerBound.x), m2px(aabb->upperBound.y));
    CGContextAddLineToPoint(context, m2px(aabb->lowerBound.x), m2px(aabb->lowerBound.y));
    
    CGContextSetRGBStrokeColor(context, c.r, c.g, c.b, 1.0);
    CGContextStrokePath(context);
}
