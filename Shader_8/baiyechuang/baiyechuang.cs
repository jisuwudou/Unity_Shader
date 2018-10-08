using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class baiyechuang : MonoBehaviour {

	// Use this for initialization
	Material mat;
	MeshRenderer meshRen;
	void Start () {
		meshRen = this.GetComponent<MeshRenderer> ();
		print (meshRen);
		mat = meshRen.material;
		print (mat);
	}

	void OnGUI() {
        if (Input.anyKeyDown)
        {
            Event e = Event.current;
            if (e.isMouse) {
                Debug.Log(e.button);
            }
            if (e.isKey)
            {
                if (e.keyCode == KeyCode.None)
                    return;
                Debug.Log(e.keyCode);
				mat.SetFloat ("_StartTime", Time.timeSinceLevelLoad);
				mat.SetFloat ("_StartFlag", 1);
            }
        }
    }


}
