//
//  CCLayerExtension.m
//  ChickenRace
//
//  Created by 小川 穣 on 2013/04/14.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "CCLayerExtension.h"
#import "AppDelegate.h"
#import "Utility.h"

#pragma mark - CCLayerExtension

@implementation CCLayerExtension

-(id)init {
	ccsTouchBegan = nil;
	return [super init];
}

// スプライトのタッチ判定用メソッド
-(CGRect)rectForSprite:(CCSprite *)sprite {
    CGRect rect;
    if(sprite != nil) {
    	float h = [sprite contentSize].height*[Utility spriteScaleRate];
    	float w = [sprite contentSize].width*[Utility spriteScaleRate];
    	float x = sprite.position.x - w/2;
    	float y = sprite.position.y - h/2;
    	rect = CGRectMake(x,y,w,h);
    }
    else {
        rect = CGRectMake( 0, 0, 0, 0 );
    }
    return rect;
}

-(bool)touchBeganButton:(CCSprite *)sprite touchLocation:(CGPoint)location {
    return [self touchBeganButton:sprite touchLocation:location scaling:true];
}

-(bool)touchBeganButton:(CCSprite *)sprite touchLocation:(CGPoint)location scaling:(bool)isScale {
    if(CGRectContainsPoint([self rectForSprite:sprite], location)) {
        if(isScale) {
        	[sprite setScale:0.75f * [Utility spriteScaleRate]];
        	[sprite pauseSchedulerAndActions];
        }
        ccsTouchBegan = sprite;
    	return true;
	}	
	return false;
}

-(bool)touchMovedButton:(CCSprite *)sprite touchLocation:(CGPoint)location {
    ccsTouchMoved = nil;
    if(CGRectContainsPoint([self rectForSprite:sprite], location)) {
        ccsTouchMoved = sprite;
        return true;
    }
    return false;
}

-(bool)touchEndButton:(CCSprite *)sprite touchLocation:(CGPoint)location {
	return [self touchEndButton:sprite touchLocation:location isRespawn:false];
}

-(bool)touchEndButton:(CCSprite *)sprite touchLocation:(CGPoint)location isRespawn:(bool)respawn {
    if(CGRectContainsPoint([self rectForSprite:sprite], location)) {
        [sprite resumeSchedulerAndActions];
        id scaleOut = [CCSpawn actions:
    		[CCEaseIn actionWithAction: 
    			[CCScaleBy actionWithDuration:0.1 scale:2 ] rate:2
    		],
    		[CCEaseIn actionWithAction:
    			[CCFadeTo actionWithDuration:0.1 opacity:0 ] rate:2
    		],
    		nil
    	];
        id scaleIn = [CCSpawn actions:
			[CCEaseBounceOut actionWithAction:
				[CCScaleTo actionWithDuration:0.5f 
					scale:[Utility spriteScaleRate]
                ]
			],
			[CCFadeTo actionWithDuration:0.0 opacity:255 ],
			nil
        ];
    	if(respawn) {
			[sprite runAction: 
				[CCSequence actions:
					scaleOut,
					[CCScaleTo actionWithDuration:0.5 scale:0],
					scaleIn,
					nil
				]
			];
		}
		else {
		    [sprite runAction: scaleOut];
	    }
	    return true;
	}
    else if(ccsTouchBegan == sprite) {
    	[ccsTouchBegan resumeSchedulerAndActions];
    	[ccsTouchBegan setScale: [Utility spriteScaleRate]];
    	ccsTouchBegan = nil;
    }
	return false;
}

@end
