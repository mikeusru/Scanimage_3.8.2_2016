function figshift(scale)
% FIGSHIFT   - Cascades current figure window away from previous figure.
% 	FIGSHIFT places figure window slightly offset from previous figure
%  	window, to allow for easy switching between windows.  This is similar
%  	to the old Windows "Cascade" feature.
% 
% 	Optional scalar argument SCALE sets how far figure is offset from previous 
%  	figure, as a percent of previous figure dimensions (0<SCALE<100)
%
%	Call FIGSHIFT after opening window
% 
%   See also FILLSCREEN, SPLAYFIGS

if nargin==0
	scale=.05;	%Default, 5% of figure size
else
	scale=scale*.01;
end;

%Get Current Figure Handle
CurrentHandle=gcf;

%FigUnits=get(CurrentHandle,'Units');

scnsize=get(0,'ScreenSize');
ScnWidth=scnsize(3);
ScnHeight=scnsize(4);


if gcf==1

	str='Can''t shift first figure';
%	disp(str)
	return		%Do nothing if this is the first figure window

else

	PrevHandle=gcf-1;
	PrevPosition=get(PrevHandle,'Position');
	Units=get(PrevHandle,'Units');
	FigWidth=PrevPosition(3);
	FigHeight=PrevPosition(4);
	NewPosition=PrevPosition;
	NewPosition(1)=PrevPosition(1)+FigWidth*scale;	    %Shift Over
	NewPosition(2)=PrevPosition(2)-FigHeight*scale;		%Shift Down

	%Check if the new position is off of the screen
	%If it is, move figure to upper left corner of screen
	if ((NewPosition(1)+FigWidth) > ScnWidth) | ((NewPosition(2)+FigHeight) > ScnHeight)
		NewPosition(1)=0;
		NewPosition(2)=ScnHeight*.95 - FigHeight;
	end;

	set(gcf,'Units',Units,'Position',NewPosition);
	
end;
