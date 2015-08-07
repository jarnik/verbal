package ;

import verbal.VerbalData;
import verbal.VerbalTree;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class VerbalTreeOpenFL extends Sprite
{

    private var COLOR_TEXT : Int = 0xFFFFFF; /*0x9F2EB3*/
    private var COLOR_ANSWER : Int = 0xD461E8; /*0x9F2EB3*/
    private var COLOR_ANSWER_HIGHLIGHT : Int = 0xFFFFFF; /*0xD461E8*/

    private var onContinueCallback : Void->Void;
    private var onAnswerSelected : Int->Void;

    private var text : TextField;
    private var answerFields : Array<TextField>;

    private var windowWidth:Float = 640;

    // UI
    private var window : Bitmap;
    private var optionPointer : Bitmap;
    private var selectedOption : Int = 0;
    private var optionCount : Int = 0;

	public function new (
        onContinueCallback : Void->Void,
        onAnswerSelected : Int->Void
    )
	{
		super ();

        this.addChild( this.window = new Bitmap(openfl.Assets.getBitmapData("exampleData/window.png")) );
        this.window.scaleX = this.window.scaleY = 2;

        this.addChild( this.optionPointer = new Bitmap(openfl.Assets.getBitmapData("exampleData/pointer_option.png")) );
        this.optionPointer.scaleX = this.optionPointer.scaleY = 2;
        setOptionSelected(-1);

        this.onContinueCallback = onContinueCallback;
        this.onAnswerSelected = onAnswerSelected;


        //font: http://www.pentacom.jp/pentacom/bitfontmaker2/gallery/?id=381
        this.text = createTextfield();
        this.text.textColor = COLOR_TEXT;
        this.answerFields = [];

        this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

    private function onAddedToStage(e:Event) : Void
    {
        this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    }

    private function onKeyDown(e:KeyboardEvent) : Void
    {
        if (!this.visible)
        {
            return;
        }
        
        switch (e.keyCode)
        {
            case Keyboard.DOWN:
                stepOptionSelected(1);
            case Keyboard.UP:
                stepOptionSelected(-1);
            case Keyboard.ENTER, Keyboard.SPACE:
                this.onAnswerSelected(this.selectedOption);
        }
    }

    private function stepOptionSelected(step:Int) : Void
    {
        if (
            this.selectedOption + step >= 0 &&
            this.selectedOption + step < this.optionCount
        )
        {
            setOptionSelected(this.selectedOption + step);
        }
    }

    private function setOptionSelected(index:Int) : Void
    {
        this.selectedOption = index;
        
        if (this.answerFields != null)
        {
            for (answer in this.answerFields)
            {
                if (answer.visible)
                {
                    answer.textColor = COLOR_ANSWER;
                }
            }
        }
        
        if (index >= 0)
        {
            this.optionPointer.visible = true;
            this.optionPointer.x = this.answerFields[index].x;
            this.optionPointer.y = this.answerFields[index].y + this.answerFields[index].textHeight / 2;
            // offset
            this.optionPointer.x += - this.optionPointer.width - 2;
            this.optionPointer.y += - this.optionPointer.height/2 + 2;
            this.answerFields[index].textColor = COLOR_ANSWER_HIGHLIGHT;
        } else
        {
            this.optionPointer.visible = false;
        }
    }

    private function createTextfield(isAnswer:Bool = false) : TextField
    {
        var textField = new TextField ();
    textField.defaultTextFormat = new TextFormat ("HelvetiPixel", 32, 0xffffff /*0x9F2EB3*/);
		textField.embedFonts = true;
		// textField.antiAliasType = openfl.text.AntiAliasType;
		textField.selectable = false;
        var margin:Float = 16;
		textField.x = margin;
		textField.y = margin;
		textField.width = this.windowWidth - 2*margin;
		textField.height = 160 - 2*margin;
		textField.wordWrap = true;
		textField.multiline = true;
        this.addChild(textField);

        if (isAnswer)
        {
            textField.addEventListener(MouseEvent.MOUSE_OVER,onAnswerMouseEvent);
            textField.addEventListener(MouseEvent.CLICK,onAnswerMouseEvent);
        }

        return textField;
    }

    private function hideAllAnswers() : Void
    {
        for (answer in this.answerFields)
        {
            answer.visible = false;
        }
    }

    private function setAnswerField(index:Int, offset:Float, text:String) : Float
    {
        var answer:TextField;
        if (index >= this.answerFields.length)
        {
            answer = createTextfield(true);
            this.answerFields.push(answer);
        } else
        {
            answer = this.answerFields[index];
        }

        answer.visible = true;
        answer.x = 48;
        answer.width = this.windowWidth - answer.x - 15;
        answer.y = offset;
        answer.textColor = COLOR_ANSWER;
        answer.text = text;
        answer.height = answer.textHeight + 2;
        offset += answer.height;

        return offset;
    }

    public function show(text:String,answers:Array<String>):Void
    {
        if (text == null)
        {
            // conversation over, hide
            this.visible = false;
            return;
        }
        
        this.text.text = text;
        this.text.height = this.text.textHeight;

        var offset:Float = this.text.y + this.text.height + 16;

        hideAllAnswers();

        var answer:TextField;
        if (answers == null)
        {
            // show continue button
            setAnswerField(0, offset, "(continue)");
            this.optionCount = 0;
        } else
        {
            // show answers
            for (i in 0...answers.length)
            {
                offset = setAnswerField(i, offset, answers[i]);
            }
            this.optionCount = answers.length;
        }
        setOptionSelected(0);
    }

    private function onAnswerMouseEvent(e:MouseEvent) : Void
    {
        switch (e.type)
        {
            case MouseEvent.MOUSE_OVER:
                cast(e.target,TextField).textColor = COLOR_ANSWER_HIGHLIGHT;
                var answerID:Int = getAnswerTextFieldID(cast(e.target,TextField));
                setOptionSelected( answerID );            
            case MouseEvent.CLICK:
                var answerID:Int = getAnswerTextFieldID(cast(e.target,TextField));
                this.onAnswerSelected(answerID);
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
