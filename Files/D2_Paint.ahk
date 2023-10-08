#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include %A_ScriptDir%\Gdip_all.ahk
SetBatchLines, -1

; drawing GUI

If !pToken := Gdip_Startup()
{
    MsgBox, GDI+ failed to start up. The script will now exit.
    ExitApp
}

; Create 20x20 BMPs for Black and White
WhiteBMP := CreateSolidBitmap(0xFFFFFFFF, 20, 20, "WhiteCell.bmp")
BlackBMP := CreateSolidBitmap(0xFF000000, 20, 20, "BlackCell.bmp")

Gui, +LastFound

; global vars
global cellStates := []
global rows := 30
global cols := 30
global cellSize := 20

; actual gui stuff
Gui, SavingGUI: -Caption +Border +AlwaysOnTop
Gui, SavingGUI: Color, Gray
Gui, SavingGUI: Add, Text, vSaveText Center, Saving... Please wait.
Gui, SavingGUI: Show, w300 h100 NoActivate, Saving
Gui, SavingGUI: Hide

Loop, % rows * cols
{
    c := Mod(A_Index-1, cols) + 1
    r := (A_Index-1) // cols + 1
    Gui, DrawingGUI:Add, Picture, % " x" ((c-1)*cellSize) " y" ((r-1)*cellSize) " w" cellSize " h" cellSize " vCell" A_index , %WhiteBMP%
    cellStates[A_Index] := 0
}

Gui, DrawingGUI:Font, s11
Gui, DrawingGUI:Add, Button, % "x5 y" (rows*cellSize+5) " w100 h40 gClearBoard", Clear Board

Gui, DrawingGUI:Add, Button, % "x115 y" (rows*cellSize+5) " w100 h40  gSaveDrawing", Save Drawing
Gui, DrawingGUI:Add, Button, % "x225 y" (rows*cellSize+5) "  w100 h40 gLoadDrawing", Load Drawing
Gui, DrawingGUI:Add, Button, % "x335 y" (rows*cellSize+5) "  w100 h40 gOpenMainGUI", Main GUI

Gui, DrawingGUI:Show, % "w" (cols*cellSize) " h" ((rows+1)*cellSize + 30), Simple Drawing Board
Gui, DrawingGUI:Hide

; main GUI
; global vars
global BulletHoleSizeX := 20
global BulletHoleSizeY := 20
global ShootingSpeed1
global ShootingSpeed2
global ShootingSpeed3

; actual gui stuff
Gui, MainGUI:New
Gui, MainGUI:Add, Text, x10 y10 w100, Image File:
Gui, MainGUI:Add, Edit, x110 y10 w350 vImageFilePath ReadOnly
Gui, MainGUI:Add, Button, x470 y10 w70 gSelectImage, Browse

Gui, MainGUI:Add, Text, x10 y40 w100, Hotkey:
Gui, MainGUI:Add, Hotkey, x110 y40 w100 vHotkey

Gui, MainGUI:Add, Button, x220 y40 w100 gSetHotkey, Set Hotkey

Gui, MainGUI:Add, Text, x10 y70 w100, Drawing Width:
Gui, MainGUI:Add, Edit, x110 y70 w50 vBulletHoleSizeX Number, 30
Gui, MainGUI:Add, Text, x170 y70 w100, Drawing Height:
Gui, MainGUI:Add, Edit, x270 y70 w50 vBulletHoleSizeY Number, 30

Gui, MainGUI:Add, Text, x10 y100 w100, Shooting Speed:
Gui, MainGUI:Add, Radio, x110 y100 w50 vShootingSpeed1, Slow
Gui, MainGUI:Add, Radio, x170 y100 w70 vShootingSpeed2 Checked, Medium
Gui, MainGUI:Add, Radio, x250 y100 w50 vShootingSpeed3, Fast

Gui, MainGUI:Font, s20
Gui, MainGUI:Add, Button, x330 y40 w210 h80 gDrawGui, Draw Image

Gui, MainGUI:Show, w550 h130, Bullet Hole Art GUI

return

; main GUI functions

SelectImage:
    Gui, MainGUI:Submit, NoHide  ; This will make sure the GUI doesn't hide
    FileSelectFile, selectedFile, , %A_ScriptDir%, Image Files (*.txt), Text Files (*.txt)
    if (selectedFile != "") {
        GuiControl, MainGUI:, ImageFilePath, %selectedFile%
    }
return

DrawGui:
    SetTimer, CheckClick, 10
    Gui, MainGUI:Hide
    Gui, DrawingGUI:Show
return

SetHotkey:
Gui, MainGUI:Submit, NoHide
Hotkey, %Hotkey%, StartShooting  ; This will bind the hotkey to the shooting function
return

global ImageFilePath

StartShooting()
{
    ; Get the settings from the GUI
    Gui, MainGUI:Submit, NoHide
    SleepTime := ShootingSpeed1 ? 60 : (ShootingSpeed2 ? 40 : 20)
    ImageFilePath := ImageFilePath ? ImageFilePath : "ERROR"
    if (ImageFilePath == "ERROR")
    {
        MsgBox, No image selected. 
        Return
    }

    if (SleepTime == 20)
    {
        x_offset := 0
        y_offset := 5
    }
    else if (SleepTime == 40)
    {
        x_offset := 1
        y_offset := 10
    }
    else
    {
        x_offset := 1
        y_offset := 12
    }

    FileRead, Image, %ImageFilePath%

    GridWidth := 30
    GridHeight := 30
    ; Initialize the total relative movement to a large negative value
    TotalRelX := -9999
    TotalRelY := -9999
    Send, {LButton Down}

    index := 900
    Loop, % GridHeight
    {
        Y := 30 - A_Index - 1 ; reverse Y index
        
        Loop, % GridWidth
        {
            X := 30 - A_Index - 1
            Pixel := SubStr(Image, index, 1) ; Get the character at the current position in text file
            index -= 1

            if (Pixel == 1)
            {
                ; If this is the first pixel, set the total relative movement to its position
                if (TotalRelX = -9999 && TotalRelY = -9999)
                {
                    TotalRelX := X * BulletHoleSizeX
                    TotalRelY := Y * BulletHoleSizeY
                }

                RelX := (X * BulletHoleSizeX - TotalRelX) 
                RelY := (Y * BulletHoleSizeY - TotalRelY) 
                
                TotalRelX += RelX
                TotalRelY += RelY
                
                DllCall("mouse_event", uint, 1, int, RelX+x_offset, int, RelY+y_offset, uint, 0, int, 0)
                Sleep, %SleepTime%
            }
        }
    }
    
    Send, {LButton Up}
    return
}

return

CheckClick:
    if !WinActive("Simple Drawing Board")
    {
        Sleep, 100
        return
    }

    if (GetKeyState("LButton", "P") or GetKeyState("RButton", "P"))
    {
        MouseGetPos, mouseX, mouseY
        mouseY -= 25
        mouseX -= 3
        row := Ceil(mouseY/cellSize)
        col := Ceil(mouseX/cellSize)
        
        ControlIndex := (row-1)*cols + col
        ControlName := "Cell" ControlIndex
        
        if (GetKeyState("LButton", "P"))
        {
            GuiControl, DrawingGUI:, %ControlName%, %BlackBMP%
            cellStates[ControlIndex] := 1
        }
        else
        {
            GuiControl, DrawingGUI:, %ControlName%, %WhiteBMP%
            cellStates[ControlIndex] := 0
        }
    }
return

ClearBoard:
    Loop, % rows * cols
    {
        GuiControl, DrawingGUI:, % "Cell" A_Index , % WhiteBMP
        cellStates[A_Index] := 0
    }
return

SaveDrawing:
    FileSelectFile, savePath, S16,, Save Drawing As, Text Files (*.txt)
    if ErrorLevel ; User pressed cancel
        return

    ; Check if the file name has a .txt extension. If not, append it.
    safety := (SubStr(savePath, -3) != ".txt") ? true : false
    if (safety)
        savePath .= ".txt"

    ; Check if the file already exists
    if (FileExist(savePath))
    {
        if safety
            MsgBox, 4, Overwrite File?, The file already exists. Do you want to overwrite it?
        IfMsgBox, No, return
        FileDelete, %savePath% 
    }

    Gui, SavingGUI: Show, NoActivate

    Loop, % rows * cols
        FileAppend, % cellStates[A_Index], %savePath%
    
    Gui, SavingGUI: Hide
return

LoadDrawing:
    FileSelectFile, loadPath, 1,, Load Drawing, Text Files (*.txt)
    if ErrorLevel ; User pressed cancel
        return
    if (!FileExist(loadPath))
    {
        MsgBox, Drawing file not found!
        return
    }
    FileRead, drawingData, %loadPath%
    
    Loop, % rows * cols
    {
        char := SubStr(drawingData, A_Index, 1)
        bmp := (char = 1) ? BlackBMP : WhiteBMP
        cellStates[A_Index] := (bmp = BlackBMP) ? 1 : 0
        GuiControl, DrawingGUI:, % "Cell" A_Index, %bmp%
    }
return

OpenMainGUI:
    SetTimer, CheckClick, Off
    Gui, DrawingGUI:Hide
    Gui, MainGUI:Show
return

GuiClose:
    Gdip_DisposeImage(WhiteBMP)
    Gdip_DisposeImage(BlackBMP)
    Gdip_Shutdown(pToken)
ExitApp

CreateSolidBitmap(color, w, h, filename)
{
    pBitmap := Gdip_CreateBitmap(w, h)
    G := Gdip_GraphicsFromImage(pBitmap)
    Gdip_SetSmoothingMode(G, 4)
    pBrush := Gdip_BrushCreateSolid(color)
    Gdip_FillRectangle(G, pBrush, 0, 0, w, h)
    Gdip_DeleteBrush(pBrush)
    Gdip_DeleteGraphics(G)
    filePath := A_ScriptDir "\" filename
    Gdip_SaveBitmapToFile(pBitmap, filePath)
    Gdip_DisposeImage(pBitmap)
    return filePath
}

F4::
Send, {LButton Up}
reload