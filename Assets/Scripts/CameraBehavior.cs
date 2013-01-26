using UnityEngine;
using System.Collections;

public class CameraBehavior : MonoBehaviour 
{
	Camera camera;
	PlayerMovement mov;
	
	public float leftBoundary;
	public float rightBoundary;
	
	GameObject playerObject;
	CharacterMotor motor;
	PlatformInputController pic;
	
	// Use this for initialization
	void Start () 
	{
		leftBoundary = 0f;
		rightBoundary = 15f;
		
		playerObject = GameObject.Find("Player");
		motor = playerObject.GetComponent<CharacterMotor>();
		pic = playerObject.GetComponent<PlatformInputController>();
	}
	
	// Update is called once per frame
	void Update () 
	{
		/*Vector3 movementOffset = motor.GetMovementOffset();
		
		if( (transform.position.x <= leftBoundary && pic.directionVector.x < 0)
			|| (transform.position.x >= rightBoundary && pic.directionVector.x > 0) )
		{
			transform.Translate(-movementOffset.x, 0, 0);
		}*/
		
		
	}
}
