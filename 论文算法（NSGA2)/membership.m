function  y = membership(r,dem)
%¼ÆËãrµÄÁ¥Êô¶È
    if r >= dem(1) && r < dem(2)
        y = (r - dem(1))/(dem(2) -dem(1));
    elseif r >= dem(2) && r <= dem(3)
        y = (dem(3) - r)/(dem(3) -dem(2));
    end
end