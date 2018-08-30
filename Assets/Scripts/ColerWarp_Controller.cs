using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ColerWarp_Controller : MonoBehaviour
{

    Material mat;

    float duration = 0.2f;

    float timer;

    int currentState;
    int lastState;

    string stateName = "state";



    void Start()
    {
        lastState = 0;
        currentState = 1;

        mat = GetComponent<Renderer>().material;
        StartCoroutine(ChangeState());
    }

    IEnumerator ChangeState()
    {
        while (true)
        {
            timer = 0f;

            while (timer < duration)
            {
                timer += Time.deltaTime;

                float percentage = timer / duration;

                mat.SetFloat(stateName + currentState.ToString(), percentage);
                mat.SetFloat(stateName + lastState.ToString(), 1 - percentage);
                yield return null;
            }

            mat.SetFloat(stateName + lastState.ToString(), 0f);

            lastState = currentState;
            currentState++;
            if (currentState > 2) { currentState = 0; }

            yield return null;
        }
    }
}
