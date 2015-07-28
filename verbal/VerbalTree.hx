package verbal;

class VerbalTree
{
    private var data : VerbalData = null;
	private var currentNode:Int = -1;
	private var currentAction:Int = -1;
    private var onShowNodeCallback: String->Array<String>->Void;
    private var onTestCondCallback: String->Bool;
    private var onNodeEnteredCallback: Int->Void;
    private var nextLinks:Array<Int>;
    private var showingAnswers : Bool = false;

	public function new(
        data:VerbalData,
        onShowNodeCallback: String->Array<String>->Void,
        onTestCondCallback: String->Bool = null,
        onNodeEnteredCallback: Int->Void = null
    ) : Void
	{
		this.data = data;
        this.onShowNodeCallback = onShowNodeCallback;
        this.onTestCondCallback = onTestCondCallback;
        this.onNodeEnteredCallback = onNodeEnteredCallback;
	}

    public function start():Void
    {
        enterNode(0);
    }

    public function onContinue(answerIndex:Int = -1) : Void
    {
        // nextLinks must be null or continue valid next nodes
        trace("onContinue node "+this.currentNode+" answer "+answerIndex+" action "+this.currentAction);

        // make step
        if (this.nextLinks != null)
        {
            if (this.nextLinks[answerIndex] == null)
            {
                trace("THE END!");
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
                trace("THE END!");
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
                this.nextLinks = [nextNodeIDs[0]];
                answers = null;
            } else
            {
                this.showingAnswers = true;
            }
        }

        // action with continue
        this.onShowNodeCallback(node.actions[this.currentAction], answers);
    }


}
