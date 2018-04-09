function takeStackOfEntireFOV
global state gh dia
ds = dia.hPos.allPositionsDS;
zRange = [min(ds.motorZ) - (state.acq.numberOfZSlices*state.acq.zStepSize/2),...
    max(ds.motorZ) + (state.acq.numberOfZSlices*state.acq.zStepSize/2)];

%set Z center
zCenter = min(ds.motorZ) + range(ds.motorZ)/2;

%set appropriate slice number
numZSlices = ceil(range(zRange)/state.acq.zStepSize);

%set large scan pixel count
pixelsPerLine = 1024;
linesPerFrame = 1024;
valref = strfind(get(gh.configurationControls.pixelsPerLine,'String'),num2str(pixelsPerLine));
val = find(~cellfun(@isempty,valref));
set(gh.configurationControls.pixelsPerLine, 'Value', val);
state.acq.pixelsPerLine = pixelsPerLine;
genericCallback(gh.configurationControls.pixelsPerLine);
state.acq.linesPerFrame = linesPerFrame;
set(gh.configurationControls.linesPerFrame, 'String', num2str(linesPerFrame));
genericCallback(gh.configurationControls.linesPerFrame);
