package ;

import verbal.VerbalData;
import verbal.VerbalTree;

import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
import flixel.FlxG;

class VerbalTreeFlixel extends FlxGroup
{

    private var COLOR_TEXT : Int = 0xFFFFFF;
    private var COLOR_ANSWER : Int = 0xD461E8;
    private var COLOR_ANSWER_HIGHLIGHT : Int = 0xFFFFFF;

    private var onContinueCallback : Void->Void;
    private var onAnswerSelected : Int->Void;

    private var text : FlxText;
    private var answerFields : Array<FlxText>;

    private var windowWidth:Float = 320;

    // UI
    private var window : FlxSprite;
    private var optionPointer : FlxSprite;
    private var selectedOption : Int = 0;
    private var optionCount : Int = 0;

	public function new (
        onContinueCallback : Void->Void,
        onAnswerSelected : Int->Void
    )
	{
		super ();

        this.add( this.window = new FlxSprite(0,0,"exampleData/window.png") );
        

        this.add( this.optionPointer = new FlxSprite(0,0,"exampleData/pointer_option.png") );
        setOptionSelected(-1);

        this.onContinueCallback = onContinueCallback;
        this.onAnswerSelected = onAnswerSelected;

        //font: http://www.pentacom.jp/pentacom/bitfontmaker2/gallery/?id=381
        this.text = createTextfield();
        this.answerFields = [];        
	}
    
    public override function update():Void
    {
        if(FlxG.keys.justPressed.DOWN)
        {
            stepOptionSelected(1);
        }
        if(FlxG.keys.justPressed.UP)
        {
            stepOptionSelected(-1);
        }
        if(FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
        {
            this.onAnswerSelected(this.selectedOption);
        }
        super.update();
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
                    answer.setFormat(null, 8, COLOR_ANSWER);
                }
            }
        }
        
        if (index >= 0)
        {
            this.optionPointer.visible = true;
            this.optionPointer.x = this.answerFields[index].x;
            this.optionPointer.y = this.answerFields[index].y - 2;
            // offset
            this.optionPointer.x += - this.optionPointer.width - 2;
            this.answerFields[index].setFormat(null, 8, COLOR_ANSWER_HIGHLIGHT);
        } else
        {
            this.optionPointer.visible = false;
        }
    }

    private function createTextfield(isAnswer:Bool = false) : FlxText
    {
        var textField:FlxText = new FlxText();
        textField.setFormat(null,8,0xffffff);
        var margin:Float = 8;
		textField.x = margin;
		textField.y = margin;
		textField.fieldWidth = this.windowWidth - 2*margin;
		textField.wordWrap = true;
        this.add(textField);

        if (isAnswer)
        {
            MouseEventManager.add( textField, onMouseClick, null, onMouseOver );
        }

        return textField;
    }
    
    private function onMouseOver(tf:FlxText) : Void
    {
        var answerID:Int = getAnswerTextFieldID(tf);
        trace("OVER "+answerID);
        setOptionSelected( answerID );
    }
    
    private function onMouseClick(tf:FlxText) : Void
    {
        var answerID:Int = getAnswerTextFieldID(tf);
        trace("CLICK "+answerID);
        this.onAnswerSelected(answerID);
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
        var answer:FlxText;
        if (index >= this.answerFields.length)
        {
            answer = createTextfield(true);
            this.answerFields.push(answer);
        } else
        {
            answer = this.answerFields[index];
        }

        answer.visible = true;
        answer.x = 20;
        answer.width = this.windowWidth - answer.x - 15;
        answer.y = offset;
        answer.text = text;
        answer.height = 9;
        offset += 12;

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

        var offset:Float = this.text.y + 8 + 16;

        hideAllAnswers();

        var answer:FlxText;
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
    
    private function getAnswerTextFieldID(tf:FlxText) : Int
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
