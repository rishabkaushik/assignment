Requirements:
1. Create a github profile.
2. Create 4 programs/procedures each for GET/POST/PUT/DELETE.

API & References used:
1. CGIDEV2
2. Easy400.net

List of programs/modules:
1. MAIN.RPGLE
2. REQUEST.RPGLE
3. PROCESSREQ.RPGLE

Compile instructions:
1. Compile MAIN.RPGLE as module and then create MAIN program using CRTPGM from it.
2. Compile REQUEST.RPGLE as module.
3. Compile nomain module PROCESSREQ.RPGLE(as module, need to bind it to REQUEST.RPGLE)
4. Create a program using CRTPGM. Keep REQUEST.RPGLE as entry module and bind PROCESSREQ.RPGLE module as well.

Server configuration:
1. Create a URL mapping in server configurations to redirect a URL to your main program. Set LIBRARY permissions accordingly.
