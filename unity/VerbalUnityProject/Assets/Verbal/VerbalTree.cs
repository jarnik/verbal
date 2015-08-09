using UnityEngine;
using System.Collections;

public class VerbalTree
{

    public delegate void ShowNodeDelegate(string text, string[] answers);
    public delegate bool TestCondDelegate(string cond);
    public delegate void NodeEnteredDelegate(int id);

    private VerbalData m_Data;
    private int m_CurrentNode = -1;
    private int m_CurrentAction = -1;
    private ShowNodeDelegate m_ShowNodeCallback;
    private TestCondDelegate m_TestCondCallback;
    private NodeEnteredDelegate m_NodeEnteredCallback;
    private int[] m_NextLinks;
    private bool m_ShowingAnswers = false;

    public VerbalTree(
        VerbalData data,
        ShowNodeDelegate showNodeCallback,
        TestCondDelegate testCondCallback,
        NodeEnteredDelegate nodeEnteredCallback
    )
    {
        this.m_Data = data;
        this.m_ShowNodeCallback = showNodeCallback;
        this.m_TestCondCallback = testCondCallback;
        this.m_NodeEnteredCallback = nodeEnteredCallback;
    }

    
    public void startConversation()
    {
        //enterNode(0);
    }

    /*
    public function onContinue(answerIndex:Int = -1) : Void
    {
        // nextLinks must be null or continue valid next nodes
        trace("onContinue node "+this.currentNode+" answer "+answerIndex+" action "+this.currentAction);

        // make step
        if (this.nextLinks != null)
        {
            if (answerIndex >= this.nextLinks.length || this.nextLinks[answerIndex] == -1)
            {                
                onConversationEnded();
                return;
            }

            trace("following link to "+this.nextLinks[answerIndex]);
            enterNode(this.nextLinks[answerIndex], this.showingAnswers);
            return;
        }

        nextAction();
    }

    public function onAnswerSelected(index:Int) : Void
    {
        onContinue(index);
    }

    private function getNextNodes(nodeID:Int, justOne:Bool = false):Array<Int>
    {
        var nodes:Array<Int> = [];
        var node:VerbalNode = data.getNode(nodeID);
        var linkedNode:VerbalNode;
        var linkedNodes:Array<Int>;
        var condsValid:Bool;

        if (node.links != null)
        {
            for (link in node.links)
            {
                linkedNode = data.getNode(link);
                if (linkedNode == null)
                {
                    continue;
                }

                if (this.onTestCondCallback != null && linkedNode.conds != null)
                {
                    condsValid = true;
                    for (cond in linkedNode.conds)
                    {
                        if (!this.onTestCondCallback(cond))
                        {
                            condsValid = false;
                            break;
                        }
                    }
                    if (!condsValid)
                    {
                        continue;
                    }
                }

                if (linkedNode.group)
                {
                    linkedNodes = getNextNodes(link, justOne);
                    nodes = nodes.concat( linkedNodes );
                } else
                {
                    nodes.push(link);
                }
                if (justOne)
                {
                    break;
                }
            }
        }

        return nodes;
    }

    private function enterNode(nodeIndex:Int, instantStep:Bool = false) : Void
    {
        if (this.onNodeEnteredCallback != null)
        {
            this.onNodeEnteredCallback(nodeIndex);
        }

        this.currentNode = nodeIndex;
        this.currentAction = -1;
        this.showingAnswers = false;

        var node:VerbalNode = data.getNode(nodeIndex);

        if (node.group || instantStep)
        {
            var nextNodes:Array<Int> = getNextNodes(this.currentNode, true);
            if (nextNodes.length > 0)
            {
                enterNode(nextNodes[0]);
            } else
            {
                onConversationEnded();
            }
            return;
        }

        nextAction();
    }

    private function nextAction() : Void
    {
        // process node
        this.currentAction++;
        trace("processing node "+this.currentNode+" action "+this.currentAction);
        var node:VerbalNode = data.getNode(this.currentNode);
        var answers:Array<String> = null;
        if (this.currentAction < node.actions.length - 1 )
        {
            // non-last actions
            this.nextLinks = null;
        } else
        {
            // last action in the node, fetch links
            var nextNodeIDs:Array<Int> = getNextNodes(this.currentNode);

            trace("fetched links "+nextNodeIDs.length+", processing...");
            var nextNode:VerbalNode;
            var answer:String;
            answers = [];
            this.nextLinks = [];
            for (nextNodeID in nextNodeIDs)
            {
                nextNode = data.getNode(nextNodeID);
                if (nextNode.conds != null && nextNode.conds.length > 0)
                {
                    answers.push(nextNode.conds[0]);
                    this.nextLinks.push(nextNodeID);
                }
            }
            if (answers.length == 0)
            {
                // no answer links, simple continue hop
                if (nextNodeIDs.length > 0)
                {
                    this.nextLinks = [nextNodeIDs[0]];
                } else 
                {
                    this.nextLinks = [-1]; // will end conversation
                }
                answers = null;
            } else
            {
                this.showingAnswers = true;
            }
        }

        // action with continue
        this.onShowNodeCallback(node.actions[this.currentAction], answers);
    }
    
    private function onConversationEnded() : Void
    {
        trace("THE END!");
        this.onShowNodeCallback(null, null);
    }

 
    */

}
