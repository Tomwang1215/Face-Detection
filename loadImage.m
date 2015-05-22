clear;
tic
%%
TestImageFolder = '/Users/Bazinga/Documents/SY32/Face detecter/test';
TrainImageFolder = '/Users/Bazinga/Documents/SY32/Face detecter/train';
LabelFolder = '/Users/Bazinga/Documents/SY32/Face detecter/label';

%%
TrainImage = cell(1000,1);
Label = [];
for i = 1:1000
    image = imread(sprintf('%s/%04d.jpg',TrainImageFolder, i));
    if isgray(image)
        image = im2double(image);
    else
        image = im2double(rgb2gray(image));
    end
    TrainImage{i} = image;
    Label = [Label; load(sprintf('%s/%03d.txt',LabelFolder, i))];
end

TestImage = cell(447,1);
for i = 1:447
    image = imread(sprintf('%s/%04d.jpg',TestImageFolder, i));
    if isgray(image)
        image = im2double(image);
    else
        image = im2double(rgb2gray(image));
    end
    TestImage{i} = image;
end
toc