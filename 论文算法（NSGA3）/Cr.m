function  y = Cr(d,p)
%d 客户模糊需求
%p 车辆或者仓库剩余容量
    if d(1) >= p(3)
        y = 0;
    elseif d(1) < p(3) && d(2) >= p(2)
        y = (p(3) - d(1))/(2*(p(3)-d(1)+d(2)- p(2)));
    elseif d(2) < p(2) && d(3) >= p(1)
        y = (d(3) - p(1) - 2*(d(2)-p(2)))/(2*(p(2)-d(2)+d(3)- p(1)));
    elseif d(3) <= p(1)
        y = 1;
    end
end