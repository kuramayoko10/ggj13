using UnityEngine;
using System.Collections;

public class PlayerMovement : MonoBehaviour 
{
	private CharacterMotor motor;
	private PlatformInputController pic;
	private float boost = 3.0f;
	private float sign = 1f;
	
	public Light pointLight1, pointLight2;
	
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
			
			sign = 1f;
		}
		else if(boost < 3.0f)
		{
			boost += 0.4f*Time.deltaTime;
			
			sign = -1.8f;
		}
		
		if(boost <= 1.0f)
			boost = 1.0f;
		else if(boost >= 3.0f)
			boost = 3.0f;
		else //Adjust the brightness
		{
			pointLight1.range += sign*boost*0.008f;
			pointLight2.range += sign*boost*0.008f;
			pointLight1.intensity -= sign*boost*0.001f;
			//pointLight2.intensity -= sign*boost*0.0009f;
			
			if(pointLight1.range <= 4)
			{
				pointLight1.range = 4;
				pointLight2.range = 5;
			}
		}
		
		if(pointLight1.intensity <= 1.1f)
		{
			pointLight1.intensity = 1.1f;	
			//pointLight2.intensity = 1.1f;
		}
		else if(pointLight1.intensity >= 4f)
		{
			pointLight1.intensity = 4f;
			//pointLight2.intensity = 1.5f;
		}
		
		getDelta();	
	}
	
	public float getDelta()
	{
		//tempDelta = 1.0f/boost;
		tempDelta = boost;
		return boost;
	}
}
