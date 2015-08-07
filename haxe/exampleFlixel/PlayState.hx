package ;

import openfl.Assets;

import verbal.VerbalTree;
import verbal.VerbalData;

import hscript.Parser;
import hscript.Interp;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.plugin.MouseEventManager;

class PlayState extends FlxState
{

	private var ui:VerbalTreeFlixel;
	private var conversation:VerbalTree;

    // HScript
    private var parser:Parser;
	private var interpret:Interp;
	private var visitCounter:Map<Int,Int>;

	override public function create():Void 
	{
		this.parser = new Parser();
		this.interpret = new Interp();
        this.interpret.variables.set("visited", this.Hvisited);
        this.visitCounter = new Map<Int,Int>();

		this.add(this.ui = new VerbalTreeFlixel(
			this.onContinueClicked,
			this.onAnswerSelected
		));
		FlxG.plugins.add(new MouseEventManager());
		
		this.conversation = new VerbalTree(
			VerbalData.loadFromJSON(openfl.Assets.getText("exampleData/tree_example.json")),
			this.ui.show,
			this.testCond,
			this.onNodeEntered
		);
		this.conversation.start();
	}

	private function onContinueClicked() : Void
	{
		this.conversation.onContinue();
	}

	private function onAnswerSelected(index:Int) : Void
	{
		this.conversation.onAnswerSelected(index);
	}

    //////////// HScript /////////////////////////////////////////

    private function testCond(cond:String) : Bool
    {
		// Hscript conditions start with #
		if (!StringTools.startsWith(cond,"#"))
		{
			return true;
		}
		cond = cond.substr(1);
        trace("test "+cond);
        var result = this.interpret.execute(this.parser.parseString(cond));
		var resultBool:Bool = cast(result,Bool);
        trace("= "+resultBool);
        return resultBool;
    }

    private function onNodeEntered(node:Int) : Void
    {
        if (!this.visitCounter.exists(node))
        {
            this.visitCounter[node] = 0;
        }
        this.visitCounter[node] = this.visitCounter[node]+1;
		trace("Entered "+node+" = "+this.visitCounter[node]);
    }

    private function Hvisited(node:Int) : Int
    {
        if (this.visitCounter.exists(node))
        {
            return this.visitCounter[node];
        }
        return 0;
    }
}