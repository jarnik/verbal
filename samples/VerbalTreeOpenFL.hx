package samples;

import verbal.VerbalData;
import verbal.VerbalTree;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.events.MouseEvent;

class VerbalTreeOpenFL extends Sprite
{

    private var COLOR_TEXT : Int = 0x9F2EB3;
    private var COLOR_ANSWER : Int = 0x9F2EB3;
    private var COLOR_ANSWER_HIGHLIGHT : Int = 0xD461E8;

    private var onContinueCallback : Void->Void;
    private var onAnswerSelected : Int->Void;

    private var text : TextField;
    private var answerFields : Array<TextField>;

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
        this.text.textColor = COLOR_TEXT;
        this.answerFields = [];
	}

    private function createTextfield(isAnswer:Bool = false) : TextField
    {
        var textField = new TextField ();
		textField.defaultTextFormat = new TextFormat ("HelvetiPixel", 32, 0x9F2EB3);
		textField.embedFonts = true;
		textField.selectable = false;
		textField.x = 10;
		textField.y = 10;
		textField.width = 600;
		textField.height = 200;
		textField.wordWrap = true;
		textField.multiline = true;
        this.addChild(textField);

        if (isAnswer)
        {
            textField.addEventListener(MouseEvent.MOUSE_OVER,onAnswerMouseEvent);
            textField.addEventListener(MouseEvent.MOUSE_OUT,onAnswerMouseEvent);
            textField.addEventListener(MouseEvent.CLICK,onAnswerMouseEvent);
        }

        return textField;
    }

    public function show(text:String,answers:Array<String>):Void
    {
        this.text.text = text;
        this.text.height = this.text.textHeight;

        var offset:Float = this.text.y + this.text.height + 24;

        var answer:TextField;
        for (i in 0...answers.length)
        {
            if (i >= this.answerFields.length)
            {
                answer = createTextfield(true);
                this.answerFields.push(answer);
            } else
            {
                answer = this.answerFields[i];
            }
            answer.x = 32;
            answer.y = offset;
            answer.textColor = COLOR_ANSWER;
            answer.text = answers[i];
            answer.height = answer.textHeight;
            offset += answer.height;
        }
    }

    private function onAnswerMouseEvent(e:MouseEvent) : Void
    {
        switch (e.type)
        {
            case MouseEvent.MOUSE_OVER:
                cast(e.target,TextField).textColor = COLOR_ANSWER_HIGHLIGHT;
            case MouseEvent.MOUSE_OUT:
                cast(e.target,TextField).textColor = COLOR_ANSWER;
            case MouseEvent.CLICK:
                var answerID:Int = getAnswerTextFieldID(cast(e.target,TextField));
                this.onAnswerSelected(answerID);
                trace("clicked "+answerID);
        }
    }

    private function getAnswerTextFieldID(tf:TextField) : Int
    {
        for (i in 0...this.answerFields.length)
        {
            if (tf == this.answerFields[i])
            {
                return i;
            }
        }
        return -1;
    }

}
