using UnityEngine;
using System.Collections;

public class PlayerMovement : MonoBehaviour 
{
	private CharacterMotor motor;
	private PlatformInputController pic;
	private float boost = 3.0f;
	
	public float tempDelta;
	
	// Use this for initialization
	void Start () 
	{
		motor = gameObject.GetComponent<CharacterMotor>();
		pic = gameObject.GetComponent<PlatformInputController>();
		boost = 3.0f;
	}
	
	// Update is called once per frame
	void Update () 
	{
		if(pic.directionVector.x != 0)
		{
			boost -= 0.4f*Time.deltaTime;
		}
		else if(boost < 3.0f)
		{
			boost += 0.4f*Time.deltaTime;	
		}
		
		if(boost <= 1.0f)
			boost = 1.0f;
		if(boost >= 3.0f)
			boost = 3.0f;
		
		getDelta();
	}
	
	public float getDelta()
	{
		//tempDelta = 1.0f/boost;
		tempDelta = boost;
		return boost;
	}
}
