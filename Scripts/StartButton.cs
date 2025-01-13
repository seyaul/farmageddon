using Godot;
using System;

public partial class StartButton : Button
{
	private PackedScene scene;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Pressed += OnPressed;
	 	scene = ResourceLoader.Load<PackedScene>("res://Scenes/gameplayTest.tscn");	
	}
	
	void OnPressed(){
		GD.Print("button pressed");
		GetTree().Root.AddChild(scene.Instantiate());
		GetTree().ChangeSceneToPacked(scene);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
