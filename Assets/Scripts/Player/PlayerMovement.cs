using UnityEngine;
using System.Collections;

public class PlayerMovement : MonoBehaviour 
{
	private CharacterMotor motor;
	private PlatformInputController pic;
	private HeartBeat heart;
	
	private float boost = 1.0f;
	private float sign = 1f;
	
	public Light pointLight2, pointLight1;
	
	public float tempDelta;
	private float timeElapsed = 0f;
	
	// Use this for initialization
	void Start () 
	{
		motor = gameObject.GetComponent<CharacterMotor>();
		pic = gameObject.GetComponent<PlatformInputController>();
		heart = GameObject.Find ("Player").GetComponent<HeartBeat>();
		
		GameObject.Find("Spawn Particles").GetComponent<ParticleSystem>().Play(true);
		
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
			
			sign = -2f;
		}
		
		if(boost <= 1.0f)
			boost = 1.0f;
		else if(boost >= 3.0f)
			boost = 3.0f;
		else //Adjust the brightness
		{
			pointLight2.range += sign*boost*0.06f;
			pointLight2.intensity += sign*boost*0.02f;
			
			if(pointLight2.range <= 8)
			{
				pointLight2.range = 8;
			}
			
			if(pointLight2.intensity <= 0.6f)
			{
				pointLight2.intensity = 0.6f;
			}
			if(pointLight2.intensity >= 1.1f)
			{
				pointLight2.intensity = 1.1f;
			}
		}	}
	
	public float getDelta()
	{
		//tempDelta = 1.0f/boost;
		tempDelta = boost;
		return boost;
	}
	
	void OnTriggerEnter(Collider objectCollider)
	{
			
	}
}
