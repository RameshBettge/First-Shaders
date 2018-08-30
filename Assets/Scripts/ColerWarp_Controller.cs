using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ColerWarp_Controller : MonoBehaviour
{

    [SerializeField]
    float duration = 1f;

    [Tooltip("If this is true the states will be chosen randomly.")]
    [SerializeField]
    bool irregular;
    Material mat;

    int currentState;
    int lastState;
    int stateCount = 6;

    float timer;

    string stateName = "state";

    [SerializeField]
    [Tooltip("Currently changeable in runtime.")]
    [Range(0f, 1f)]
    float amount;

    void SetAmount()
    {
        mat.SetFloat("_Amount", amount);
    }

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
            SetAmount(); //Is only called constantly so amount can be changed in runtime.

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
            ChooseNextState();

            yield return null;
        }
    }

    void ChooseNextState()
    {
        if (!irregular)
        {
            currentState++;
            if (currentState > stateCount - 1) { currentState = 0; }
            return;
        }

        currentState = Random.Range(0, stateCount);
        if (currentState == lastState)
        {
            ChooseNextState();
        }
    }
}
