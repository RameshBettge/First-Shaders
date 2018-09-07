using UnityEngine;

public class CameraSync : MonoBehaviour
{
    [SerializeField]
    Transform secondCam;

    [SerializeField]
    Transform renderPlane;

    [SerializeField]
    float speed = 1f;


    Vector3 offset = Vector3.right * 1000f;

    void Start()
    {
        SetRenderPlane();
    }

    private void SetRenderPlane()
    {
        Camera cam = GetComponent<Camera>();
        float farPlaneDistance = cam.farClipPlane;
        float halfHeight = Mathf.Tan((cam.fieldOfView/2f) * Mathf.Deg2Rad) * cam.farClipPlane;
        float halfWidth = halfHeight * cam.aspect;

        renderPlane.localPosition = Vector3.forward * farPlaneDistance;
        renderPlane.localScale = new Vector3(halfWidth * 2, halfHeight * 2, 1);
    }

    void LateUpdate()
    {
            //transform.Rotate(Vector3.up * Input.GetAxisRaw("Horizontal"));
            transform.eulerAngles += Vector3.up * Input.GetAxisRaw("Horizontal");
            //transform.Rotate(-Vector3.right * Input.GetAxisRaw("Vertical"));
            transform.eulerAngles += -Vector3.right * Input.GetAxisRaw("Vertical");

        secondCam.position = transform.position + offset;
        secondCam.rotation = transform.rotation;
    }
}
