# D2-Paint

Make images on a wall with a trace rifle in Destiny 2.

## Example Images

- **Drawing GUI Pattern**:
    ![Drawing GUI Example](path/to/drawing-gui-example.png)

- **In-Game Result**:
    ![In-Game Example](path/to/in-game-example.png)

## Features

- **Main GUI**: Set up the drawing parameters:
    - `Image File`: Choose an image file that contains the pattern.
    - `Hotkey`: Set a custom hotkey to trigger the shooting pattern.
    - `Bullet Hole Size X/Y`: Define the dimensions of the bullet hole.
    - `Shooting Speed`: Choose between slow, medium, and fast shooting speeds.
    - `Draw Image`: Opens the Drawing GUI to create or modify patterns.

- **Drawing GUI**: Create or load patterns:
    - Draw on a 30x30 grid using the left mouse button (to draw) and the right mouse button (to erase).
    - `Clear Board`: Clears the drawing grid.
    - `Save Drawing`: Saves the current pattern as a `.txt` file.
    - `Load Drawing`: Loads a saved pattern.

## How to Use

1. **Download**: Download the `D2_Paint.ahk` and `Gdip_all.ahk` files and make sure they are both in the same folder.
1. **Setup**: Run the `D2_Paint.ahk` AHK script. This will open the Main GUI.
2. **Choose an Image**: Use the `Browse` button to select a previously saved pattern or use the `Draw Image` button to create a new one.
3. **Set Hotkey**: Choose a hotkey that, when pressed, will trigger the shooting pattern.
4. **Define Image Width and Height**: Enter the dimensions you want the imag eto have in game.
5. **Choose Shooting Speed**: Select a shooting speed.
6. **Drawing**: In the Drawing GUI, left-click to draw and right-click to erase. Save your pattern when finished.
7. **In-Game**: Use the chosen hotkey to activate the shooting pattern.
