package verbal;

class VerbalTree
{
    private var data : VerbalData = null;
	private var currentNode:Int = -1;
	private var currentAction:Int = -1;
    private var onShowNodeCallback: String->Array<String>->Void;
    private var nextLinks:Array<Int>;
    private var showingAnswers : Bool = false;

	public function new(
        data:VerbalData,
        onShowNodeCallback: String->Array<String>->Void
    ) : Void
	{
		this.data = data;
        this.onShowNodeCallback = onShowNodeCallback;
	}

    public function start():Void
    {
        //this.onShowNodeCallback("What the heck?! You scared me to death!",["AAA","BBB","CCC"]);
        this.currentNode = 0;
        this.currentAction = -1;
        onContinue();
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
            this.currentNode = this.nextLinks[answerIndex];
            this.currentAction = -1;

            if (this.showingAnswers)
            {
                // step from answer node to next available
                this.showingAnswers = false;
                var nextNodeIDs:Array<Int> = getNextNodes(this.currentNode);
                if (nextNodeIDs.length == 0)
                {
                    trace("THE END!");
                    return;
                }
                trace("skip answer to next node "+nextNodeIDs[0]);
                this.currentNode = nextNodeIDs[0];
            }
        }
        var node:VerbalNode = data.getNode(this.currentNode);

        // process node
        this.currentAction++;
        trace("processing action "+this.currentAction);
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

    public function onAnswerSelected(index:Int) : Void
    {
        onContinue(index);
    }

    private function getNextNodes(nodeID:Int):Array<Int>
    {
        var nodes:Array<Int> = [];
        var node:VerbalNode = data.getNode(nodeID);

        if (node.links != null)
        {
            for (link in node.links)
            {
                // TODO test conds, handle groups
                nodes.push(link);
            }
        }

        return nodes;
    }

}
