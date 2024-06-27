trace('menus/TitleAddons.hx has loaded succesfully');
import("lime.app.Application");
import("TitleState");
import("FlashingState");
import("MusicBeatState");
import("flixel.addons.transition.FlxTransitionableState");

function setFunction(obj, tag, func){
	if(obj.functionVariables != null){
		obj.functionVariables.set(tag, func);
	}
}

function selectionControls(input:String){
	var controls = FlxG.state.controls;
	switch(input){
		case "pressedEnter": return FlxG.state._selectionControls("pressedEnterToSkip");
		case "pressedEnterToSkip": return false;
		case "pressedEnterToGame": return FlxG.state._selectionControls("pressedEnterToGame");
		case "UI_LEFT":  return controls.UI_LEFT;
		case "UI_RIGHT":  return controls.UI_RIGHT;
		default: return false;
	}
	return false;	
}

function super_new(state){
	Application.current.window.title = "SUNDAY NIGHT SUICIDE 2.5 RETAKE";
	state.titleTextColors = [0xFFff004e, 0xFFedff00];
	setFunction(TitleState, "selectionControls", selectionControls);
    FlxG.sound.playMusic(Paths.music('freakyMenu'), 1);
}

function super_runOnce(){
	if(!TitleState.useSickBeatPost){
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		FlashingState.leftState = false;
		MusicBeatState.switchState(new FlashingState());
		TitleState.useSickBeatPost = true;
	}
}

import("hxcodec.flixel.FlxVideo");
var videoDone = false;
var video:FlxVideo = null;
function sickBeatPost(sickBeats){
	var G = FlxG.state;
	var beatMult = 1;
	
	if(G.sickBeats == 1){
		video = new FlxVideo();
		video.play(Paths.video("intro"));
		
		video.onEndReached.add(function()
		{
			videoDone = true;
			return;
		}, true);
	}
	
	/*
	if(G.sickBeats>1){
		G.deleteCoolText();
	}
	G.createCoolText([''], 15);
	G.addMoreText(G.sickBeats, -40);
	*/
	
	if(videoDone && video!=null){
		//Beat 31!
		video.dispose();
		video =null;
		G.skipIntro();
	}
	

	
	/*switch (G.sickBeats){
		case 1*beatMult:
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
			G.createCoolText(['SNS RETAKE TEAM'], 15);
			G.addMoreText('present', 15);		
		case 2*beatMult:
			//deleteCoolText();
			G.deleteCoolText();
		case 3*beatMult:
			//G.createCoolText(['A Mod for'], -40);
			G.createCoolText(['Not associated', 'with'], -40);
			G.addMoreText('newgrounds', -40);
			G.ngSpr.visible = true;
			//createCoolText(['In association', 'with'], -40);
		case 4*beatMult:
			G.deleteCoolText();
			G.ngSpr.visible = false;
		case 5*beatMult:
			G.addMoreText('I hope', -40);
			G.addMoreText("Y'all Enjoy", -40);
		case 6*beatMult:
			G.deleteCoolText();
		case 7*beatMult:
			G.addMoreText('Sunday');
			G.addMoreText('Night');
		case 8*beatMult:
			G.addMoreText('Suicide'); // credTextShit.text += '\nFunkin';
			G.addMoreText('Retake'); // credTextShit.text += '\nFunkin';

		case 9*beatMult:
			G.skipIntro();
	}*/
}
var background = null;
var introTitle = [];

var introMouse = null;
function startIntroPost(){
	var G  = FlxG.state;
	background = G.members[1];
	G.gfDance.visible = false;
	
	var gfDance= new FlxSprite(0,0);
	gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
	gfDance.animation.addByPrefix('dance', 'gfDance', 14, true);
	gfDance.animation.play('dance');
	gfDance.scrollFactor.set();
	gfDance.x = G.gfDance.x;
	gfDance.y = G.gfDance.y;
	introMouse = gfDance;
	G.insert(4,introMouse);
	/*animation.getByName('danceLeft').frameRate = 7;
	G.gfDance.animation.getByName('danceRight').frameRate = 7;
	G.gfDance.animation.getByName('danceLeft').timeScale = 0.5;
	G.gfDance.animation.getByName('danceRight').timeScale = 0.5;
	trace(G.gfDance.animation.getByName('danceRight').frameRate);
	* */
	
	G.logoBl.scale.set(0.7,0.7);
	introTitle[0] = G.logoBl.x;
	introTitle[1] = G.logoBl.y;
	background.screenCenter(); 

	var shaderCode= File.getContent(Paths.mods('shaders/')+"wiggle.frag");
	background.shader = new FlxRuntimeShader(shaderCode, null);
	background.shader.setInt("effectType",4);
	background.shader.setFloat("uSpeed", 3.5);
	background.shader.setFloat("uFrequency", 8);
	background.shader.setFloat("uWaveAmplitude", 0.025);

}

function super_beatHit(){
	if(introMouse != null){
		introMouse.animation.play('dance');
	}
}
	
var inc = 0.0;
var skippedIntro = false;
function super_update(elapsed){
	var G  = FlxG.state;
	var background = FlxG.state.members[1];
	
	/*if (FlxG.sound.music != null)
		Conductor.songPosition = FlxG.sound.music.time;*/
		
	inc+=0.005;
	if(background != null && background.shader !=null)
		background.shader.setFloat("uTime", inc*50*elapsed);
	
	if(G.logoBl != null)
		G.logoBl.y = introTitle[1] + Math.sin(inc*500*elapsed)*10;
		
	if(G.skippedIntro != skippedIntro){
		skippedIntro = G.skippedIntro;
		if(video!=null){
			videoDone =true;
			video.time = video.duration;
			video.stop();
			video.dispose();
			video = null;
		}
	}
}
