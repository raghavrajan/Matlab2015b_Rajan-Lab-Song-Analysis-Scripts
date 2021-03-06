function uizoomcontrols(action)

%builds controls for spectrogram display in current window

global spect_floor spect_ceil spect_range

if strcmp(action, 'initialize')

  %button parameters
   slid_width = .015;
   slid_height = .3;
   top_border = .08;
   left_border = .92;
   spacing = .01;
   
  %control positions
   floor_position = [left_border 1-top_border-slid_height slid_width slid_height];
   ceil_position = [left_border+slid_width+spacing 1-top_border-slid_height slid_width slid_height];
   range_position = [left_border+2*slid_width+2*spacing 1-top_border-slid_height slid_width slid_height];
   
  %-------------------------------------------------------------
  % floor slider
  %-------------------------------------------------------------
    h_floor = uicontrol(gcf,...
                    'style','slider',...
                    'units','normalized',...
                    'position', floor_position,...
                    'min',-100,...
                    'max', 0,...
                    'value', spect_floor,...
		    'TooltipString', 'Set spectrum floor',...
                    'callback','uispectcontrols(''remap'')');
                    

  %-------------------------------------------------------------
  % ceil slider
  %-------------------------------------------------------------
    h_ceil = uicontrol(gcf,...
                    'style','slider',...
                    'units','normalized',...
                    'position', ceil_position,...
                    'min',-100,...
                    'max', 0,...
                    'value', spect_ceil,...
		    'TooltipString', 'Set spectrum ceiling',...
                    'callback','uispectcontrols(''remap'')');                    


  %-------------------------------------------------------------
  % range slider
  %-------------------------------------------------------------
    h_range = uicontrol(gcf,...
                    'style','slider',...
                    'units','normalized',...
                    'position', range_position,...
                    'min', 0,...
                    'max', 4.0,...
                    'value', spect_range,...
		    'TooltipString', 'Set spectrum range',...
                    'callback','uispectcontrols(''remap'')');
                    
 
  %-------------------------------------------------------------
  % store handles in userdata
  %------------------------------------------------------------- 
  
  set(h_floor,'userdata',[h_floor h_ceil h_range]);
  set(h_ceil,'userdata',[h_floor h_ceil h_range]);                  
  set(h_range,'userdata',[h_floor h_ceil h_range]);
                    
elseif strcmp(action,'remap')
    handles = get(gco,'userdata');
    %make_current(get(gco,'parent'),1);
    spect_floor = get(handles(1),'value');
    spect_ceil = get(handles(2),'value');
    spect_range = get(handles(3), 'value');
    %restrict ranges of values for various sliders?
    %editable text widow to display spect values?
    set(gcf,'colormap', make_map(spect_floor, spect_ceil, spect_range));
            
    
end
