//
//  HelloWorldLayer.m
//  Santa
//
//  Created by Anthony Leone on 12/22/11.
//  Copyright Digital Walrus Software 2011. All rights reserved.
// * Permission is hereby granted, free of charge, to any person obtaining a copy
// * of this software and associated documentation files (the "Software"), to deal
// * in the Software without restriction, including without limitation the rights
// * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// * copies of the Software, and to permit persons to whom the Software is
// * furnished to do so, subject to the following conditions:
// * 
// * The above copyright notice and this permission notice shall be included in
// * all copies or substantial portions of the Software.
// * 
// * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// * THE SOFTWARE.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        // Enable touch for cocos2d
        self.isTouchEnabled = YES;
        
        // Ask director the window size, we could put this into an instance variable for re-use
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        beginLabel = [CCLabelTTF labelWithString:@"Touch for Santa" fontName:@"Marker Felt" fontSize:48];
        beginLabel.position = ccp( size.width/2, size.height/2);
        [self addChild: beginLabel];
        
        // Setup sound 
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"santa.wav"];

		// Add the santa sprite to the scene
        santa = [CCSprite spriteWithFile:@"santa.png"];
        [santa setVisible:NO];
        [self addChild:santa];
        
        // Add the merry christmas label to the scene
        label = [CCLabelTTF labelWithString:@"Merry Christmas" fontName:@"Marker Felt" fontSize:48];
        [label setVisible:NO];
        [self addChild: label];
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (void)santaFlyBy {
    
    // ask director the the window size  PART OF THEIR CODE
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    // We are going to NSLog this for explaination, points not pixels 
    NSLog (@"The screen is %f by %f", size.width, size.height);
	
    // re-position label on the screen, because we flew it off the screen during the last animation cycle
    label.position =  ccp( size.width /2 , size.height/2 );
    [santa setPosition:ccp(size.width * -1, size.height/2)];
    
    
    // creates the label animation
    id moveLabel = [CCMoveTo actionWithDuration:8.0f position:ccp(0, 0-size.height/2)];
    [label runAction:moveLabel];
    
    // creates the santa animation
    id moveAction = [CCMoveTo actionWithDuration:8.0f position:ccp(size.width + 600, size.height/2)];
    [santa runAction:moveAction];
    
    // plays the hohoho sound effect, we added in the init.  By preloading during the init we avoid the hesitation for audio processing the .wav file
    [[SimpleAudioEngine sharedEngine] playEffect:@"santa.wav"];
    
        
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // when a touch happens anywhere on the device this meathod is called
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    // set the timer to call our offScreen method every 0.05 seconds
    [self schedule:@selector(offScreen) interval:0.05];
    [beginLabel setVisible:NO];
    
    
    // if santa is not flying, then let him fly
    if ([santa visible] == NO ) {
        [label setVisible:YES];
        [santa setVisible:YES];
        [self santaFlyBy];
    }
    else
        // we only redisplay the beginLabel if santa has completed his animation
        if (santa.position.x > size.width + 240 )
            [beginLabel setVisible:YES];
    
}

- (void)offScreen {
    
    // we check to see if santa has flown off the screen every 0.05 ticks...
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    if (santa.position.x > size.width + 240) {
        [beginLabel setVisible:YES];
        [label setVisible:NO];
        [santa setVisible:NO];
        
    }
}


@end
