package verbal;

typedef VerbalNode = 
{
    id:Int,
    group:Bool,
    global:Bool,
    conds:Array<String>,
    actions:Array<String>,
    links:Array<Int>
}

class VerbalData
{

    public static function loadFromJSON(json:String):VerbalData
    {
        var nodeList:Array<VerbalNode> = haxe.Json.parse( json );
        return new VerbalData( nodeList );
    }

    public static function loadFromDynamic(json:Array<Dynamic>):VerbalData
    {
        var nodeList:Array<VerbalNode> = [];
        for (d in json)
        {
            nodeList.push(d);
        }
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
