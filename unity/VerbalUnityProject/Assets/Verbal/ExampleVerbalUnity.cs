using UnityEngine;
using System.Collections;

public class ExampleVerbalUnity : MonoBehaviour 
{

    public TextAsset m_ConversationJson;
    public VerbalTreeUI m_VerbalUI;

	private void Start () 
    {
        VerbalData.loadFromJSON(this.m_ConversationJson.ToString());

        this.m_VerbalUI.show("EXAMPLE\n text", new string[] { "AAA", "BBB" });
	}
}
