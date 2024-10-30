using UnityEngine;
using Live2D.Cubism.Framework.Raycasting;
using System.Collections.Generic;
using Live2D.Cubism.Framework.Motion;
using System.Collections;
using FlutterUnityIntegration;
using System.Data;
using System;
using Newtonsoft.Json;
using UnityEditor;




public class ClickableObject : MonoBehaviour
{
    private CubismMotionController cubismMotionController;
    private UnityMessageManager unityMessageManager; // UnityのAnimatorを使用
    private bool isPlaying = false;

    private string animationClipPath = "MyModels/兔绒DLC/Animation/待机1";

    void Start()
    {
        cubismMotionController = GetComponent<CubismMotionController>();
        unityMessageManager = GetComponent<UnityMessageManager>();

        
        defaultMotinion(animationClipPath);
       

    }

    private void Update()
    {
        if (!Input.GetMouseButtonDown(0))
        {
            return;
        }

        CubismRaycaster raycaster = GetComponent<CubismRaycaster>();
        List<string> widgetName=new List<string>();

        CubismRaycastHit[] cubismRaycastHits=new CubismRaycastHit[4];
        Ray ray=Camera.main.ScreenPointToRay(Input.mousePosition);
        int hitCount=raycaster.Raycast(ray,cubismRaycastHits);
        string resultTest=hitCount.ToString();
        for (int i = 0; i < hitCount; i++)
        {
            resultTest += cubismRaycastHits[i].Drawable.name;
            widgetName.Add(cubismRaycastHits[i].Drawable.name);
            
        }
        //Debug.Log(resultTest);
        Debug.Log(string.Join(", ", widgetName));
        ClickMotion(widgetName);
    }

    private void ClickMotion(List<string> drawableNames) {
        foreach (string drawableName in drawableNames) {
            if (drawableName == "face") {
                string text = "你好，我是星瞳，这是一个语音测试。";
                string animationClipPath = "MyModels/兔绒DLC/Animation/待机";
                string audioPath = "MyModels/AudioSource/test";
                TriggerAnimationAndAudio(drawableName, text,animationClipPath, audioPath);
            }
        }
    }

    private void defaultMotinion(string animationClipPath)
    {
        AnimationClip animationClip = Resources.Load<AnimationClip>(animationClipPath);
        PlayingMotion(animationClip, true);
        Debug.Log("待机动画播");
    }

    private void TriggerAnimationAndAudio(string touchArea,string text,string animationClipPath, string audioPath)
    {
        if (isPlaying)
        {
            return;
        }

        if (string.IsNullOrEmpty(animationClipPath))
        {
            Debug.Log("动画文件路径为空");
            isPlaying = false;
            return;
        }


        if (string.IsNullOrEmpty(audioPath))
        {
            Debug.Log("音频文件路径为空");
            isPlaying = false;
            return;
        }

        AnimationClip animationClip = Resources.Load<AnimationClip>(animationClipPath);
        AudioClip audioClip = Resources.Load<AudioClip>(audioPath);

        var motionInfo = new Dictionary<string, dynamic>
        {
            { "type", "animeton" },
            {"text", text },
            { "animation", animationClip.name },
            { "touchArea", touchArea },
            { "duration", Math.Max(animationClip.length, audioClip.length) }
        };

        unityMessageManager.SendMessageToFlutter(JsonConvert.SerializeObject(motionInfo));
        StartCoroutine(PlayAnimation(animationClip, audioClip));
    }

    private IEnumerator PlayAnimation(AnimationClip animation, AudioClip audio) {

        isPlaying = true;


        PlayingMotion(animation);
        PlaySound(audio);

        // 等待动画播放完毕
        yield return new WaitForSeconds(animation.length);

        // 等待音频播放完毕
        yield return new WaitForSeconds(audio.length);

        defaultMotinion(animationClipPath);

        // 等待3秒
        yield return new WaitForSeconds(2.0f);

        isPlaying = false;
    }


    private void PlayingMotion(AnimationClip animation, bool isLoop = false)
    {
        
        if (cubismMotionController == null)
        {
            Debug.Log("动画控制器为空");
            return;
        }
        int priority=2;
        if (isLoop) {
            priority = 1;
        }
        cubismMotionController.StopAllAnimation();
        cubismMotionController.PlayAnimation(animation, isLoop: isLoop,priority:priority);
        
    }

    private void PlaySound(AudioClip audio)
    {
        AudioSource audioSource = GetComponent<AudioSource>();
        //AudioSource audioSource=null;
        audioSource.clip = audio;

        if (audioSource == null)
        {
            Debug.Log("音频文件为空");
            return;
        }
        audioSource.Play();
    }

}
