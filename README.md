# cubesplines
Project in institute
NASM For Windows

<h1>PROJECT ISN'T DONE YET<br>IF YOU RUN PROGRAM AND YOUR PC EXPLODES, I WARNED YOU</h1>

<h1>Requirements:</h1>
1. NASM: https://www.nasm.us/<br/>
2. Find all using dll loctions: https://www.google.com/<br/>
3. Install gcc (or any linker)

<h1>Compile:</h1>
0. Open console in folder with main.asm<br/><br/>
1. You need NASM installed:<br/>
    nasm -f win32 main.asm<br/><br/>
2. You need gcc installed and know you kernel32 path:<br/>
    gcc main.obj C:\\Windows\System32\Kernel32.dll -o app.exe<br/><br/>
3. After success you can run app by write: <br/>
    app<br/>
