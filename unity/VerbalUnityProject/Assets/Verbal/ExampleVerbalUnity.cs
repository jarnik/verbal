using UnityEngine;
using System.Collections;

public class ExampleVerbalUnity : MonoBehaviour 
{

    public TextAsset m_ConversationJson;

	private void Start () 
    {
        VerbalData.loadFromJSON(this.m_ConversationJson.ToString());
	}
}
