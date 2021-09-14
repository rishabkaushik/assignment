**free
//This program is the main program to provide a webpage interface to test GET, POST, PUT and DELETE
//methods. All CGIDEV2 programs needs to be compiled as module first and then use CRTPGM //

//Members common to all CGIDEV2 programs
/copy CGIDEV2/qrpglesrc,hspecs              //Control specifications common to all CGIDEV2 programs
/copy CGIDEV2/qrpglesrc,hspecsbnd           //Binding specifications common to all CGIDEV2 programs
/copy CGIDEV2/qrpglesrc,prototypeb          //ReadyMade prototypes common to all CGIDEV2 programs
/copy CGIDEV2/qrpglesrc,usec                //System standard error DS common to all CGIDEV2 program
/copy CGIDEV2/qrpglesrc,variables3          //CGIDEV2 variables common to all CGIDEV2 programs
//Data Structure to hold getHtmlIfsMult procedure error indicators//
dcl-ds IfsMultIndicators ;
    NoErrors      ind;
    NameTooLong   ind;
    NotAccessible ind;
    NoFilesUsable ind;
    DupSections   ind;
    FileIsEmpty   ind;
end-ds;
//Variable to store IFS HTML file path to process//
dcl-s extHtml  char(2000) inz('/cgidev/rishab/html/webreq.html');

//Load IFS file into program Buffer//
IfsMultIndicators = getHtmlIfsMult(%trim(extHtml):'<as400>');

//Write HTML Sections to web buffer. *fini section is mandatory and is to be written after all secti
//*fini tells apache server to send the web buffer to the web browser.
wrtsection('top *fini');

//Return from the program. Do not use *INLR = *ON as it can cause performance issue each time a CGI
return;
