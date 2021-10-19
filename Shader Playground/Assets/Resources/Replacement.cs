using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Replacement : MonoBehaviour
{
    public Shader replace;
    public string shaderTag;
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
            Camera.main.SetReplacementShader(replace,shaderTag);
    }
}
