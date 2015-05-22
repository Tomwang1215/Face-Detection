wSize = 64; % wSize^2 is the size of the ture or false images
TrainData = []; % Data of the ture or false images
TrainLabel = []; % ture or false label
num_f = 15; % max number of false samples in this image
n = length(TrainImage);
wb = waitbar(0,'wait...');
tic
for i = 1:n
   waitbar(i/n);
   x1 = Label(i,1);
   y1 = Label(i,2);
   L = Label(i,3);
   H = Label(i,4);
   
   d = max(L,H); 
   
   % reshape the box to square
   x1 = x1 - (d-L)/2; 
   y1 = y1 - (d-H)/2;
   
   % Resize the image that the box length is equal to boxSize
   image = TrainImage{i};
   mult_t = wSize/d;
   image = imresize(image, mult_t);
   % calculate the new coordinate of the box
   x1 = int16(x1 * mult_t);
   y1 = int16(y1 * mult_t);
   x2 = int16(x1 + wSize-1);
   y2 = int16(y1 + wSize-1);
   
   % cut the image, if the box is bigger than the image, add zeros
   face = getW(image,x1,x2,y1,y2);
   % add the data to TrainData
   HOGfeature = extractHOGFeatures(face);
   TrainData = [TrainData; HOGfeature];
   %face = reshape(face,[1,wSize^2]);
   %TrainData = [TrainData; face];
   TrainLabel = [TrainLabel; 1]; % ture
   
   % select false image
   mult_f = []; 
   % It is easier to choose false image if the face is very big or very
   % small in the original image
   if mult_t > 2
       mult_f = random('unif',1,sqrt(mult_t),1,num_f);
   elseif mult_t < 0.3
       mult_f = random('unif',sqrt(mult_t),1,1,num_f);
   end
   
   if length(mult_f) == num_f
      for j = 1:length(mult_f)
          image_f = imresize(TrainImage{i},mult_f(j));
          [l, c]= size(image_f);
          if l>wSize && c>wSize
              % get a random place
              x = random('unid',c-wSize);
              y = random('unid',l-wSize);
              image_f = image_f(y:y+wSize-1, x:x+wSize-1);
              % the false image can't be too simple(like only one color)
              if var(image_f(:))>0.01
                  HOGfeature = extractHOGFeatures(image_f);
                  TrainData = [TrainData; HOGfeature];
                  %image_f = reshape(image_f, 1, wSize^2);
                  %TrainData = [TrainData; image_f];
                  TrainLabel = [TrainLabel; 0]; % false
              end
          end
      end
   end
   TrainData = double(TrainData);
end
close(wb);
toc