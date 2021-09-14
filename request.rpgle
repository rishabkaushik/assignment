**free
//This program is being called from webpage generated by MAIN.RPGLE using form action. See the HTML
//page used in MAIN.RPGLE to customize the program name. You may also want to refer to Apache HTTP
//URL mapping to get an idea about - for which URL which program to call.

//Members common to all CGIDEV2 programs
/copy CGIDEV2/qrpglesrc,hspecs              //Control specifications common to all CGIDEV2 programs
/copy CGIDEV2/qrpglesrc,hspecsbnd           //Binding specifications common to all CGIDEV2 programs
/copy CGIDEV2/qrpglesrc,prototypeb          //ReadyMade prototypes common to all CGIDEV2 programs
/copy CGIDEV2/qrpglesrc,usec                //System standard error DS common to all CGIDEV2 program
/copy CGIDEV2/qrpglesrc,variables3          //CGIDEV2 variables common to all CGIDEV2 programs

//External procedures defined for GET and POST methods. HTTP forms support only GET
//and POST methods so to simulate other methods such as PUT and DELETE I have
//added a hidden field _method in HTML file with values PUT/DELETE (webreq.html).
//The value of _method variable is then checked inside procedure GET_METHOD and then call
//PUT_METHOD and DEL_METHOD inside PROCESSREQ.RPGLE accordingly
dcl-pr GET_METHOD extproc('GET_METHOD');
end-pr;
dcl-pr POST_METHOD extproc('POST_METHOD');
end-pr;

//File used for debugging purposes
dcl-f dbgfile usage(*output) usropn;

//Data Structure to hold getHtmlIfsMult procedure error indicators//
dcl-ds IfsMultIndicators ;
    NoErrors      ind;
    NameTooLong   ind;
    NotAccessible ind;
    NoFilesUsable ind;
    DupSections   ind;
    FileIsEmpty   ind;
end-ds;

dcl-s RequestMethod  char(5);
RequestMethod = GetEnv('REQUEST_METHOD':qusec);

//Just for debugging purposes
open dbgfile;
   testf = RequestMethod+'Main2';
   write debugr;
close dbgfile;

if RequestMethod = 'GET' ;
  GET_METHOD();
  return;
endif;
if RequestMethod = 'POST';
  POST_METHOD();
  return;
endif;
