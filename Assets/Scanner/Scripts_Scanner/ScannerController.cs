using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScannerController : MonoBehaviour
{
    Material mat;

  //  _ScannerStrength("PortalStrength", Range(0, 0.4)) = 0.2 


		//_DiffuseCol("Main Color", Color) = (1, 1, 1, 1)

		//_DifDetailCol("Detail Color", Color) = (1, 1, 1, 1)

		//[Header(Rim)]
  //  _RimCol("Color", Color) = (1, 1, 1, 1)
		//_RimStrength("Strength", Range(0, 1)) = 0.3
		//_RimPow("Power", Range(0.01, 1.5)) = 1

    void Start()
    {

    }

    void Update()
    {

    }
}

public struct ScannerSetting
{
    public Vector4 DiffuseCol;
    public Vector4 DifDetailCol;
    public Vector4 RimCol;
    public float RinStrength;
    public float RimPow;
}
