package samples;

import openfl.display.Sprite;

import verbal.VerbalData;
import verbal.VerbalIntFic;

class SampleVerbal extends Sprite
{

	public function new ()
	{
		super ();

		var conversation:VerbalIntFic = new VerbalIntFic(
			VerbalData.loadFromJSON(
				openfl.Assets.getText("sampleData/conversation.json")
			)
		);

		conversation.onInput("kokodak");
		conversation.onInput("#inputYes()");
		conversation.onInput("jarnik");
	}

}
