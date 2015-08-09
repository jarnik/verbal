using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class VerbalTreeAnswerLine : MonoBehaviour 
{

    public delegate void MouseEventDelegate(int index);

    public Text m_Textfield;
    public Button m_Button;
    public RectTransform m_RectTransform;

    public MouseEventDelegate m_OnMouseEntered;
    public MouseEventDelegate m_OnMouseClicked;
    public MouseEventDelegate m_OnSelected;
    public int m_Index { get; set; }

    public void onMouseEntered()
    {
        Debug.Log("Mouse entered "+this.m_Index);
        this.m_OnMouseEntered(this.m_Index);
    }

    public void onMouseClicked()
    {
        Debug.Log("Mouse clicked " + this.m_Index);
        this.m_OnMouseClicked(this.m_Index);
    }

    public void onSelected()
    {
        Debug.Log("Selected " + this.m_Index);
        this.m_OnSelected(this.m_Index);
    }

}
