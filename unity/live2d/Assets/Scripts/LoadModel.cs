using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Live2D.Cubism.Framework.Json;
using Live2D.Cubism.Core;

public class LoadModel : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        string path = Application.dataPath + "/Live2D/MyModels/兔绒Free/兔绒free.model3.json";
        //CubismModel3Json.LoadAtPath(path,InitModel);
    }

}
