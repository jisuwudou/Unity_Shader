using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Main : MonoBehaviour {
	public Material ExposionMat;
	private bool isClicked;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
		if (this.isClicked == false) {

		
			if (Input.GetMouseButton (0)) {
			
				Ray ray = Camera.main.ScreenPointToRay (Input.mousePosition);
				RaycastHit hit;
				if (Physics.Raycast (ray, out hit)) {
					MeshRenderer[] renderers = hit.collider.GetComponentsInChildren<MeshRenderer> ();
					this.ExposionMat.SetFloat ("_StartTime", Time.timeSinceLevelLoad);
					for (int i = 0; i < renderers.Length; i++) {
						renderers [i].material = ExposionMat;
					}
					this.isClicked = true;
				}
			} else {
				//this.isClicked = false;
				this.ExposionMat.SetFloat ("_StartTime", Time.timeSinceLevelLoad);
			}
		}
	}
}
