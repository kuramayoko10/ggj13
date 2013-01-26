using UnityEngine;
using System.Collections;

public class Death : MonoBehaviour {

	void OnTriggerEnter(Collider objectCollider){
		if(objectCollider.CompareTag("Player"))
		{
			Application.LoadLevel(Application.loadedLevel);
		}
	}
}
