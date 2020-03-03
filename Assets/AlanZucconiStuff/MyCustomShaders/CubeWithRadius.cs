using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
public class CubeWithRadius : MonoBehaviour
{
    public Material RadiusMat;

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        RadiusMat.SetVector("_Center", this.transform.position);
    }
}
