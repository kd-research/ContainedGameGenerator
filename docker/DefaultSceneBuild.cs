using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Unity.Collections;
using UnityEditor;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

// PLACE THIS FILE IN projectname/Assets/Scripts/Editor before running scripts

public class SceneBuild
{
  static void GenerateScene()
  {
    string sceneName = "SceneOne";
    string scenePath = Application.dataPath + "/Scenes/" + sceneName + ".unity";
    
    //Create new Scene
    Scene scene = EditorSceneManager.NewScene(NewSceneSetup.DefaultGameObjects);

    // Adding things to Scene so it's not empty
    Debug.Log("POPULATING SCENE");
    PopulateScene(scene);
    Debug.Log("SCENE POPULATION COMPLETE");

    //Save Scene
    EditorSceneManager.SaveScene(scene, scenePath);


    List<EditorBuildSettingsScene> editorScenesToBuild = EditorBuildSettings.scenes.ToList<EditorBuildSettingsScene>();
    editorScenesToBuild.Insert(0, new EditorBuildSettingsScene(scenePath, true));
    EditorBuildSettings.scenes = editorScenesToBuild.ToArray();

  }

  static void PopulateScene(Scene scene)
  {
    List<int> gameObjectInstanceIDs = new();

    GameObject camera = Camera.main.gameObject;
    camera.transform.position = new Vector3(0, 8, -15);
    camera.transform.LookAt(Vector3.zero);
    Debug.Log("CAMERA POSITION " + camera.transform.position);

    GameObject plane = GameObject.CreatePrimitive(PrimitiveType.Plane);
    Renderer planeRenderer = plane.GetComponent<Renderer>();
	planeRenderer.material = new Material(Shader.Find("Standard"));
    planeRenderer.material.color = Color.green;
    plane.transform.localScale = new Vector3(8, 1, 8);
    plane.transform.position = new Vector3(0, -1, 0);
    Debug.Log("PLANE POSITION " + plane.transform.position.ToString());

    GameObject cube = GameObject.CreatePrimitive(PrimitiveType.Cube);
    Renderer cubeRenderer = cube.GetComponent<Renderer>();
    cube.transform.position = new Vector3(3, 4, 5);
    cube.transform.localScale = Vector3.one;
	cubeRenderer.material = new Material(Shader.Find("Standard"));
    cubeRenderer.material.color = Color.blue;
    cube.AddComponent<Rigidbody>();
    Rigidbody cubeRigidBody = cube.GetComponent<Rigidbody>();
    cube.AddComponent<BoxCollider>();
    cubeRigidBody.useGravity = true;

    GameObject sphere = GameObject.CreatePrimitive(PrimitiveType.Sphere);
    Renderer sphereRenderer = sphere.GetComponent<Renderer>();
    sphere.transform.position = new Vector3(3, 8, 4);
    sphere.transform.localScale = Vector3.one;
	sphereRenderer.material = new Material(Shader.Find("Standard"));
    sphereRenderer.material.color = Color.red;
    sphere.AddComponent<Rigidbody>();
    Rigidbody sphereRigidBody = sphere.GetComponent<Rigidbody>();
    sphere.AddComponent<SphereCollider>();
    sphereRigidBody.useGravity = true;

    Debug.Log("PLAYER POSITION " + cube.transform.position.ToString());

    gameObjectInstanceIDs.Add(camera.GetInstanceID());
    gameObjectInstanceIDs.Add(plane.GetInstanceID());
    gameObjectInstanceIDs.Add(cube.GetInstanceID());
    EditorSceneManager.MoveGameObjectsToScene(new NativeArray<int>(gameObjectInstanceIDs.ToArray(), Allocator.Temp), scene);
  }

  static void BuildWin()
  {
    string[] scenes = { "Assets/Scenes/SceneOne.unity" };

    BuildPlayerOptions bPOptions = new BuildPlayerOptions();
    bPOptions.scenes = scenes;
    bPOptions.locationPathName = Application.dataPath + "/../Build/build.exe";
    bPOptions.target = BuildTarget.StandaloneWindows;
    bPOptions.options = BuildOptions.None;
    BuildReport report = BuildPipeline.BuildPlayer(bPOptions);
    BuildSummary summary = report.summary;
    Debug.Log(summary);
  }

  static void BuildWeb()
  {
    string[] scenes = { "Assets/Scenes/SceneOne.unity" };

    PlayerSettings.WebGL.decompressionFallback = true;
    PlayerSettings.WebGL.compressionFormat = WebGLCompressionFormat.Gzip;
	//PlayerSettings.stripEngineCode = false;
	//PlayerSettings.companyName = "ProductName";
	//PlayerSettings.productName = "ProductName";

    BuildPlayerOptions bPOptions = new BuildPlayerOptions();
    bPOptions.scenes = scenes;
    bPOptions.locationPathName = Application.dataPath + "/../Build/";
    bPOptions.target = BuildTarget.WebGL;
    bPOptions.options = BuildOptions.None;
    BuildReport report = BuildPipeline.BuildPlayer(bPOptions);
    BuildSummary summary = report.summary;
    Debug.Log(summary);
  }

}


