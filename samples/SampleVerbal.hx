package;

import openfl.display.Sprite;

class SampleVerbal extends Sprite
{

	public function new ()
	{
		super ();

		var conversation:VerbalIntFic = new VerbalIntFic(
			VerbalData.loadFromFile("sampleData/conversation.json")
		)

	}

}
