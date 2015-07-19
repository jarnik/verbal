package verbal;

class VerbalIntFic
{

	private var data : VerbalData = null;
	private var currentNode:Int = -1;
	private var input:String = "";

	public function new(data:VerbalData) : Void
	{
		this.data = data;
	}

	public function onInput(input:String):Void
	{
    	this.input = input;
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

	private function getNextNode(id:Int,testInput:Bool):VerbalNode
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
			if (!testInput || canEnterNode(node))
			{
				if (testInput && !node.group)
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
		return (new EReg(cond,"i")).match(this.input);
	}

	// override this method to add custom code testing etc.
	private function runAction(action:String) : Void
	{
		trace("ACTION: "+action);
	}
}
