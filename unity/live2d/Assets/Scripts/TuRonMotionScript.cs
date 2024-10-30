using FlutterUnityIntegration;
using UnityEngine;

public class KoharuMotionScript : MonoBehaviour
{
    private UnityMessageManager unityMessageManager; // UnityのAnimatorを使用
    void Start()
    {

        unityMessageManager = GetComponent<UnityMessageManager>();
    }

    void Update() {
        unityMessageManager.SendMessageToFlutter("");
    }

}
