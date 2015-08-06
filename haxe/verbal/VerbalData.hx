package verbal;

class VerbalData
{

    public static function loadFromJSON(json:String):VerbalData
    {
        var nodeList:Array<VerbalNode> = haxe.Json.parse( json );
        return new VerbalData( nodeList );
    }

    private var data : Array<VerbalNode>;
    private var nodeMap : Map<Int,VerbalNode>;
    private var globalNodes : Array<VerbalNode>;

    public function new( data:Array<VerbalNode> ) : Void
    {
        this.data = data;
        this.nodeMap = new Map<Int,VerbalNode>();
        this.globalNodes = [];
        trace("new data with nodes "+data.length);
        for (n in data)
		{
            this.nodeMap[n.id] = n;
            if (n.global)
            {
                this.globalNodes.push(n);
            }
		}
    }

    public function getNode(id:Int) : VerbalNode
    {
        return this.nodeMap[id];
    }

    public function getGlobalNodes() : Array<VerbalNode>
    {
        return this.globalNodes;
    }

}
