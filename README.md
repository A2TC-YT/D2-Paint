# D2-Paint

Make images on a wall with a trace rifle in Destiny 2.

## Example Images

- **Drawing GUI Pattern**:
  
    ![Drawing GUI Example](/images/in_GUI_amogus.png)

- **In-Game Result**:
  
    ![In-Game Example](/images/in_game_amogus.png)

## Features

- **Main GUI**: Set up the drawing parameters:
    - `Image File`: Choose an image file that contains the pattern.
    - `Hotkey`: Set a custom hotkey to trigger the shooting pattern.
    - `Image Width and Height`: Define the dimensions of the image in game. If the image seems stretched adjusting these can help.
    - `Shooting Speed`: Choose between slow, medium, and fast shooting speeds.
    - `Draw Image`: Opens the Drawing GUI to create or modify patterns.

- **Drawing GUI**: Create or load patterns:
    - Draw on a 30x30 grid using the left mouse button (to draw) and the right mouse button (to erase).
    - `Clear Board`: Clears the drawing grid.
    - `Save Drawing`: Saves the current pattern as a `.txt` file.
    - `Load Drawing`: Loads a saved pattern.

## Things to Note

- **In-Game Obstructions**: if you are in an area with a lot of things going on (ads spawning, shooting, public event happening) it may not work as well.
- **Starting Location**: it will start shooting at the top-most left-most pixel in the drawing.
- **In-Game Sensitivity**: This will work best on 6 in game sens, but you should be able to make it work on any sens. You can try adjusting the image width and height on the main GUI as well. 
- **In-Game Graphics Settings**: Higher graphics settings allow for the images to show up better. 

## How to Use

1. **Download**: Download the `D2_Paint.ahk` and `Gdip_all.ahk` files and make sure they are both in the same folder.
2. **Setup**: Run the `D2_Paint.ahk` AHK script. This will open the Main GUI.
3. **Choose an Image**: Use the `Browse` button to select a previously saved pattern or use the `Draw Image` button to create a new one.
4. **Set Hotkey**: Choose a hotkey that, when pressed, will trigger the shooting pattern.
5. **Define Image Width and Height**: Enter the dimensions you want the imag eto have in game.
6. **Choose Shooting Speed**: Select a shooting speed.
7. **Drawing**: In the Drawing GUI, left-click to draw and right-click to erase. Save your pattern when finished.
8. **In-Game**: Use the chosen hotkey to activate the shooting pattern.
