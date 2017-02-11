function uiprint_sa(action);


% user function uiprint_sa modified for use with songanal
% -> allow setting of orientation and paper type
% -> use current figure
% 
%  function uiprint_sa(action)
%  A graphical user interface for printing a figure from matlab
%  which sets up the printing options as menu options and builds
%  the print command.  
%  Typing uiprint_sa with no arguments from the command prompt will 
%  call up the interface and initialize it.  Figure windows can
%  then be sent to the printer or to a file specifying any options
%  or device types supported by Matlab.  See the matlab PRINT command 
%  for a description of the options.  The device and options menus
%  may be edited to exclude devices not available on your site.
%  The CANCEL buton is used to exit w/o printing and
%  the OK button is used to execute the print with the current
%  options.  If printing to a file, a list of files may be obtained
%  with the LIST FILES button and a file may be chosen from the
%  menu given.

%  updated 5/14/95:  fixed -epsi option to override the
%  change of the current figure.  Also added options for
%  output ports on PC's other than LPT1.  Just enter LPTn,
%  where n=0-9 in the "printer name" box to select printers
%  that may be attached to ports other than LPT1 on PC's.  You 
%  need print2.m to do this

%-------------------------------------------------------------------
%  Note to Mathworks:
%  I have also included in this archive, modified versions of the 
%  matlab print and printopt commands called PRINT2.M and
%  PRINTOPT2.M which fix a bug in the print command under Solaris
%  and HP-UX for the HP700, but I think you guys already fixed it
%  for the HP700.  Basically, I changed the 'lpr -r -Pprinter file'
%  command to 'lpr -c -dprinter file;rm file'.  You can take that
%  out by changing line 467 from:
%
%       PR_CMD=['print2',d_str,op_str,w_type,f_num,fp_str];
%
%  to:
%
%       PR_CMD=['print',d_str,op_str,w_type,f_num,fp_str];
%
%  within this function.  Then the files printopt2.m and print2.m
%  are not required.
%-------------------------------------------------------------------


%
%  Author:  D.L. Hallman  Herrick Labs/Purdue University
%  e-mail: hallman@helmholtz.ecn.purdue.edu
%  Last modified: 4/13/95
%

global D_STR O_STR PR_CMD

% 


D_STR=['ps      ';
       'psc     ';
       'ps2     ';
       'psc2    ';
       'eps     ';
       'epsc    ';
       'eps2    ';
       'epsc2   ';
       'hpgl    ';
       'ill     ';
       'mfile   ';
       'laserjet';
       'ljetplus';
       'ljet2p  ';
       'ljet3   ';
       'cdeskjet';
       'cdjcolor';
       'cdjmono ';
       'deskjet ';
       'paintjet';
       'pjetxl  ';
       'bj10e   ';
       'ln03    ';
       'epson   ';
       'eps9high';
       'gif8    ';
       'pcx16   ';
       'pcx256  ';
       'win     ';
       'winc    ';
       'meta    ';
       'bitmap  ';
       'cdj550  ';
       'setup   '];

O_STR=[' -append   ';
       ' -epsi     ';
       ' -ocmyk    ';
       ' -psdefcset'];

if nargin<1,
  action='initialize';
end;



%------------------------------------------
%set up default colors and stuff
%------------------------------------------
  titleColor=[0.8 0.8 0.8];
  btnColor=[0.7 0.7 0.7];
  labelColor=[0.5 0.5 0.5];
  consoleColor=[0.5 0.5 0.7];
  frmColor=[0.5 0.5 0.5];
  quitcolor=[0.5 0.5 0.5];
  labelWid=0.22;
  labelHt=0.05;
  btnWid=0.16;
  btnSpace=0.07;
  btnHt=0.15;
  frmBorder=0.03;

%set up the gui figure
if strcmp(action,'initialize'),
  oldFigNumber=watchon;
  figNumber=figure(...
      'Visible', 'off',...
      'NumberTitle','off',...
      'Units','normalized',...
      'Position',[0.3,0.05,0.5,0.5],...
      'Menubar','none',...
      'Name','Print Dialog Box');
      axis('off');
      
%get some initial printing values
orient = get(oldFigNumber,'paperorientation');
papertype = get(oldFigNumber,'papertype');

  %------------------------------------------------------
  %  Print Dialog Box Frame
  %------------------------------------------------------
  frmPos=[frmBorder frmBorder 1-2*frmBorder 1-2*frmBorder];
  uicontrol(...
      'Style','frame',...
      'Units','normalized',...
      'Position',frmPos,...
      'BackgroundColor',frmColor);
  
  %------------------------------------------------------
  %  The 'Send to' Menu
  %------------------------------------------------------
  %Send to label
  labelStr=['Send to'];
  labelPos=[3*frmBorder 1-3*frmBorder-labelHt labelWid labelHt];
  uicontrol(...
      'Style','Text',...
      'Units','normalized',...
      'Position',labelPos,...
      'BackgroundColor',frmColor,...
      'HorizontalAlignment','center',...
      'String',labelStr);

  %Send popup menu
  labelList=['Printer | File '];
  labelPos=[3*frmBorder 1-3*frmBorder-2*labelHt labelWid labelHt]; 
  hndl1=uicontrol(...
      'Style','popup',...
      'Units','normalized',...
      'Position',labelPos,...
      'String',labelList,...
      'BackgroundColor',btnColor,...
      'Callback','uiprint_sa(''eval'')');

  %---------------------------------------------------------
  %  The 'Options' radio buttons
  %---------------------------------------------------------
  %the options label
  labelPos=[3*frmBorder 1-4*frmBorder-3*labelHt labelWid labelHt];
  labelStr=['Options'];
  uicontrol(...
      'Style','text',...
      'Units','normalized',...
      'Position',labelPos,...
      'BackgroundColor',frmColor,...
      'HorizontalAlignment','center',...
      'String',labelStr);

  %the append option radio button
  labelPos=[3*frmBorder 1-4*frmBorder-4*labelHt labelWid labelHt];
  labelStr=['append'];
  hndl6=uicontrol(...
      'Style','radio',...
      'Units','normalized',...
      'Position',labelPos,...
      'String',labelStr,...
      'BackgroundColor',btnColor,...
      'Callback','uiprint_sa(''eval'')');


  %the epsi option radio button
  labelPos=[3*frmBorder 1-4*frmBorder-5*labelHt labelWid labelHt];
  labelStr=['epsi'];
  hndl7=uicontrol(...
      'Style','radio',...
      'Units','normalized',...
      'Position',labelPos,...
      'String',labelStr,...
      'BackgroundColor',btnColor,...
      'Callback','uiprint_sa(''eval'')');

  %the ocmyk option radio button
  labelPos=[3*frmBorder 1-4*frmBorder-6*labelHt labelWid labelHt];
  labelStr=['ocmyk'];
  hndl8=uicontrol(...
      'Style','radio',...
      'Units','normalized',...
      'Position',labelPos,...
      'String',labelStr,...
      'BackgroundColor',btnColor,...
      'Callback','uiprint_sa(''eval'')');

  %the psdefcset option radio button
  labelPos=[3*frmBorder 1-4*frmBorder-7*labelHt labelWid labelHt];
  labelStr=['psdefcset'];
  hndl9=uicontrol(...
      'Style','radio',...
      'Units','normalized',...
      'Position',labelPos,...
      'String',labelStr,...
      'BackgroundColor',btnColor,...
      'Callback','uiprint_sa(''eval'')');

  %the simulink option radio button
  labelPos=[3*frmBorder 1-4*frmBorder-8*labelHt labelWid labelHt];
  labelStr=['simulink'];
  hndl14=uicontrol(...
      'Style','radio',...
      'Units','normalized',...
      'Position',labelPos,...
      'String',labelStr,...
      'BackgroundColor',btnColor,...
      'Callback','uiprint_sa(''eval'')');

  %------------------------------------------------------
  %  The 'Orientation' Menu
  %------------------------------------------------------
  %Orientation label
  labelStr=['Orientation'];
  labelPos=[3*frmBorder 1-3*frmBorder-10*labelHt labelWid labelHt];
  uicontrol(...
      'Style','Text',...
      'Units','normalized',...
      'Position',labelPos,...
      'BackgroundColor',frmColor,...
      'HorizontalAlignment','center',...
      'String',labelStr);

  %orientation popup menu
  labelList=['Landscape | Portrait'];
  labelPos=[3*frmBorder 1-3*frmBorder-11*labelHt labelWid labelHt];
  hndl15=uicontrol(...
      'Style','popup',...
      'Units','normalized',...
      'Position',labelPos,...
      'String',labelList,...
      'BackgroundColor',btnColor,...
      'Callback','uiprint_sa(''eval'')');
      
  %set paper orientation to initial default 
  if strcmp (orient,'landscape')
     set(hndl15,'value', 1);  
  else     
     set(hndl15,'value', 2);  
  end
 


  %------------------------------------------------------
  %  The 'Paper Type' Menu
  %------------------------------------------------------
  %PaperType label
  labelStr=['Paper Type'];
  labelPos=[3*frmBorder 1-3*frmBorder-13*labelHt labelWid labelHt];
  uicontrol(...
      'Style','Text',...
      'Units','normalized',...
      'Position',labelPos,...
      'BackgroundColor',frmColor,...
      'HorizontalAlignment','center',...
      'String',labelStr);

  %papertype popup menu
  labelList=['usletter | uslegal | a4letter'];
  labelPos=[3*frmBorder 1-3*frmBorder-14*labelHt labelWid labelHt];
  hndl16=uicontrol(...
      'Style','popup',...
      'Units','normalized',...
      'Position',labelPos,...
      'String',labelList,...
      'BackgroundColor',btnColor,...
      'Callback','uiprint_sa(''eval'')');
      
  %set papertype value to inital default
  if strcmp (papertype,'usletter')
     set(hndl16,'value', 1);
  elseif strcmp (papertype,'uslegal')
     set(hndl16,'value', 2);
  else     
     set(hndl16,'value', 3);  
  end


  %-------------------------------------------------------
  %  The 'Figure number' edit box
  %-------------------------------------------------------
  %printer/file name label
  labelStr=['Figure Number'];
  labelPos=[1-3*frmBorder-1.5*labelWid 1-3*frmBorder-labelHt 1.5*labelWid labelHt];
  uicontrol(...
      'Style','Text',...
      'Units','normalized',...
      'Position',labelPos,...
      'BackgroundColor',frmColor,...
      'HorizontalAlignment','center',...
      'String',labelStr);

  %printer/file name edit box
  labelStr=[num2str(oldFigNumber)];
  labelPos=[1-3*frmBorder-1.5*labelWid 1-3*frmBorder-2*labelHt 1.5*labelWid labelHt];
  hndl10=uicontrol(...
      'Style','edit',...
      'Units','normalized',...
      'Position',labelPos,...
      'BackgroundColor',btnColor,...
      'String',labelStr,...
      'Callback','uiprint_sa(''eval'')');

  %-------------------------------------------------------
  %  The 'Printer/File name' edit box
  %-------------------------------------------------------
  %printer/file name label
  labelStr=['Printer/File name'];
  labelPos=[1-3*frmBorder-1.5*labelWid 4.5*frmBorder+labelHt 1.5*labelWid labelHt];
  uicontrol(...
      'Style','Text',...
      'Units','normalized',...
      'Position',labelPos,...
      'BackgroundColor',frmColor,...
      'HorizontalAlignment','center',...
      'String',labelStr);

  %printer/file name edit box
  comp=computer;
  %get a default printer name
  if isunix,
    if (strcmp(comp,'SOL2') | strcmp(comp,'HP700') | strcmp(comp(1:3),'SGI')),
      labelStr=getenv('LPDEST');
    else,
      labelStr=getenv('PRINTER');
    end;
  elseif (strcmp(comp(1:2),'PC')),
    labelStr='LPT1:';
  else,
    labelStr=['ps'];
  end;
  
  
  labelPos=[1-3*frmBorder-1.5*labelWid 4.5*frmBorder 1.5*labelWid labelHt];
  hndl2=uicontrol(...
      'Style','edit',...
      'Units','normalized',...
      'Position',labelPos,...
      'BackgroundColor',btnColor,...
      'String',labelStr,...
      'Callback','uiprint_sa(''eval'')');

  %-------------------------------------------------------
  %  The 'Printer/File path' edit box
  %-------------------------------------------------------
  %printer/file name label
  labelStr=['File path'];
  labelPos=[1-3*frmBorder-1.5*labelWid 7.5*frmBorder+3*labelHt 1.5*labelWid labelHt];
  hndl12=uicontrol(...
      'Style','Text',...
      'Units','normalized',...
      'Position',labelPos,...
      'BackgroundColor',frmColor,...
      'HorizontalAlignment','center',...
      'String',labelStr,...
      'Visible','off');

  %printer/file name edit box
  labelStr=pwd;
  labelPos=[1-3*frmBorder-1.5*labelWid 7.5*frmBorder+2*labelHt 1.5*labelWid labelHt];
  hndl13=uicontrol(...
      'Style','edit',...
      'Units','normalized',...
      'Position',labelPos,...
      'BackgroundColor',btnColor,...
      'String',labelStr,...
      'Visible','off',...
      'Callback','uiprint_sa(''eval'')');

  %-------------------------------------------------------
  %  The 'Device/File type'  menu
  %-------------------------------------------------------
  %Device/File type label
  labelStr=['Device/File type'];
  labelPos=[4*frmBorder+labelWid 1-3*frmBorder-labelHt labelWid labelHt];
  uicontrol(...
      'Style','Text',...
      'Units','normalized',...
      'Position',labelPos,...
      'BackgroundColor',frmColor,...
      'HorizontalAlignment','center',...
      'String',labelStr);

  %Send popup menu
  cpu=computer;
  %get right device list for the system
  labelList=['ps | psc | ps2 | psc2 | eps | epsc | eps2 | epsc2 | ',...
              'hpgl | ill | mfile '];
  if (~strcmp(cpu(1:3),'MAC')),
    labelList=[labelList,'| laserjet | ljetplus | ljet2p | ljet3 | ',...
               'cdeskjet | cdjcolor | cdjmono | deskjet | ',...
	       'pjetxl | bj10e | ln03 | epson | eps9high | gif8 | ',...
               'pcx16 | pcx256 '];
  end;
  if (strcmp(cpu(1:2),'PC')),
    labelList=[labelList,'| win | winc | meta | bitmap | cdj550 | ',...
	       'setup '];
  end;
  labelPos=[4*frmBorder+labelWid 1-3*frmBorder-2*labelHt labelWid labelHt];
  hndl3=uicontrol(...
      'Style','popup',...
      'Units','normalized',...
      'Position',labelPos,...
      'String',labelList,...
      'BackgroundColor',btnColor,...
      'Callback','uiprint_sa(''eval'')');

  %----------------------------------------------------------
  %  the 'Cancel' button
  %----------------------------------------------------------
  btnPos=[5*frmBorder+labelWid 4.5*frmBorder+btnHt btnWid btnHt];
  btnStr=['Cancel'];
  hndl4=uicontrol(...
      'Style','pushbutton',...
      'Units','normalized',...
      'Position',btnPos,...
      'String',btnStr,...
      'BackgroundColor',btnColor,...
      'Callback','close(gcf)');

  %----------------------------------------------------------
  %  the 'OK' button
  %----------------------------------------------------------
  btnPos=[5*frmBorder+labelWid 3*frmBorder btnWid btnHt];
  btnStr=['OK'];
  hndl5=uicontrol(...
      'Style','pushbutton',...
      'Units','normalized',...
      'Position',btnPos,...
      'String',btnStr,...
      'BackgroundColor',btnColor,...
      'Callback','uiprint_sa(''ok'')');

  %---------------------------------------------------------
  %  the 'List Files' button
  %---------------------------------------------------------
  btnPos=[5*frmBorder+labelWid 6*frmBorder+2*btnHt btnWid btnHt];
  btnStr=['List Files'];
  hndl11=uicontrol(...
      'Style','pushbutton',...
      'Units','normalized',...
      'Position',btnPos,...
      'String',btnStr,...
      'BackgroundColor',btnColor,...
      'Callback','uiprint_sa(''listfile'')',...
      'Visible','off');


  %get a list of all adjustable handles to set as UserData
  hndlList=[hndl1 hndl2 hndl3 hndl4 hndl5 hndl6 hndl7 hndl8 hndl9 hndl10 hndl11 hndl12 hndl13 hndl14 hndl15 hndl16];

  %uncover the interface
  watchoff(oldFigNumber);
  set(figNumber,'Visible','on','UserData',hndlList);
  uiprint_sa('eval');

  %----------------------------------------------------------------

elseif strcmp(action,'eval'),

  %get the User data
  hndlList=get(gcf,'UserData');


  %is it simulink or matlab?? do we have a name or a number??
  if (~get(hndlList(14),'Value')),
    %if we have a matlab figure, lets do some things

    %get figure_number to print
    f_num=str2num(get(hndlList(10),'String'));

    %make sure we have this figure
    isFig=(get(0,'Children'))-f_num;
    if isempty(find(isFig==0)),
      fprintf('\n  WARNING: current Figure does not exist \n');
    elseif (isFig(1)==0),
      %we don't want to print the dialog box, do we??
      fprintf('\n WARNING: current Figure is the dialog box!! \n');
    elseif (isFig(2)~=0),
      %pop up the current print figure if it is not already on top
      pdb=get(0,'CurrentFigure');
      set(0,'CurrentFigure',f_num);
      set(0,'CurrentFigure',pdb);
      %if this is a new figure, read in print defaults and set appropriate uicontrol values
      if f_num ~= oldFigNumber
         orient = get(oldFigNumber,'paperorientation');
         papertype = get(oldFigNumber,'papertype');
        %set orientation
          if strcmp (orient,'landscape')
            set(hndlList(15),'value', 1);  
          else     
            set(hndlList(15),'value', 2);  
          end 
        %set papertype
         if strcmp (papertype,'usletter')
            set(hndlList(16),'value', 1);
         elseif strcmp (papertype,'uslegal')
            set(hndlList(16),'value', 2);
         else     
            set(hndlList(16),'value', 3);  
         end
      end
    end;

  else,
    %get simulink window name,let matlab handle the error check
    f_num=get(hndlList(10),'String');
  end;
  
  %get file or printer name; 
  path_str=get(hndlList(13),'String');
  fp_str=get(hndlList(2),'String');
  
  
  %do we have a file or a printer?
  prnt=get(hndlList(1),'Value');
  if (prnt==1),
    fp_str=[' -P',fp_str];
    set(hndlList(11),'Visible','off');
    set(hndlList(12),'Visible','off');
    set(hndlList(13),'Visible','off');
  else,
    set(hndlList(11),'Visible','on');
    set(hndlList(12),'Visible','on');
    set(hndlList(13),'Visible','on');
    fp_str=[' ',path_str,'/',fp_str];
  end;

  %get the device type
  dtype=get(hndlList(3),'Value');
  d_str=[' -d',D_STR(dtype,:)];

  %do we have any options set?
  optstr=[''];
  for i=6:9;
    opt(i-5)=get(hndlList(i),'Value');
    if (opt(i-5)),
      op_str=[op_str,O_STR(i-5,:)];
    end;
  end;
 
  %set the printing parameters of the current figure
  %orientation
  orient_val=get(hndlList(15),'value');
  if orient_val == 1
     orient = 'landscape';
  else 
     orient = 'portrait';
  end
  %papertype
  papertype_val=get(hndlList(16),'value');
  if papertype_val == 1
     papertype = 'usletter';
  elseif papertype_val == 2 
     papertype = 'uslegal';
  else
     papertype = 'a4letter';
  end
 
  
  %set values
  set(f_num,'paperorientation',orient);
  set(f_num,'papertype',papertype);
  
  %do we have a simulink figure or a matlab figure
  if (get(hndlList(14),'Value')),
    w_type=' -s';
  else,
    w_type=' -f';
    f_num=num2str(f_num);
  end;
 

  %set the print command
  PR_CMD=['print2',d_str,op_str,w_type,f_num,fp_str]

elseif strcmp(action,'listfile');

  %open up uigetfile to get a file name
  hndlList=get(gcf,'UserData');

  %get the filter info for the file, filter by device type
  dtype=get(hndlList(3),'Value');
  filt_str=['*.',deblank(D_STR(dtype,:))];
  %cut it to three letters if we are on a PC
  comp=computer;
  if (strcmp(comp(1:2),'PC') & length(filt_str)>5),
    filt_str=filt_str(1:5);
  end;

  [f_name_fig,p_name_fig]=uigetfile(filt_str,'Select File');
  %check to see if we picked a file or a path with uigetfile or not
  if (f_name_fig~='' & f_name_fig~=0)
    set(hndlList(2),'String',f_name_fig);
  end;
  if (p_name_fig~=0),
    set(hndlList(13),'String',p_name_fig);
  end;
  %reset the file and path name and redisplay
  uiprint_sa('eval');

elseif strcmp(action,'ok'),

  %reinstate the dialog box as the current figure if it has changed
  hndlList=get(gcf,'UserData');
  printbox=get(hndlList(1),'Parent');
  
  %execute the print command and exit
  eval(PR_CMD);
  close(printbox);
  fprintf('\n figure sent ...\n');

end;
