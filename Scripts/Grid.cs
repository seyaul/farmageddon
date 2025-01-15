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
	
	private int[,,] matchlen_arr;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		int[,] all_pieces = new int[width,height];
		all_pieces.Initialize();
		spawn_piece();
		GD.Print("spawn piece called");
	}

	private Vector2 coord_to_pixel(int row, int column){
		int new_x = x_start + column * offset;
		int new_y = y_start + row * offset;
		return new Vector2(new_x, new_y);
	}

	private void spawn_piece(){
		int[] grid_rows = new int[width];
		int[][] grid = new int[height][];
		Godot.PackedScene piece;
		for (int i = 0; i < height; i++){
			for (int j = 0; j < width; j++){
				int rand_num = GD.RandRange(0, possible_pieces.Length - 1);
				grid_rows[j] = rand_num;
				//piece = possible_pieces[rand_num];
				//Godot.Node2D piece_instance = (Godot.Node2D)piece.Instantiate();
				//GetTree().Root.AddChild(piece_instance);
				//piece_instance.Position = coord_to_pixel(i, j);
			}
			grid[i] = grid_rows;
			grid_rows = new int[width];
		}
		//toString(grid);
		reshuffle_piece(grid);
		
	}
	
	private void reshuffle_piece(int[][] grid){
		int rand_num = 0;
		Godot.PackedScene piece;
		for (int i = 0; i < height; i++){
			for(int j = 0; j < width; j++){
				if(match_at(i, j, grid)){
					GD.Print("Hello, there is a match at ", i, " ", j);
					int counter = 0;
					while(match_at(i, j, grid)){
						if(counter > 1000){
							GD.Print("Overflow");
						}
						rand_num = GD.RandRange(0, possible_pieces.Length - 1);
						grid[i][j] = rand_num;
						counter++;
					}
					piece = possible_pieces[rand_num];
					Godot.Node2D piece_instance = (Godot.Node2D)piece.Instantiate();
					GetTree().Root.AddChild(piece_instance);
					piece_instance.Position = coord_to_pixel(i,j);
				}
			}
		}
	}
	
	// Helper function to see if there is a match at spawn to reshuffle tile if needed
	private bool match_at(int row_idx, int col_idx, int[][] grid){
		int width = grid[0].Length;
		int height =  grid.Length;
		int[,,] what = new int[width,height,2 ];
		if (matchlen_arr == null){
			GD.Print("baaaaaka");
			matchlen_arr = match_dp_setup(width, height, grid);
			GD.Print(matchlen_arr);
			what = matchlen_arr;
		}
		for(int i = 0; i < height; i++){
			for(int j = 0; j < width; j++){
				for(int dir = 0; dir < 2; dir++){
					GD.Print(what[i, j, dir]);
					if (matchlen_arr[i,j,dir] >= 3){
						GD.Print("there is a match! I'm in match_at");
						return true;
					}
				}
			}
		}
		return false;
	}
	
	// Helper function to set up the dp array
	private int[,,] match_dp_setup(int width, int height, int[][] grid){
		int[,,] match_array = new int[height, width, 2];
		// Base case setup
		for(int i = 0; i < height; i++){
			match_array[i, 0, 0] = 1;
			match_array[i, 0, 1] = 1;
		}
		for(int j = 0; j < width; j++){
			match_array[0,j,0] = 1;
			match_array[0,j,1] = 1;
 		}
		for(int i = 1; i < height; i++){
			for(int j = 1; j < width; j++){
				for (int dir = 0; dir < 2; dir++){
					if(dir == 0){
						//GD.Print(height, " ", width, " ", i, " ", j, " ", grid.Length, " ", grid[0].Length);
						if(grid[i][j] == grid[i][j-1]){
							match_array[i, j-1, dir] += 1;
						} else {
							match_array[i, j-1, dir] = 1;
						}
					}
					if(dir == 1){
						if(grid[i][j] == grid[i-1][j]){
							match_array[i-1, j, dir] += 1;
						} else {
							match_array[i-1, j, dir] = 1;
						}
					}
				}
			}
		}
		return match_array;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	
	
	// Helper function to see a visual representation of jagged integer arrays
	private void toString(int[][] arr){
		string row = "[";
		for (int i = 0; i < arr.Length; i++){
			for (int j = 0; j < arr[0].Length; j++){
				if(j != arr[0].Length - 1){
					row += arr[i][j] + " ";
				} else {
					row += arr[i][j];
				}
			}
			row += "]";
			GD.Print(row);
			row = "[";
		}
	}
}
