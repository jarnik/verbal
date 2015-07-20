package samples;

import openfl.display.Sprite;

import verbal.VerbalData;
import verbal.VerbalTree;

class SampleVerbal extends Sprite
{

	private var ui:VerbalTreeOpenFL;
	private var conversation:VerbalTree;

	public function new ()
	{
		super ();

		this.conversation = new VerbalTree(
			VerbalData.loadFromJSON(openfl.Assets.getText("sampleData/monkey.json")),
			this.onShowNode
		);
		this.addChild(this.ui = new VerbalTreeOpenFL(
			this.onContinueClicked,
			this.onAnswerSelected
		));
		this.conversation.start();
	}

	private function onShowNode(text:String, answers:Array<String>) : Void
	{
		this.ui.show(text,answers);
	}

	private function onContinueClicked() : Void
	{
		this.conversation.onContinue();
	}

	private function onAnswerSelected(index:Int) : Void
	{
		this.conversation.onAnswerSelected(index);
	}

}
