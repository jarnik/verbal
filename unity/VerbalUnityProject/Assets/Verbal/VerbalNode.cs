using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class VerbalNode 
{
    public int id;
    public bool group = false;
    public bool global = false;
    public List<string> conds;
    public List<string> actions;
    public List<int> links;
}
