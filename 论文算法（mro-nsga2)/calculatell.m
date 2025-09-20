function data = calculatell(data)
x = [data.depot{1};data.customer];
data.D = cell(1,2);
for i = 1 : 37
    data.D{1}(i,:) = round(distance(x(i,:),x,6378.1)*1000*1.5);
end
data.D{2} = data.D{1};
data.p2c = round(distance(data.park,[data.depot{1};data.customer],6378.1)*1000*1.5)';
data.p2c(2,:) = data.p2c;
data.time{1} = round(data.D{1}/data.v);
data.time{2} = round(data.D{2}/data.v);