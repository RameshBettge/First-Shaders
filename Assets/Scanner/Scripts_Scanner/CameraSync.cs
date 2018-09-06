using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraSync : MonoBehaviour
{
    [SerializeField]
    Transform secondCam;

    [SerializeField]
    float speed = 1f;

    Vector3 offset = Vector3.right * 1000f;

    void Start()
    {
        //offset -= transform.position;
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
