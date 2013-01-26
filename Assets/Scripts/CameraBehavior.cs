using UnityEngine;
using System.Collections;

public class CameraBehavior : MonoBehaviour 
{
	Camera camera;
	PlayerMovement mov;
	Light pointLight;
	float[] distances;
	
	// Use this for initialization
	void Start () 
	{
		distances = new float[32];
		distances[8] = 15.5f;
		distances[9] = 100;
		
		camera = gameObject.GetComponent<Camera>();
		camera.layerCullDistances = distances;
		
		camera.layerCullSpherical = true;
		
		//Only show what is lit
		//pointLight = camera.GetComponentInChildren<Light>();
		//pointLight.cullingMask = (1 << 8);
		
		camera.cullingMask = (1 << 0) | (1 << 9) | (1 << 8);
		//camera.cullingMask |= pointLight.cullingMask;
		
		mov = transform.parent.GetComponent<PlayerMovement>();
	}
	
	// Update is called once per frame
	void Update () 
	{
		distances[8] = 15.5f + (1.0f/mov.getDelta())/50f;
		camera.layerCullDistances = distances;
	}
}
