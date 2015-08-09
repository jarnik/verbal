using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using System.Collections;
using System.Collections.Generic;

public class VerbalTreeUI : MonoBehaviour 
{

    public delegate void AnswerCallback(int index);

    public Text m_Text;
    public RectTransform m_PointerRect;
    public VerbalTreeAnswerLine m_AnswerTemplate;
    public Color COLOR_TEXT;
    public Color COLOR_ANSWER;
    public Color COLOR_ANSWER_HIGHLIGHT;

    private List<VerbalTreeAnswerLine> m_AnswerFields;

    public AnswerCallback m_OnAnswerSelected;

    private void Awake()
    {
        this.m_AnswerTemplate.gameObject.SetActive(false);

        //font: http://www.pentacom.jp/pentacom/bitfontmaker2/gallery/?id=381
        this.m_AnswerFields = new List<VerbalTreeAnswerLine>();
    }
    
    private void setOptionSelected(int index, bool forceSelect = true)
    {
        if (this.m_AnswerFields != null)
        {
            foreach (VerbalTreeAnswerLine answer in this.m_AnswerFields)
            {
                if (answer.gameObject.activeSelf)
                {
                    answer.m_Textfield.color = COLOR_ANSWER;
                }
            }
        }

        this.m_PointerRect.gameObject.SetActive(index >= 0);

        if (forceSelect)
        {
            EventSystem.current.SetSelectedGameObject(index >= 0 ? this.m_AnswerFields[index].gameObject : null);
        }
       
        if (index >= 0)
        {
            this.m_PointerRect.anchoredPosition = new Vector2(
                this.m_PointerRect.anchoredPosition.x,
                this.m_AnswerFields[index].m_RectTransform.anchoredPosition.y - 16.0f
            );
            this.m_AnswerFields[index].m_Textfield.color = COLOR_ANSWER_HIGHLIGHT;
        }
    }
    
    private VerbalTreeAnswerLine createTextfield()
    {
        GameObject answerGameObject = GameObject.Instantiate(this.m_AnswerTemplate.gameObject);
        answerGameObject.transform.SetParent(this.m_AnswerTemplate.transform.parent);
        answerGameObject.transform.position = this.m_AnswerTemplate.transform.position;

        VerbalTreeAnswerLine answer = answerGameObject.GetComponent<VerbalTreeAnswerLine>();
        answer.m_RectTransform.localScale = this.m_AnswerTemplate.m_RectTransform.localScale;
        answer.m_OnMouseEntered = this.onMouseOver;
        answer.m_OnMouseClicked = this.onMouseClick;
        answer.m_OnSelected = this.onOptionSelected;
        return answer;
    }
    
    private void onMouseOver(int answerID)
    {
        Debug.Log("OVER "+answerID);
        setOptionSelected( answerID);
    }
    
    private void onMouseClick(int answerID)
    {
        Debug.Log("CLICK "+answerID);
        this.m_OnAnswerSelected(answerID);
    }

    private void onOptionSelected(int answerID)
    {
        Debug.Log("SELECT " + answerID);
        setOptionSelected(answerID,false);
    }

    private void hideAllAnswers()
    {
        foreach (VerbalTreeAnswerLine answer in this.m_AnswerFields)
        {
            answer.gameObject.SetActive(false);
        }
    }

    private float setAnswerField(int index, float offset, string text)
    {
    
        VerbalTreeAnswerLine answer;
        if (index >= this.m_AnswerFields.Count)
        {
            answer = createTextfield();
            this.m_AnswerFields.Add(answer);
        } else
        {
            answer = this.m_AnswerFields[index];
        }

        answer.gameObject.SetActive(true);
        answer.m_RectTransform.anchoredPosition = new Vector2(
            answer.m_RectTransform.anchoredPosition.x,
            -offset
        );
        answer.m_Textfield.text = text;
        answer.m_Index = index;
        answer.name = "Answer " + (index + 1).ToString();
        Navigation navigation;
        navigation = new Navigation();
        navigation.mode = Navigation.Mode.Explicit;
        if (index > 0)
        {
            navigation.selectOnUp = this.m_AnswerFields[index - 1].m_Button;
        }
        answer.m_Button.navigation = navigation;
        if (index > 0)
        {
            navigation = this.m_AnswerFields[index - 1].m_Button.navigation;
            navigation.selectOnDown = answer.m_Button;
            this.m_AnswerFields[index - 1].m_Button.navigation = navigation;
        }

        offset += answer.m_Textfield.preferredHeight + 8;
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

        float offset = -this.m_Text.rectTransform.anchoredPosition.y + this.m_Text.preferredHeight + 16;

        hideAllAnswers();

        if (answers == null)
        {
            // show continue button
            setAnswerField(0, offset, "(continue)");
        } else
        {
            // show answers
            for (int i = 0; i < answers.Length; i++ )
            {
                offset = setAnswerField(i, offset, answers[i]);
            }
        }
        setOptionSelected(0);
    }

}
