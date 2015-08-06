package exampleFlixel;

import openfl.Assets;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
// import flixel.FlxText;

class PlayState extends FlxState
{

	override public function create():Void 
	{
		FlxG.camera.bgColor = 0xFF01355F;

		var txt:FlxText = new FlxText(0, 10, 640, " Sprite filters - click on each sprite to animate or stop animation. ", 16);
		txt.alignment = "center";
		add(txt);
	}
	
	override public function update():Void 
	{
		super.update();

	}
	
}