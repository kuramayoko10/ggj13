using UnityEngine;
using System.Collections;

 

// PlaySoundAtInterval.cs
// Copyright (c) 2010-2011 Sigma-Tau Productions (http://www.sigmatauproductions.com/).
// This script is free to be used in both free and commercial projects as long as this
// notice is retained.

 

[RequireComponent (typeof (Animation))]

public class BlockMovement : MonoBehaviour {
	private float trackedTime;
    // A modifier that will prevent the script from running in the event of an error

    private bool disableScript = false;    

    // Use this for initialization
	//public GameObject defaultPlayer = null;
	HeartBeat defaultBeat = null;
    void Start () {
		
		defaultBeat = (HeartBeat) GameObject.Find("Player").GetComponent("HeartBeat");
		initialPosition = transform.position;	
		target += transform.position;
	}

	public Vector3 target;
	Vector3 initialPosition;
	public bool ReturnInitPosition = true;
	bool state = false, invert = false;
	float tempoPrimeiraBatida = 0.0f;

    // Update is called once per frame

    void Update () {

        if (!disableScript) {
			
			if(defaultBeat.isStateBeating()){
				if (defaultBeat.trackedTime >= tempoPrimeiraBatida) {					
					if(ReturnInitPosition && state == true)
						goBack(defaultBeat.trackedTime - tempoPrimeiraBatida);
					else
						Move (defaultBeat.trackedTime - tempoPrimeiraBatida);
			        invert = true;
				}
			} else if(invert){
				state = !state;
				invert = false;
			}
        }

    }
	
	void Move(float time)
	{
		transform.position = Vector3.Lerp(transform.position, target, time/(defaultBeat.audioTime - tempoPrimeiraBatida));
	}
	
	void goBack(float time)
	{
		transform.position = Vector3.Lerp(transform.position, initialPosition, time/(defaultBeat.audioTime - tempoPrimeiraBatida));
	}
}