using UnityEngine;
using System.Collections;
using System.Collections.Generic;

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
        enterNode(0);
    }
    
    public void onContinue(int answerIndex = -1)
    {
        // nextLinks must be null or continue valid next nodes
        Debug.Log("onContinue node "+this.m_CurrentNode+" answer "+answerIndex+" action "+this.m_CurrentAction);

        // make step
        if (this.m_NextLinks != null)
        {
            if (answerIndex >= this.m_NextLinks.Length || this.m_NextLinks[answerIndex] == -1)
            {                
                onConversationEnded();
                return;
            }

            Debug.Log("following link to "+this.m_NextLinks[answerIndex]);
            enterNode(this.m_NextLinks[answerIndex], this.m_ShowingAnswers);
            return;
        }

        nextAction();
    }

    public void onAnswerSelected(int index)
    {
        onContinue(index);
    }
    
    private int[] getNextNodes(int nodeID, bool justOne = false)
    {
        List<int> nodes = new List<int>();
        VerbalNode node = this.m_Data.getNode(nodeID);
        VerbalNode linkedNode;
        int[] linkedNodes;
        bool condsValid;

        if (node.links != null)
        {
            foreach (int link in node.links)
            {
                linkedNode = this.m_Data.getNode(link);
                if (linkedNode == null)
                {
                    continue;
                }

                if (this.m_TestCondCallback != null && linkedNode.conds != null)
                {
                    condsValid = true;
                    foreach (string cond in linkedNode.conds)
                    {
                        if (!this.m_TestCondCallback(cond))
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
                    nodes.AddRange( linkedNodes );
                } else
                {
                    nodes.Add(link);
                }
                if (justOne)
                {
                    break;
                }
            }
        }

        return nodes.ToArray();
    }
    
    private void enterNode(int nodeIndex, bool instantStep = false)
    {
        if (this.m_NodeEnteredCallback != null)
        {
            this.m_NodeEnteredCallback(nodeIndex);
        }

        this.m_CurrentNode = nodeIndex;
        this.m_CurrentAction = -1;
        this.m_ShowingAnswers = false;

        VerbalNode node = this.m_Data.getNode(nodeIndex);

        if (node.group || instantStep)
        {
            int[] nextNodes = getNextNodes(this.m_CurrentNode, true);
            if (nextNodes.Length > 0)
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
    
    private void nextAction()
    {
        // process node
        this.m_CurrentAction++;
        Debug.Log("processing node "+this.m_CurrentNode+" action "+this.m_CurrentAction);
        VerbalNode node= this.m_Data.getNode(this.m_CurrentNode);
        List<string> answers = null;
        if (this.m_CurrentAction < node.actions.Count - 1 )
        {
            // non-last actions
            this.m_NextLinks = null;
        } else
        {
            // last action in the node, fetch links
            int[] nextNodeIDs = getNextNodes(this.m_CurrentNode);

            Debug.Log("fetched links "+nextNodeIDs.Length+", processing...");
            VerbalNode nextNode;
            answers = new List<string>();
            List<int> nextLinks = new List<int>();
            foreach (int nextNodeID in nextNodeIDs)
            {
                nextNode = this.m_Data.getNode(nextNodeID);
                if (nextNode.conds != null && nextNode.conds.Count > 0)
                {
                    answers.Add(nextNode.conds[0]);
                    nextLinks.Add(nextNodeID);
                }
            }
            if (answers.Count == 0)
            {
                // no answer links, simple continue hop
                if (nextNodeIDs.Length > 0)
                {
                    nextLinks = new List<int>(){nextNodeIDs[0]};
                } else 
                {
                    nextLinks = new List<int>(){-1}; // will end conversation
                }
                answers = null;
            } else
            {
                this.m_ShowingAnswers = true;
            }
            this.m_NextLinks = nextLinks.ToArray();
        }

        // action with continue
        string[] answersArray = null;
        if (answers != null)
        {
            answersArray = answers.ToArray();
        }
        this.m_ShowNodeCallback(node.actions[this.m_CurrentAction], answersArray);
    }

    private void onConversationEnded()
    {
        Debug.Log("THE END!");
        this.m_ShowNodeCallback(null, null);
    }

}
