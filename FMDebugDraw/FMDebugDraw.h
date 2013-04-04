//
//  FMDebugDraw.h
//  Chime
//
//  Created by Maurizio Cremaschi on 20/02/2013.
//  Copyright (c) 2013 Myfleek Ltd. All rights reserved.
//

#ifndef __FMDebugDraw__
#define __FMDebugDraw__

#include <Box2D/Box2D.h>

class FMDebugDraw : public b2Draw
{
    
public:
    
    void DrawDebugData(b2World *world, CGContextRef draw_context, CGSize draw_space_size, int pixels_per_meter_rate);
	void DrawPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color);
	void DrawSolidPolygon(const b2Vec2* vertices, int32 vertexCount, const b2Color& color);
	void DrawCircle(const b2Vec2& center, float32 radius, const b2Color& color);
	void DrawSolidCircle(const b2Vec2& center, float32 radius, const b2Vec2& axis, const b2Color& color);
	void DrawSegment(const b2Vec2& p1, const b2Vec2& p2, const b2Color& color);
	void DrawTransform(const b2Transform& xf);
	void DrawPoint(const b2Vec2& p, float32 size, const b2Color& color);
	void DrawString(int x, int y, const char* string, ...);
	void DrawAABB(b2AABB* aabb, const b2Color& color);
    
private:
    
    CGContextRef context;
	int pixels_per_meter;
    CGSize space_size;
    
    inline CGPoint v2p(b2Vec2 v)
    {
        CGPoint p;
        p.x = m2px(v.x);
        p.y = m2px((px2m(space_size.height) - v.y));
        return p;
    }
    
    inline CGFloat m2px(float32 m)
    {
        return m*pixels_per_meter;
    }
    
    inline float32 px2m(CGFloat p)
    {
        return p/pixels_per_meter;
    }
};

#endif /* defined(__FMDebugDraw__) */
