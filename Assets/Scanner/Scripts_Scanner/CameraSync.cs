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
        offset -= transform.position;
    }

    void LateUpdate()
    {
        float h = Input.GetAxis("Horizontal");
        if (h != 0f)
        {
            transform.Rotate(Vector3.up * h);
        }
        else
        {
            transform.Rotate(-Vector3.right * Input.GetAxis("Vertical"));
        }

        secondCam.position = transform.position + offset;
        secondCam.rotation = transform.rotation;
    }
}
