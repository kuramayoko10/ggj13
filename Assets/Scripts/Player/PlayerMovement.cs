using UnityEngine;
using System.Collections;

public class PlayerMovement : MonoBehaviour 
{
	private CharacterMotor motor;
	private PlatformInputController pic;
	private float boost;
	
	public float tempDelta;
	
	// Use this for initialization
	void Start () 
	{
		motor = gameObject.GetComponent<CharacterMotor>();
		pic = gameObject.GetComponent<PlatformInputController>();
		boost = 1.0f;
	}
	
	// Update is called once per frame
	void Update () 
	{
		if(pic.directionVector.x != 0)
		{
			boost += 0.5f;
		}
		else if(boost > 1.0f)
		{
			boost -= 2f;	
		}
		
		if(boost <= 1.0)
			boost = 1.0f;
		
		getDelta();
	}
	
	public float getDelta()
	{
		tempDelta = 1.0f/boost;
		return 1.0f/boost;
	}
}
