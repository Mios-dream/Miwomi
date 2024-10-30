using UnityEngine;
using UnityEngine.Networking;
using System.Collections;

public class AudioPlayer : MonoBehaviour
{
    public string audioUrl = "http://10.203.15.9:23456/voice/bert-vits2?text=你好，我是星瞳，这是一个语音测试&id=0"; // 替换为实际的音频URL
    private AudioSource audioSource;

    void Start()
    {
        audioSource = gameObject.AddComponent<AudioSource>();
        LoadAndPlayAudio();
    }

    void LoadAndPlayAudio()
    {
        UnityWebRequest request = UnityWebRequestMultimedia.GetAudioClip(audioUrl, AudioType.WAV);
        StartCoroutine(DownloadAndPlay(request));
    }

    IEnumerator DownloadAndPlay(UnityWebRequest request)
    {
        yield return request.SendWebRequest();

        if (request.result == UnityWebRequest.Result.ConnectionError || request.result == UnityWebRequest.Result.ProtocolError)
        {
            Debug.LogError(request.error);
        }
        else
        {
            AudioClip clip = DownloadHandlerAudioClip.GetContent(request);
            audioSource.clip = clip;
            audioSource.Play();
        }
    }
}