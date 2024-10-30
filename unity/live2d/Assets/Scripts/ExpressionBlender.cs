using UnityEngine;
using Live2D.Cubism.Core;
using Live2D.Cubism.Framework;
using System.Collections.Generic;

public class Live2DExpressionBlender : MonoBehaviour
{
    public CubismModel cubismModel; // Live2D 模型

    void Start()
    {


        Dictionary<string, float> expressionWeights = new Dictionary<string, float>
        { { "bianzi",1.0f},{"ear",1.0f} };

        Debug.Log("成功");
        if (cubismModel == null)
        {
            cubismModel = GetComponent<CubismModel>();
        }

        if (cubismModel == null)
        {
            Debug.LogError("未找到 Live2D 模型");
            return;
        }


        
    }

}