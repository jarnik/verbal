package samples;

import verbal.VerbalData;
import verbal.VerbalTree;

import openfl.display.Sprite;

import hscript.Expr;
import hscript.Interp;
import hscript.Parser;

class SampleVerbal extends Sprite
{

	private var ui:VerbalTreeOpenFL;
	private var conversation:VerbalTree;

    // HScript
    private var parser:Parser;
	private var interpret:Interp;
	private var visitCounter:Map<Int,Int>;

	public function new ()
	{
		super ();
		this.parser = new Parser();
		this.interpret = new Interp();
        this.interpret.variables.set("visited", this.Hvisited);
        this.visitCounter = new Map<Int,Int>();

		this.addChild(this.ui = new VerbalTreeOpenFL(
			this.onContinueClicked,
			this.onAnswerSelected
		));
		this.conversation = new VerbalTree(
			VerbalData.loadFromJSON(openfl.Assets.getText("sampleData/monkey3.json")),
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
        trace("= "+result);
        return cast(result,Bool);
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
