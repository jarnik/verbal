package samples;

import verbal.VerbalData;
import verbal.VerbalTree;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

class VerbalTreeOpenFL extends Sprite
{

    private var onContinueCallback : Void->Void;
    private var onAnswerSelected : Int->Void;

    private var text : TextField;
    private var answers : Array<TextField>;

	public function new (
        onContinueCallback : Void->Void,
        onAnswerSelected : Int->Void
    )
	{
		super ();
        this.onContinueCallback = onContinueCallback;
        this.onAnswerSelected = onAnswerSelected;

        //this.scaleX = this.scaleY = 2;

        //font: http://www.pentacom.jp/pentacom/bitfontmaker2/gallery/?id=381
        this.text = createTextfield();
		//this.text.text = "Lorem Ipsum dolor sit amet Lorem Ipsum dolor sit ametLorem Ipsum dolor sit ametLorem Ipsum dolor sit ametLorem Ipsum dolor sit amet";
	}

    private function createTextfield() : TextField
    {
        var textField = new TextField ();
		textField.defaultTextFormat = new TextFormat ("HelvetiPixel", 32, 0x9F2EB3);
		textField.embedFonts = true;
		textField.selectable = false;
		textField.x = 10;
		textField.y = 10;
		textField.width = 300;
		textField.height = 200;
		textField.wordWrap = true;
		textField.multiline = true;
		textField.text = "Lorem Ipsum dolor sit amet Lorem Ipsum dolor sit ametLorem Ipsum dolor sit ametLorem Ipsum dolor sit ametLorem Ipsum dolor sit amet";
        this.addChild(textField);
        return textField;
    }

    public function show(text:String,answers:Array<String>):Void
    {
        this.text.text = text;
        this.text.height = this.text.textHeight + 20;
    }

}
