function y = Cr1(q,d)
if d(1) >= q(3)
    y = 0;
elseif d(1) < q(3) && d(2) >= q(2)
    y = (q(3)-d(1))/(2*(q(3) - d(1) + d(2) -q(2)));
elseif d(2) < q(2) && d(3) >= q(1)
    y = (d(3)-q(1)-2*(d(2)-q(2)))/(2*(q(2)-d(2)+d(3)-q(1)));
elseif d(3) < q(1)
    y = 1;
end
end
    