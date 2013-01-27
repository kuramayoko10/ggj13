using UnityEngine;
using System.Collections;

public class Death : MonoBehaviour
{
	public ParticleSystem deathParticles;
	private MeshRenderer mesh;
	public bool isDead = false;
	public bool alive = true;
	
	void AnimateDeath()
	{
		deathParticles.Play();
		
		mesh = gameObject.GetComponent<MeshRenderer>();
		mesh.enabled = false;
		isDead = true;
	}

	void OnTriggerEnter(Collider objectCollider)
	{
		/*if(objectCollider.CompareTag("Player"))
		{
			Application.LoadLevel(Application.loadedLevel);
		}*/
		
		if(objectCollider.CompareTag("Pith"))
		{
			AnimateDeath();
		}
	}
	
	void Update()
	{
		if(isDead == true && !deathParticles.IsAlive())
			Application.LoadLevel(Application.loadedLevel);
	}
}
