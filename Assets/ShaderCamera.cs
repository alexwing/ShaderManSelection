using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ShaderCamera : MonoBehaviour
{

    public float intensity;
    public Material material;
    

    // Creates a private material used to the effect
    void Awake()
    {
      //  material = new Material(Shader.Find("Hidden/BWDiffuse"));
    }

    // Postprocess the image
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material)
        {
            if (intensity == 0)
            {
                Graphics.Blit(source, destination);
                return;
            }

            material.SetFloat("_bwBlend", intensity);
            Graphics.Blit(source, destination, material);
        }
        else {
            Graphics.Blit(source, destination);
            return;
        }
      
    }
}