using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScannerController : MonoBehaviour
{
    [SerializeField]
    ScannerSetting defaultSetting;
    [SerializeField]
    ScannerSetting activatedSetting;

    [SerializeField]
    AnimationCurve pulse;

    [SerializeField]
    float activeDuration = 10f;

    public ScannerSetting output = new ScannerSetting();

    Material mat;

    WaitForEndOfFrame wait = new WaitForEndOfFrame();

    float changeTime = 3f;
    float maxScan = 0.5f;

    enum Activation { Activating, Activated, Deactivated };
    Activation state;

    void Start()
    {
        mat = GetComponent<Renderer>().material;
        output.Reset();
        defaultSetting.Blend(output, 1);
        mat.SetFloat("_ScannerStrength", 0f);
        output.Apply(mat);

        state = Activation.Deactivated;
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space) && state == Activation.Deactivated)
        {
            StartCoroutine(ActivateScanner());
        }
    }

    IEnumerator ActivateScanner()
    {
        state = Activation.Activating;

        float timer = 0f;
        float percentage = 0f;

        while (percentage < 1f)
        {
            timer += Time.deltaTime;

            output.Reset();
            defaultSetting.Blend(output, 1 - percentage);
            activatedSetting.Blend(output, percentage);

            output.Apply(mat);

            mat.SetFloat("_ScannerStrength", maxScan * percentage);

            percentage = timer / changeTime;
            yield return wait;
        }

        StartCoroutine(StayActive());
    }

    IEnumerator StayActive()
    {
        state = Activation.Activated;

        float timer = 0f;
        float percentage = 0f;

        while (percentage < 1f)
        {
            timer += Time.deltaTime;

            float pulsePercentage = pulse.Evaluate(percentage);

            output.Reset();
            defaultSetting.Blend(output, 1 - pulsePercentage);
            activatedSetting.Blend(output, pulsePercentage);

            output.Apply(mat);

            mat.SetFloat("_ScannerStrength", maxScan * pulsePercentage);

            percentage = timer / activeDuration;
            yield return wait;
        }
        state = Activation.Deactivated;
    }
}

[System.Serializable]
public class ScannerSetting
{
    public Color DiffuseCol = Color.white;
    public Color DifDetailCol = Color.white;
    public Color RimCol = Color.white;
    public float RimStrength;
    public float RimPow;

    float[] floats = new float[4];

    public void Reset()
    {

        DiffuseCol = Vector4.zero;
        DifDetailCol = Vector4.zero;
        RimCol = Vector4.zero;
        RimStrength = 0f;
        RimPow = 0f;
    }

    public void Blend(ScannerSetting output, float percentage)
    {
        output.DiffuseCol += DiffuseCol * percentage;
        output.DifDetailCol += DifDetailCol * percentage;
        output.RimCol += RimCol * percentage;
        output.RimStrength += RimStrength * percentage;
        output.RimPow += RimPow * percentage;
    }

    public void Apply(Material m)
    {
        SetFloats(DiffuseCol);
        //m.SetFloatArray("_DiffuseCol", floats);
        m.SetFloatArray("DiffuseArray", floats);

        SetFloats(DifDetailCol);
        m.SetFloatArray("difDetailCol", floats);

        SetFloats(RimCol);
        m.SetFloatArray("rimCol", floats);

        m.SetFloat("_RimStrength", RimStrength);
        m.SetFloat("_RimPow", RimPow);

    }

    void SetFloats(Color c)
    {
        floats[0] = c.r;
        floats[1] = c.g;
        floats[2] = c.b;
        floats[3] = c.a;
    }

}

