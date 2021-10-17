all: main.obj 
	gcc main.obj C:\\\\Windows\\System32\\Kernel32.dll -o app.exe

main.obj: main.asm
	nasm -f win32 main.asm

run: all
	$(info ************  APP RUNNING ************)
	@app