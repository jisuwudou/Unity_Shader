using UnityEngine;
using System.Collections;


[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class Grid : MonoBehaviour 
{
    public int xSize, ySize;

    private Vector3[] vertices;

	private IEnumerator  Generate () 
	{
		WaitForSeconds wait = new WaitForSeconds(0.1f);

		Mesh mesh  = new Mesh();
		GetComponent<MeshFilter>().mesh = mesh;
		mesh.name = "mesh name";

	    vertices = new Vector3[(xSize + 1) * (ySize + 1)];
	    Vector2[] uv = new Vector2[vertices.Length];

		Vector4[] tangents = new Vector4[vertices.Length];
		Vector4 tangent = new Vector4(1f, 0f, 0f, -1f);
	    for (int i = 0, y = 0; y <= ySize; y++)
   		{
   		    for (int x = 0; x <= xSize; x++, i++)
   		    {
   		        vertices[i] = new Vector3(x, y);
   		        uv[i] = new Vector2((float)x / xSize , (float)y / ySize);
				tangents [i] = tangent;
   		    }
   		}

   		mesh.vertices = vertices;

   		int[] triangles = new int[6 * xSize*ySize ];//60
   		for(int row = 0 ; row < ySize; row++)
   		{
   			print("-------------------------row= "+row );
   			for(int x = 0,col = 0;x < xSize*6;col++, x+=6)
	   		{
				
				int vertex = x+(6*row*xSize);

	   			triangles[vertex] =  col + (xSize+1)*row ;
	    		triangles[vertex + 1] = triangles[vertex + 3] = col + (xSize+1)*(row+1);
	    		triangles[vertex + 2] = triangles[vertex + 5] = (col+1)+(xSize+1)*row;
	    		triangles[vertex + 4] = (col+1) + (xSize+1)*(row+1) ;//(row+1) * xSize + col;

	   //  		print("顶点：位置点"+vertex+" : "+triangles[vertex]);
	   //  		print("顶点：位置点"+(vertex+1)+" : "+triangles[vertex+1]);
				// print("顶点：位置点"+(vertex+2)+" : "+triangles[vertex+2]);
				// print("顶点：位置点"+(vertex+3)+" : "+triangles[vertex+3]);
				// print("顶点：位置点"+(vertex+4)+" : "+triangles[vertex+4]);
				// print("顶点：位置点"+(vertex+5)+" : "+triangles[vertex+5]);
				
	    		yield return null;
	   		}
   		}
   		
    	

    	
    	
    	mesh.triangles = triangles;
    	mesh.RecalculateNormals();
    	mesh.uv = uv;
		mesh.tangents = tangents;
	}

    private void Awake ()
	{
    	StartCoroutine(Generate());
	}

	private void OnDrawGizmos () 
	{
		if(vertices == null)
			return;
	    Gizmos.color = Color.black;
	    for (int i = 0; i < vertices.Length; i++) 
	    {
	        Gizmos.DrawSphere(vertices[i], 0.1f);
	    }
	}
}

