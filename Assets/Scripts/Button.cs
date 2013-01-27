using UnityEngine;
using System.Collections;

public class Button : MonoBehaviour {
	
	public string LevelName;
	public bool isQuit = false;
	
	void OnMouseEnter()
	{
		
		foreach (Transform child in transform)
		{
		    child.renderer.material.color = Color.white;
		}
	}
	
	void OnMouseExit()
	{
		foreach (Transform child in transform)
		{
		    child.renderer.material.color = Color.black;
		}
	}
	
	void OnMouseUp()
	{
		if(isQuit)
			Application.Quit();
		else
			Application.LoadLevel(LevelName);
	}
}
