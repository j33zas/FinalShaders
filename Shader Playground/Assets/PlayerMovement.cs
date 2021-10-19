using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    Vector2 direction;
    public float acceleration;
    public float deacceleration;
    float currentSpeed;
    public float maxSpeed;
    void Start()
    {
        
    }

    void Update()
    {
        direction = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
        direction.Normalize();
        if (direction != Vector2.zero)
        {
            currentSpeed += Time.deltaTime * acceleration;
            if (currentSpeed >= maxSpeed)
                currentSpeed = maxSpeed;
        }
        else
        {
            currentSpeed -= Time.deltaTime * deacceleration;
            if (currentSpeed <= 0)
                currentSpeed = 0;
        }
        transform.right += new Vector3(direction.x, direction.y, 0) * Time.deltaTime * currentSpeed;

    }
}
