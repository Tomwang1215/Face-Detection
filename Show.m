for index = 1:length(result)
    imshow(TestImage{index});
    if ~isempty(result{index})
    x = result{index}(1);
    y = result{index}(2);
    d = result{index}(3);
    rectangle('Position',[x,y,d,d]);
    end
end