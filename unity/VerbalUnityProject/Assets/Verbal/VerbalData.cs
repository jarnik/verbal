using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LitJson;

public class VerbalData
{

    public static VerbalData loadFromJSON(string json)
    {
        VerbalNode[] nodeList = JsonMapper.ToObject<VerbalNode[]>(json);
        return new VerbalData( nodeList );
    }

    private VerbalNode[] data;
    private Dictionary<int,VerbalNode> nodeMap;
    private VerbalNode[] globalNodes;

    public VerbalData( VerbalNode[] data )
    {
        this.data = data;
        this.nodeMap = new Dictionary<int,VerbalNode>();
        List<VerbalNode> globalNodesList = new List<VerbalNode>();
        foreach (VerbalNode n in data)
		{
            this.nodeMap.Add(n.id, n);
            if (n.global)
            {
                globalNodesList.Add(n);
            }
		}
        this.globalNodes = globalNodesList.ToArray();
    }

    public VerbalNode getNode(int id)
    {
        if (this.nodeMap.ContainsKey(id))
        {
            return this.nodeMap[id];
        }

        return null;
    }

    public VerbalNode[] getGlobalNodes()
    {
        return this.globalNodes;
    }


}
