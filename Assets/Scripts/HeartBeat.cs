using UnityEngine;
using System.Collections;

 

// PlaySoundAtInterval.cs
// Copyright (c) 2010-2011 Sigma-Tau Productions (http://www.sigmatauproductions.com/).
// This script is free to be used in both free and commercial projects as long as this
// notice is retained.

 

[RequireComponent (typeof (AudioSource))]

public class HeartBeat : MonoBehaviour {


    // The interval of time (in seconds) that the sound will be played.

    PlayerMovement player;
		
	public float interval;

    // The sound itself.

    public AudioClip clipToPlay;

    

    // Private variables

    // A modifier that will prevent the script from running in the event of an error

    private bool disableScript = false;

    

    // The amount of time that has passed since the last initial playback of the sound.
	public float audioTime = 1.097f;
    public float trackedTime = 0.0f;

    

    // Tracks to see if we've played this at startup.

    private bool playedAtStartup = false, beat = false;
	
	private bool stateBeating = false;
    

    // Use this for initialization

    void Start () {

		player = GetComponent<PlayerMovement>();
		interval = player.getDelta();
        
		if (interval < 1.0f) { // Make sure the interval isn't 0, or we'll be constantly playing the sound!

            Debug.LogError("Interval base must be at least 1.0!");

            disableScript = true;

        }

    }

    

    // Update is called once per frame

    void Update () {

        if (!disableScript) {
            trackedTime += Time.deltaTime;

            // Check to see that the proper amount of time has passed
            if (!stateBeating && trackedTime >= interval) {
				startBeat ();                                		
            } else if(stateBeating && trackedTime >= audioTime){
				stopBeat();
			}

        }

    }
	void startBeat(){
		// Play the sound, reset the timer
        audio.PlayOneShot(clipToPlay);
		trackedTime -= interval;
		stateBeating = true;
		trackedTime = 0.0f;

	}
	void stopBeat(){
		player = GetComponent<PlayerMovement>();
		interval = player.getDelta();
		stateBeating = false;
		trackedTime = 0.0f;
	}
	public float getTrackTime(){
		return trackedTime;
	}
	public bool isStateBeating(){
		return stateBeating;
	}

}
