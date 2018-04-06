function Aout = r_calcium(num)
global state;
global yphys;

color_a = {'green', 'red', 'white', 'cyan', 'magenda'};


roiobj = findobj('Tag', 'ROI');

nRoi = length(roiobj);

if ~nargin
    num = state.files.fileCounter-1;
end

str1 = '000';
str2 = num2str(num);
str1(end-length(str2)+1:end) = str2;
%filename1 = [basename, str1, 'max.tif'];
filename = [state.files.savePath, state.files.baseName, str1, '.tif'];

yphys.image.filename = filename;
yphys.image.currentImage = num;

for j = 1:nRoi
    set(roiobj(j), 'Visible', 'Off'); 
    set(roiobj(j), 'Visible', 'On');
    set(roiobj(j), 'EdgeColor', color_a{j});
end

if exist(filename)
    [data,header]=genericOpenTif(filename);
end

set(state.internal.imagehandle(1), 'CData', data(:,:,7));
set(state.internal.imagehandle(2), 'CData', data(:,:,8));
roiobj = findobj('Tag', 'ROI');
nRoi = length(roiobj);
for j = 1:nRoi
    set(roiobj(j), 'Visible', 'Off'); 
    set(roiobj(j), 'Visible', 'On');
    set(roiobj(j), 'EdgeColor', color_a{j});
end

for j = 1:nRoi
    ROI = get(roiobj(j), 'Position');
    theta = [0:1/20:1]*2*pi;
    xr = ROI(3)/2;
    yr = ROI(4)/2;
    xc = ROI(1) + ROI(3)/2;
    yc = ROI(2) + ROI(4)/2;
    x1 = round(sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*cos(theta) + xc);
    y1 = round(sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*sin(theta) + yc);
    siz = size(data);
    ROIreg = roipoly(ones(siz(1), siz(2)), x1, y1);
    %figure; image(ROIreg);
    
	for i= 1: header.acq.numberOfFrames
        greenim = data(:,:,i*2-1);
        redim = data(:,:, i*2);
        greenCrop = greenim(ROIreg);
        redCrop = redim(ROIreg);
        greenMean(i, j) = mean(greenCrop(:));
        redMean(i, j) = mean(redCrop(:));
        greenSum(i, j) = sum(greenCrop(:));
        redSum(i, j) = sum(redCrop(:));

	end
    %evalc(['Aout.position', num2str(j), '=ROI']);
    greenMean(:, j) = greenMean(:, j) - greenMean(1, j);
    redMean(:, j) = redMean(:, j) - redMean(1, j);
    greenSum(:, j) = greenSum(:, j) - greenSum(1, j);
    redSum(:, j) = redSum(:, j) - redSum(1, j);
    Aout.ratio(:, j) = greenSum(:, j)/mean(redSum(3:end, j), 1);
    Aout.position{j} = ROI;

end




Aout.greenMean = greenMean;
Aout.redMean = redMean;
Aout.greenSum = greenSum;
Aout.redSum = redSum;

yphys.image.intensity{num} = Aout;

if ~isfield(yphys.image, 'aveImage')
    yphys.image.aveImage = num;
end
if isempty(find(yphys.image.aveImage == num))
    yphys.image.aveImage = [yphys.image.aveImage, num];
end

yphys.image.average.ratio = Aout.ratio .* 0;
for i=yphys.image.aveImage
    yphys.image.average.ratio = yphys.image.intensity{i}.ratio + yphys.image.average.ratio;
end
yphys.image.average.ratio =  yphys.image.average.ratio/length(yphys.image.aveImage);

filenamestr = [state.files.baseName, '_intensity'];
evalc([filenamestr, '=yphys.image.intensity']);

cd([state.files.savePath, 'spc']);
save(filenamestr, filenamestr);

filenamestr2 = ['e', num2str(state.yphys.acq.epochN), 'p', num2str(state.yphys.acq.pulseN), '_int'];

saveAverage.average = yphys.image.average;
saveAverage.aveImage = yphys.image.aveImage;
evalc([filenamestr2, '=saveAverage']);
save(filenamestr2, filenamestr2);

%evalc([state.files.baseName, '_int = A1']);
%save([state.files.baseName, '_int'], [state.files.baseName, '_int']);

yphys_showImageTraces;
