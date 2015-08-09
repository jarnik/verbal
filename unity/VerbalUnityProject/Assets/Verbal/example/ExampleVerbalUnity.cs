using UnityEngine;
using System.Text.RegularExpressions;
using System.Collections;
using System.Collections.Generic;

public class ExampleVerbalUnity : MonoBehaviour 
{

    public TextAsset m_ConversationJson;
    public VerbalTreeUI m_VerbalUI;

	private VerbalTree m_Conversation;

	private Dictionary<int,int> m_VisitCounter;

	private void Start () 
	{
        this.m_VisitCounter = new Dictionary<int, int>();

		this.m_Conversation = new VerbalTree(
			VerbalData.loadFromJSON(this.m_ConversationJson.ToString()),
			this.m_VerbalUI.show,
			this.testCond,
			this.onNodeEntered
		);

        this.m_VerbalUI.m_OnAnswerSelected = this.m_Conversation.onAnswerSelected;

        this.m_Conversation.startConversation();
	}

    private bool testCond(string cond)
    {
        // proper script interpreter integration (LUA etc.) is beyond the scope of this example
        // simply match just a single command - "#visited(nodeID)>visitCount"
        Regex regex = new Regex(@"#visited\((\d+)\)>(\d+)");
        Match match = regex.Match(cond);
        if (match.Success)
        {
            int nodeID = int.Parse(match.Groups[1].ToString());
            int visitCount = int.Parse(match.Groups[2].ToString());
            return this.visited(nodeID) > visitCount;
        }

        return true;
    }

    private void onNodeEntered(int node)
    {
        if (!this.m_VisitCounter.ContainsKey(node))
        {
            this.m_VisitCounter.Add(node, 0);
        }
        this.m_VisitCounter[node] = this.m_VisitCounter[node]+1;
		Debug.Log("Entered "+node+" = "+this.m_VisitCounter[node]);
    }
    
    private int visited(int node)
    {
        if (this.m_VisitCounter.ContainsKey(node))
        {
            return this.m_VisitCounter[node];
        }
        return 0;
    }    

}
