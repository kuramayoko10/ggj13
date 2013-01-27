using UnityEngine;
using System.Collections;

public class PauseGame : MonoBehaviour {
	
	private bool Active = false;
	
	void Update()
	{
		//Fecha o programa ao apertar o botão Back (ou esc no Windows)
		if (Input.GetKeyDown(KeyCode.Escape)) 
		{
			Active = true;
			Time.timeScale = 0;
		}
	}
	
	void OnGUI () {
		
		//GUI.skin = GuiSkin;
		
		if(Active == true)
		{
			// Make a background box
			GUI.Box(new Rect((Screen.width/2) - 100, (Screen.height/2) - 90, 200, 210), "Pause");
	
			// Make the first button. If it is pressed, Application.Loadlevel (1) will be executed
			if(GUI.Button(new Rect((Screen.width/2) - 80, (Screen.height/2) - 20, 160, 40), "Resume")) {
				Time.timeScale = 1;
				Active = false;
			}

			// Make the second button.
			if(GUI.Button(new Rect((Screen.width/2 - 80), (Screen.height/2) + 30, 160 , 40), "Main Menu")) {
				Time.timeScale = 1;
				Application.LoadLevel("MainMenu");
			}
			
			// Make the second button.
			if(GUI.Button(new Rect((Screen.width/2 - 80), (Screen.height/2) + 80, 160 , 40), "Exit")) {
				Application.Quit();
			}
		}
	}
}
