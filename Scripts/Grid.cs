using Godot;
using System;

public partial class Grid : Node2D
{
	[Export]
	private int width;
	[Export]
	private int height;
	[Export]
	private int x_start;
	[Export]
	private int y_start;
	[Export]
	private int offset;	
	Godot.PackedScene[] possible_pieces = 
	{ResourceLoader.Load<PackedScene>("res://Scenes/carrot_tile.tscn"), 
	ResourceLoader.Load<PackedScene>("res://Scenes/corn_tile.tscn"), 
	ResourceLoader.Load<PackedScene>("res://Scenes/potato_tile.tscn"), 
	GD.Load<PackedScene>("res://Scenes/wheat_tile.tscn")};
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		int[,] all_pieces = new int[width,height];
		all_pieces.Initialize();
		spawn_piece();
	}

	private Vector2 coord_to_pixel(int row, int column){
		int new_x = x_start + row * offset;
		int new_y = y_start + column * offset;
		return new Vector2(new_x, new_y);
	}

	private void spawn_piece(){
		Godot.PackedScene piece;
		for (int i = 0; i < width; i++){
			for (int j = 0; j < height; j++){
				int rand_num = GD.RandRange(0, possible_pieces.Length - 1);
				// For some reason, the coordinates of the random tile generation doesn't 
				// seem to exactly match the on screen tile. Need to look into this further.
				GD.Print(rand_num, " ", (i,j));
				piece = possible_pieces[rand_num];
				Godot.Node2D piece_instance = (Godot.Node2D)piece.Instantiate();
				GetTree().Root.AddChild(piece_instance);
				piece_instance.Position = coord_to_pixel(i, j);
			}
		}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
