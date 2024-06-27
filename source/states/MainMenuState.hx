trace('menus/MainMenuAddons.hx has loaded succesfully');
import("MainMenuState");

var selectedOption = null;
// FlxG.state.optionShit[curSelected];
var gfDance = null;
var bars = null;

function setFunction(obj, tag, func){
	if(obj.functionVariables != null){
		obj.functionVariables.set(tag, func);
	}
}
import("flixel.addons.transition.FlxTransitionableState");
function super_new(state){
	FlxTransitionableState.skipNextTransOut = true;
	state.optionShit =  [
		'story_mode',
		'freeplay',
		//'mods',
		'options'
		'credits'	
	];
	
	setFunction(MainMenuState, "selectionControls", selectionControls);

}

function selectionControls(expected:Int){
	var controls = FlxG.state.controls;
	switch(expected){
		case -2: return controls.UI_UP;
		case -1: return controls.UI_UP_P;
		case 0:  if(controls.ACCEPT && bars!=null){
					//trace(bars.x);
					FlxTween.tween(bars, {x: 159.5}, 0.4, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							trace("ha");
						}
					});
					
					
					for( i in FlxG.state.menuItems) {
						FlxTween.tween(i, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut
						});
					}
				}
				return controls.ACCEPT;//return controls.ACCEPT;
		case -100:  return false;
		case 1:  return controls.UI_DOWN_P;
		case 2:  return controls.UI_DOWN;
	}
	return false;
}

function super_runOnce(){
	var text1 = FlxG.state.members[FlxG.state.members.length-2];
	var text2 = FlxG.state.members[FlxG.state.members.length-3];
	text1.visible = false;
	text2.visible = false;
	
	var background = FlxG.state.bg;
	background.loadGraphic(Paths.image("mainBG"));
	background.setGraphicSize(FlxG.width *1.2,FlxG.height*1.2);
	background.scrollFactor.set(0,0.03);
	background.screenCenter();
	
	bars = new FlxSprite(0,0);
	bars.loadGraphic(Paths.image("bars"));
	bars.setGraphicSize(FlxG.width *1.2,FlxG.height*1.2);
	bars.scrollFactor.set(0,0.03);
	bars.x =159.5; //919.5;
	FlxTween.tween(bars, {x: 919.5}, 0.4, {
		ease: FlxEase.quadOut,
		onComplete: function(twn:FlxTween)
		{
			for( i in FlxG.state.menuItems) {
				FlxTween.tween(i, {alpha: 1}, 0.4, {
					ease: FlxEase.quadOut
				});
			}
		}
	});
	
	//bars.screenCenter();
	//bars.x +=FlxG.width/2;
	//trace("a:"+bars.x);
	FlxG.state.insert(1,bars);
	
	gfDance= new FlxSprite(0,0);
	gfDance.frames = Paths.getSparrowAtlas('MickeyDanceMain');
	gfDance.animation.addByIndices('dance', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 14, true);
	gfDance.animation.play('dance');
	gfDance.antialiasing = ClientPrefs.globalAntialiasing;
	gfDance.screenCenter();
	gfDance.scrollFactor.set();
	gfDance.x -=FlxG.width/4;
	
	FlxG.state.insert(1,gfDance);
	
	var shaderCode= File.getContent(Paths.mods('shaders/')+"wiggle.frag");
	background.shader = new FlxRuntimeShader(shaderCode, null);
	background.shader.setInt("effectType",0);
	background.shader.setFloat("uSpeed", 0.5);
	background.shader.setFloat("uFrequency", 6);
	background.shader.setFloat("uWaveAmplitude", 0.05);
	
	for( i in FlxG.state.menuItems) {
		i.x+= 350;
		i.y+= 25;
		i.alpha = 0;
	}
}
/*var danceLeft =false;
function super_beatHit(){
	if(gfDance != null) {
		danceLeft = !danceLeft;
		if (danceLeft)
			gfDance.animation.play('danceRight');
		else
			gfDance.animation.play('danceLeft');
	}
}*/

var inc = 0.0;
function super_update(){
	var background = FlxG.state.bg;
	
	/*if (FlxG.sound.music != null)
		Conductor.songPosition = FlxG.sound.music.time;*/
		
	inc+=0.005;
	if(background != null && background.shader !=null)
		background.shader.setFloat("uTime", inc);
}
