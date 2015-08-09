package verbal;

import verbal.VerbalData;

class VerbalIntFic
{

	private var data : VerbalData = null;
	private var currentNode:Int = -1;

	private var testConditionCallback:String -> Bool;
	private var runActionCallback:String -> Void;

	public function new(
		data:VerbalData,
		testConditionCallback:String -> Bool,
		runActionCallback:String -> Void
	) : Void
	{
		this.data = data;
		this.testConditionCallback = testConditionCallback;
		this.runActionCallback = runActionCallback;
	}

	public function step():Void
	{
		var nextNode:VerbalNode = getNextNode(this.currentNode,false);
    	if (nextNode == null)
    	{
    		nextNode = getNextGlobalNode();
    	}
    	if (nextNode != null)
    	{
			enterNode(nextNode);
		}
	}

	private function enterNode(node:VerbalNode) : Void
	{
		trace("next node "+node.id);
		this.currentNode = node.id;
		if (node.actions != null)
		{
			for (action in node.actions)
			{
				runAction(action);
			}
		}
	}

	private function getNextGlobalNode():VerbalNode
	{
	    var nextNode:VerbalNode = null;
		for (globalNode in this.data.getGlobalNodes())
		{
			nextNode = getNextNode(globalNode.id, true);
			if (nextNode != null)
			{
				break;
			}
		}
		return nextNode;
	}

	private function getNextNode(id:Int,testConds:Bool):VerbalNode
	{
    	var nextNode:VerbalNode = null;
		if (id == -1)
		{
			nextNode = getNextNode(0,true);
			if (nextNode != null)
			{
				return nextNode;
			}
		} else
		{
			var node:VerbalNode = this.data.getNode(id);
			if (node == null)
			{
				return null;
			}
			if (!testConds || canEnterNode(node))
			{
				if (testConds && !node.group)
				{
					return node;
				}

		    	if ( node.links != null )
		    	{
		    		for (linkID in node.links)
		    		{
		    			nextNode = getNextNode(linkID,true);
		    			if ( nextNode != null )
		    			{
		    				return nextNode;
		    			}
		    		}
		    	}
			}
		}

		return null;
	}

	private function canEnterNode(node:VerbalNode):Bool
	{
		if (node.conds != null)
		{
			for (cond in node.conds)
			{
				if (!testCondition(cond))
				{
					return false;
				}
			}
		}
		return true;
	}

 	// override this method to add custom code testing etc.
	private function testCondition(cond:String) : Bool
	{
		if (this.testConditionCallback != null)
		{
			return this.testConditionCallback(cond);
		}
		return true;
	}

	// override this method to add custom code testing etc.
	private function runAction(action:String) : Void
	{
		trace("ACTION: "+action);
		if (this.runActionCallback != null)
		{
			this.runActionCallback(action);
		}
	}
}
