using Live2D.Cubism.Core;
using Live2D.Cubism.Framework.Expression;
using Live2D.Cubism.Framework.Json;
using UnityEngine;

public class ExpressionLayer : MonoBehaviour
{


    private CubismModel model;
    public CubismExpressionData[] expressionData; // 拖放多个CubismExtensionData
    public float[] expressionSwitch; // 开关

    
    private void Start()
    {
        model= GetComponent<CubismModel>();
    }

    void Update()
    {
        // 遍历每个表情数据，设置其权重
        for (int i = 0; i < expressionData.Length; i++)
        {
            if (i < expressionSwitch.Length)
            {
                // 假设每个CubismExtensionData有一个表情参数
                string parameterId = expressionData[i].name.Replace(".exp3", "") ; // 假设你有一个ParameterId属性
                model.Parameters.FindById(parameterId).Value = Mathf.Clamp(expressionSwitch[i], 0, 1);
            }
        }
    }
}
