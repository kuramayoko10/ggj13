using UnityEngine;
using System.Collections;

 

// PlaySoundAtInterval.cs
// Copyright (c) 2010-2011 Sigma-Tau Productions (http://www.sigmatauproductions.com/).
// This script is free to be used in both free and commercial projects as long as this
// notice is retained.

 

[RequireComponent (typeof (Animation))]

public class BlockMovement : MonoBehaviour {
  

    // The interval of time (in seconds) that the sound will be played.
		
	float interval;

    // The sound itself.

    // A modifier that will prevent the script from running in the event of an error

    private bool disableScript = false;

    

    // The amount of time that has passed since the last initial playback of the sound.

    private float trackedTime = 0.0f;  

    // Use this for initialization

    void Start () {
		
		GameObject playerInstance = GameObject.Find("Player");
		interval = playerInstance.transform.GetComponent<PlayerMovement>().getDelta();
      
		initialPosition = transform.position;	
		target += transform.position;
		
		if (interval < 1.0f) { // Make sure the interval isn't 0, or we'll be constantly playing the sound!

            Debug.LogError("Interval base must be at least 1.0!");

            disableScript = true;

        }

    }

	public Vector3 target;
	Vector3 initialPosition;
	public bool ReturnInitPosition = false;
	bool state = false;
	float audioTime = 1.097f, tempoPrimeiraBatida = 0.5f;

    // Update is called once per frame

    void Update () {

        if (!disableScript) {

            // Increment the timer

            trackedTime += Time.deltaTime;

            // Check to see that the proper amount of time has passed

            if (trackedTime >= interval + tempoPrimeiraBatida) {
				
				if(ReturnInitPosition && state == true)
					goBack(trackedTime - interval - tempoPrimeiraBatida);
				else
					Move (trackedTime - interval - tempoPrimeiraBatida);
				
				if (trackedTime >= interval + audioTime)
				{
					state = !state;
					trackedTime = 0.0f;
				}
            }

        }

    }
	
	void Move(float time)
	{
		transform.position = Vector3.Lerp(transform.position, target, time);
	}
	
	void goBack(float time)
	{
		transform.position = Vector3.Lerp(transform.position, initialPosition, time);
	}
}