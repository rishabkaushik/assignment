**free
//This module consists of procedures to process different requests based on the method
//passed from html form. This is a nomain module and should be bound to REQUEST.RPGLE
ctl-opt NoMain;
//Members common to all CGIDEV2 programs
/copy CGIDEV2/qrpglesrc,hspecs              //Control specifications common to all CGIDEV2 programs
/copy CGIDEV2/qrpglesrc,hspecsbnd           //Binding specifications common to all CGIDEV2 programs
/copy CGIDEV2/qrpglesrc,usec                //System standard error DS common to all CGIDEV2 program
/copy CGIDEV2/qrpglesrc,variables3          //CGIDEV2 variables common to all CGIDEV2 programs

//File to be read, updated and records deleted as per the method received from user
dcl-f Studet usage(*update:*output:*delete) keyed usropn;
//Debug File
dcl-f dbgfile usage(*output) keyed usropn;

dcl-proc GET_METHOD Export;              //Procedure for fetching student data
  /copy CGIDEV2/qrpglesrc,prototypeb       //For Nomain module protoypeb needs to be included inside
  //Data Structure to hold getHtmlIfsMult procedure error indicators//
  dcl-ds IfsMultIndicators ;
    NoErrors      ind;
    NameTooLong   ind;
    NotAccessible ind;
    NoFilesUsable ind;
    DupSections   ind;
    FileIsEmpty   ind;
  end-ds;

  dcl-s extHtml char(2000) inz('/cgidev/rishab/html/GET.html');
  dcl-s Action char(6);
  //Fetch variables recieved from browser into program arrays
  nbrVars =  zhbgetinput(savedquerystring:qusec);
  //Fetch variables program arrays using variable name
  Action  = %trim(zhbgetvar('_method')) ;
  If Action = 'PUT';
     PUT_METHOD();
     return;
  elseif Action = 'DELETE';
     DEL_METHOD();
     return;
  Endif;

  //Process GET request without any hidden Method field
  IfsMultIndicators = getHtmlIfsMult(%trim(exthtml):'<as400>');
  wrtsection('top');
  wrtsection('thead');
  open studet;
  setll *loval studet;
    read studet;
    dow not %eof(studet);
      updHTMLvar('SROLL':%char(SROLL):'0');
      updHTMLvar('SNAME':SNAME);
      updHTMLvar('SMARKS':%char(SMARKS));
      updHTMLvar('SCITY':SCITY);
      wrtsection('details');
      read studet;
    enddo;
  wrtsection('tclose');
  wrtsection('*fini');
  close studet;
  return;
end-proc;

dcl-proc POST_METHOD Export;            //Procedure for updating student data
  /copy CGIDEV2/qrpglesrc,prototypeb
  dcl-ds IfsMultIndicators ;
    NoErrors      ind;
    NameTooLong   ind;
    NotAccessible ind;
    NoFilesUsable ind;
    DupSections   ind;
    FileIsEmpty   ind;
  end-ds;
  dcl-s extHtml char(2000) inz('/cgidev/rishab/html/GET.html');
  dcl-s Rollno int(10);
  dcl-s Name char(20);
  nbrVars =  zhbgetinput(savedquerystring:qusec);
  Rollno  = %int(%trim(zhbgetvar('rollno')));
  Name  = %trim(zhbgetvar('name')) ;

  //Update student details
  open studet;
  setll *loval studet;
  read studet;
  dow not %eof(studet);
    if sroll = Rollno;
     Sname = Name;
     update studr;
     leave;
    endif;
  read studet;
  enddo;
  close studet;

  //After updating the data, show user updated data
  IfsMultIndicators = getHtmlIfsMult(%trim(exthtml):'<as400>');
  wrtsection('top');
  wrtsection('thead');
  open studet;
  setll *loval studet;
    read studet;
    dow not %eof(studet);
     if sroll = Rollno;
      updHTMLvar('SROLL':%char(SROLL):'0');
      updHTMLvar('SNAME':SNAME);
      updHTMLvar('SMARKS':%char(SMARKS));
      updHTMLvar('SCITY':SCITY);
      wrtsection('details');
      leave;
     endif;
    read studet;
    enddo;
  close studet;
  wrtsection('tclose');
  wrtsection('*fini');
  return;
end-proc;

dcl-proc PUT_METHOD Export;             //Procedure for adding student data
  /copy CGIDEV2/qrpglesrc,prototypeb
  dcl-ds IfsMultIndicators ;
    NoErrors      ind;
    NameTooLong   ind;
    NotAccessible ind;
    NoFilesUsable ind;
    DupSections   ind;
    FileIsEmpty   ind;
  end-ds;
  dcl-s extHtml char(2000) inz('/cgidev/rishab/html/GET.html');
  dcl-s Rollno int(10);
  dcl-s Name char(20);
  dcl-s Marks char(20);
  dcl-s City char(20);
  //For debugging purposes only
  open dbgfile;
     testf = %char(nbrVars);
     write debugr;
  close dbgfile;
  //We are not using zhbGetinput because this method is being called from GET_METHOD
  //Calling ZhbGetinput twice will result in clearing source and program variables
  Rollno  = %int(%trim(zhbgetvar('rollno')));
  Name  = %trim(zhbgetvar('name')) ;
  Marks = %trim(zhbgetvar('marks')) ;
  City  = %trim(zhbgetvar('city')) ;

  //Write records into file
  open studet;
     Sroll = %int(Rollno) ;
     Sname = Name   ;
     Smarks = %int(Marks)  ;
     Scity = City   ;
     write studr;
  close studet;

  //Load the Student table
  IfsMultIndicators = getHtmlIfsMult(%trim(exthtml):'<as400>');
  wrtsection('top');
  wrtsection('thead');
  open studet;
  setll *loval studet;
    read studet;
    dow not %eof(studet);
     if sroll = Rollno;
      updHTMLvar('SROLL':%char(SROLL):'0');
      updHTMLvar('SNAME':SNAME);
      updHTMLvar('SMARKS':%char(SMARKS));
      updHTMLvar('SCITY':SCITY);
      wrtsection('details');
     endif;
    read studet;
    enddo;
  close studet;
  wrtsection('tclose');
  wrtsection('*fini');
  return;
end-proc;

dcl-proc DEL_METHOD Export;             //Procedure for deleting student data
  /copy CGIDEV2/qrpglesrc,prototypeb
  dcl-ds IfsMultIndicators ;
    NoErrors      ind;
    NameTooLong   ind;
    NotAccessible ind;
    NoFilesUsable ind;
    DupSections   ind;
    FileIsEmpty   ind;
  end-ds;

  dcl-s extHtml char(2000) inz('/cgidev/rishab/html/GET.html');
  dcl-s Rollno int(10);

  //We are not using zhbGetinput because this method is being called from GET_METHOD
  //Calling ZhbGetinput twice will result in clearing source and program variables
  Rollno  = %int(%trim(zhbgetvar('rollno')));

  open studet;
  setll *loval studet;
  read studet;
  dow not %eof(studet);
    if sroll = rollno;
      delete studr;
    endif;
    read studet;
  enddo;
  close studet;

  //Load the table for WEB
  IfsMultIndicators = getHtmlIfsMult(%trim(exthtml):'<as400>');
  wrtsection('top');
  wrtsection('thead');
  open studet;
  setll *loval studet;
    read studet;
    dow not %eof(studet);
      updHTMLvar('SROLL':%char(SROLL):'0');
      updHTMLvar('SNAME':SNAME);
      updHTMLvar('SMARKS':%char(SMARKS));
      updHTMLvar('SCITY':SCITY);
      wrtsection('details');
    read studet;
    enddo;
  close studet;
  wrtsection('tclose');
  wrtsection('*fini');
  return;
end-proc;
