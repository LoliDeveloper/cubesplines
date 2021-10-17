all: main.obj 
	gcc -g main.obj C:\\\\Windows\\System32\\Kernel32.dll -o app.exe

main.obj: main.asm
	nasm -g -f win32 main.asm

run: all
	$(info ************  APP RUNNING ************)
	@app

clean:
	del 	main.obj
	del 	app.exe