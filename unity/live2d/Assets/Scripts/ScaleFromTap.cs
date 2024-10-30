using UnityEngine;

public class TwoFingerZoomAndPan : MonoBehaviour
{
    private float initialDistance;
    private Vector3 initialScale;
    private Vector3 initialPosition;
    private Vector2 initialCenter;

    // 添加最小和最大缩放限制
    public float minScale = 2.0f;
    public float maxScale = 15.0f;

    void Update()
    {
        if (Input.touchCount == 2)
        {
            Touch touchZero = Input.GetTouch(0);
            Touch touchOne = Input.GetTouch(1);

            Vector2 center = (touchZero.position + touchOne.position) / 2;

            if (touchZero.phase == TouchPhase.Began || touchOne.phase == TouchPhase.Began)
            {
                initialDistance = Vector2.Distance(touchZero.position, touchOne.position);
                initialScale = transform.localScale;
                initialPosition = transform.position;
                initialCenter = center;
            }
            else if (touchZero.phase == TouchPhase.Moved || touchOne.phase == TouchPhase.Moved)
            {
                float currentDistance = Vector2.Distance(touchZero.position, touchOne.position);
                Vector2 currentCenter = (touchZero.position + touchOne.position) / 2;

                float scaleFactor = currentDistance / initialDistance;

                Vector3 newScale = initialScale * scaleFactor;
                newScale = Vector3.ClampMagnitude(newScale, maxScale); // 限制最大缩放
                newScale = Vector3.Max(newScale, Vector3.one * minScale); // 限制最小缩放

                transform.localScale = newScale;

                Vector2 deltaCenter = currentCenter - initialCenter;
                Vector3 deltaPosition = new Vector3(deltaCenter.x, deltaCenter.y, 0) / 100f; // 调整灵敏度
                transform.position = initialPosition + deltaPosition;
            }
        }
    }
}