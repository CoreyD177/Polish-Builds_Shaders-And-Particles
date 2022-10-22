using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Empty : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Component[] g = gameObject.GetComponents(typeof(Component));
        foreach (Component c in g)
        {
            Debug.Log(c.GetType());
        }
        
    }

    // Update is called once per frame
    void Update()
    {
        

    }
}
