package verbal;

class VerbalTree
{
    private var data : VerbalData = null;
	private var currentNode:Int = -1;
	private var input:String = "";
    private var onShowNodeCallback: String->Array<String>->Void;

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
        this.onShowNodeCallback("HEY!",["AAA","BBB","CCC"]);
    }

    public function onContinue() : Void
    {

    }

    public function onAnswerSelected(index:Int) : Void
    {

    }

    /*public function getNextNodes(startNodeID:Int):Array<VerbalNode>
    {

    }*/

}
