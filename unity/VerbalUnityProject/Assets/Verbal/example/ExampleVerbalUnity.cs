using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ExampleVerbalUnity : MonoBehaviour 
{

    public TextAsset m_ConversationJson;
    public VerbalTreeUI m_VerbalUI;

	private VerbalTree m_Conversation;

    /*
    // HScript
    private var parser:Parser;
	private var interpret:Interp;
     * */
	private Dictionary<int,int> m_VisitCounter;

	private void Start () 
	{
        /*
		this.parser = new Parser();
		this.interpret = new Interp();
        this.interpret.variables.set("visited", this.Hvisited);
         * */
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

    /*
    //////////// HScript /////////////////////////////////////////
    */
    private bool testCond(string cond)
    {
        /*
		// Hscript conditions start with #
		if (!StringTools.startsWith(cond,"#"))
		{
			return true;
		}
		cond = cond.substr(1);
        trace("test "+cond);
        var result = this.interpret.execute(this.parser.parseString(cond));
		var resultBool:Bool = cast(result,Bool);
        trace("= "+resultBool);
        return resultBool;*/

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
    
    private int Hvisited(int node)
    {
        if (this.m_VisitCounter.ContainsKey(node))
        {
            return this.m_VisitCounter[node];
        }
        return 0;
    }    

}
