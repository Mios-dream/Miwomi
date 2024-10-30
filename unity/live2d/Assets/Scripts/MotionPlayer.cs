using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Live2D.Cubism.Framework.Motion;
using Live2D.Cubism.Framework.MotionFade;

public class MotionPlayer : MonoBehaviour
{
    private CubismMotionController cubismMotionController;
    // Start is called before the first frame update
    void Start()
    {
        cubismMotionController = GetComponent<CubismMotionController>();
        
    }

    public void PlayingMotion(AnimationClip animationClip)
    {
        if (animationClip ==null)
        {
            Debug.Log("动画为空");
            return;
        }
        if (cubismMotionController == null) {
            Debug.Log("动画控制器为空");
            return;
        }
        cubismMotionController.PlayAnimation(animationClip,isLoop:false);

    }
}
