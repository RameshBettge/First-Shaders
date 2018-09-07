using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScannerController : MonoBehaviour
{
    [SerializeField]
    ScannerSetting defaultSetting;
    [SerializeField]
    ScannerSetting activatedSetting;

    ScannerSetting currentSetting;

    Material mat;


    void Start()
    {
        mat = GetComponent<Renderer>().material;
        currentSetting = defaultSetting;
        mat.SetFloat("_ScannerStrength", 0f);
        currentSetting.Apply(mat);
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            currentSetting = activatedSetting;
            currentSetting.Apply(mat);
            mat.SetFloat("_ScannerStrength", 0.25f);
        }
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

    public void Blend(ScannerSetting controller, float percentage)
    {
        controller.DiffuseCol += DiffuseCol;
        controller.DifDetailCol += DifDetailCol;
        controller.RimCol += RimCol;
        controller.RimStrength += RimStrength;
        controller.RimPow += RimPow;
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

