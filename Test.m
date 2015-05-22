tic
move = floor(wSize/5);
% image window, up-left corner coordinate
x = 1; y = 1; 
% coordinate(s) of the window with a face detected. [x y]
result = cell(length(TestImage),1);
empty = [];
wb = waitbar(0,'Testing...');
% index = 100;
for index = 1:length(TestImage);
    r = [];
    % get the image that will be treated
    image = TestImage{index};
    % size of the image
    [l, c] = size(image);
    % generate the coefficient for resizing the image
    mult = wSize/max(c,l):0.1:1;
    % make a copy and resize the image
    for i = 1:length(mult)
        image_t = imresize(image, mult(i));
        [l, c] = size(image_t);
        if min(c,l) < wSize
            if c < l
                dx = wSize - min(c,l);
                dx = ceil(dx/2);
                image_t = [zeros(l,dx),image_t,zeros(l,dx)];
                dy = 0;
                %image_t = [image_t;zeros(1,length(image_t(1,:)))];
            else
                dy = wSize - min(c,l);
                dy = ceil(dy/2);
                image_t = [zeros(dy,c);image_t;zeros(dy,c)];
                dx = 0;
                %image_t = [image_t,zeros(length(image_t(:,1)),1)];
            end
        end
        [l, c] = size(image_t);
        for x = 1:move:c-wSize+1
            for y = 1:move:l-wSize+1
                window = getW(image_t,x,x+wSize-1,y,y+wSize-1);
                HOGfeature = double(extractHOGFeatures(window));
                [label] = svmpredict(1,HOGfeature,linear_model);
%             window = reshape(window, 1, wSize^2);
%             [label] = svmpredict(1,window,linear_model);
                if label == 1
                    r = [r;x/mult(i)-dx,y/mult(i)-dy,wSize/mult(i)];
                end 
            end
        end
        if ~isempty(r)
            result{index} = [mean(r(:,1)),mean(r(:,2)),mean(r(:,3)),mean(r(:,3))];
            result{index} = floor(result{index});
            break;
        end
    end
    if isempty(result{index})
        empty = [empty;index];
    end
    waitbar(index/length(TestImage));
end
close(wb);
toc