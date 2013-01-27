using UnityEngine;
using System.Collections;

public class NextLevel : MonoBehaviour {
	public string SceneName;
	void OnTriggerEnter(Collider objectCollider){
		if(objectCollider.CompareTag("Player"))
		{
			Application.LoadLevel(SceneName);
		}
	}
}
