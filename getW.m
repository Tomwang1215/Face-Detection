function [ window ] = getW( image, x1,x2,y1,y2 )
   [l, c]= size(image);
   if x2<c
       window = image(:,1:x2);
   else
       window = [image,zeros(l,x2-c)];
   end
   [l, c]= size(window);
   
   if y2<l
       window = window(1:y2,:);
   else
       window = [window; zeros(y2-l,c)];
   end
   [l, c]= size(window);
   
   if x1>0
       window = window(:,x1:c);
   else
       window = [zeros(l,1-x1),window];
   end
   [l, c]= size(window);
   
   if y1>0
       window = window(y1:l,:);
   else
       window = [zeros(1-y1,c);window];
   end
end