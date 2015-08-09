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
        //this.m_VerbalUI.show("EXAMPLE\n text", new string[] { "AAA", "BBB" });

        /*
		this.parser = new Parser();
		this.interpret = new Interp();
        this.interpret.variables.set("visited", this.Hvisited);
         * */
        this.m_VisitCounter = new Dictionary<int, int>();


        /*
		this.add(this.ui = new VerbalTreeFlixel(
			this.onContinueClicked,
			this.onAnswerSelected
		));
		FlxG.plugins.add(new MouseEventManager());
		*/
		this.m_Conversation = new VerbalTree(
			VerbalData.loadFromJSON(this.m_ConversationJson.ToString()),
			this.m_VerbalUI.show,
			this.testCond,
			this.onNodeEntered
		);


        this.m_Conversation.startConversation();
        
	}

    /*
	private function onContinueClicked() : Void
	{
		this.conversation.onContinue();
	}

	private function onAnswerSelected(index:Int) : Void
	{
		this.conversation.onAnswerSelected(index);
	}

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
        /*
        if (!this.visitCounter.exists(node))
        {
            this.visitCounter[node] = 0;
        }
        this.visitCounter[node] = this.visitCounter[node]+1;
		trace("Entered "+node+" = "+this.visitCounter[node]);
         * */
    }

    /*
    private function Hvisited(node:Int) : Int
    {
        if (this.visitCounter.exists(node))
        {
            return this.visitCounter[node];
        }
        return 0;
    }
    */

}
