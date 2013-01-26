using UnityEngine;
using System.Collections;

public class CameraBehavior : MonoBehaviour 
{
	Camera camera;
	PlayerMovement mov;
	
	public float leftBoundary;
	public float rightBoundary;
	
	// Use this for initialization
	void Start () 
	{
		leftBoundary = 0f;
		rightBoundary = 15f;
	}
	
	// Update is called once per frame
	void Update () 
	{
		//Transform
	}
}
