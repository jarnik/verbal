using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;

public class VerbalTreeUI : MonoBehaviour 
{

    private int COLOR_TEXT = 0xFFFFFF;
    private int COLOR_ANSWER = 0xD461E8;
    private int COLOR_ANSWER_HIGHLIGHT = 0xFFFFFF;

    public Text m_Text;
    public RectTransform m_OptionPointerRectTransform;
    public VerbalTreeAnswerLine m_AnswerTemplate;
    private List<VerbalTreeAnswerLine> m_AnswerFields;

    private int m_SelectedOption = 0;
    private int m_OptionCount = 0;

    /*
    private var onContinueCallback : Void->Void;
    private var onAnswerSelected : Int->Void;

    public function new (
        onContinueCallback : Void->Void,
        onAnswerSelected : Int->Void
    )
    {
        super ();*/

    private void Start()
    {
        setOptionSelected(-1);

        //this.onContinueCallback = onContinueCallback;
        //this.onAnswerSelected = onAnswerSelected;

        //font: http://www.pentacom.jp/pentacom/bitfontmaker2/gallery/?id=381
        this.m_AnswerFields = new List<VerbalTreeAnswerLine>();
    }
    
    /*
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
    */
    private void setOptionSelected(int index)
    {
        /*
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
        }*/
    }
    /*
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
    */

    private void hideAllAnswers()
    {
        foreach (VerbalTreeAnswerLine answer in this.m_AnswerFields)
        {
            answer.gameObject.SetActive(false);
        }
    }

    private float setAnswerField(int index, float offset, string text)
    {
    /*
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
    */
        return offset;
    }

    public void show(string text, string[] answers)
    {
        if (text == null)
        {
            // conversation over, hide
            this.gameObject.SetActive(false);
            return;
        }
        
        this.m_Text.text = text;

        float offset = this.m_Text.rectTransform.anchoredPosition.y + this.m_Text.preferredHeight;

        hideAllAnswers();

        VerbalTreeAnswerLine answer;
        if (answers == null)
        {
            // show continue button
            setAnswerField(0, offset, "(continue)");
            this.m_OptionCount = 0;
        } else
        {
            // show answers
            for (int i = 0; i < answers.Length; i++ )
            {
                offset = setAnswerField(i, offset, answers[i]);
            }
            this.m_OptionCount = answers.Length;
        }
        setOptionSelected(0);
    }
    /*
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

     */

}
