function [route,arrtime] = vrptw(customer,demand,Q,tw,time,DPI,alpha,D)
    N = size(customer,1);
    cust = 2 : N+1;
    route = [];
    arrtime = zeros(1,N);
    satis = zeros(1,N);
    while ~isempty(cust)
        route = [route,1];
        [~,c] = min(D(1,cust));
        c = cust(c(1))-1;
        t = tw(c,2);
        cust_d = cust-1;
        q = repmat(Q,1,3);
        while ~isempty(cust_d)
            if Cr(demand(c,:),q) >= DPI && time_c(tw(c,:),t) >= alpha
                if route(end) == 1 
                    arrtime(c) = tw(c,2);
                    satis(c) = time_c(tw(c,:),t);
                else
                    arrtime(c) = t;
                    satis(c) = time_c(tw(c,:),t);
                end
                route = [route ,c+1];
                dem = demand(c,:);
                q = q - dem(end:-1:1);
                t = t + tw(c,5);
                cust_d(cust_d == c) = [];
                if isempty(cust_d)
                    break;
                else
                    [~,c] = min(D(c+1,cust_d));
                    c =cust_d(c(1));
                    t = t + time(route(end),c+1);
                end
            else
                cust_d(cust_d == c) = [];
                if isempty(cust_d)
                    break;
                else
                    t = t - time(route(end),c+1);
                    [~,c] = min(D(c+1,cust_d));
                    c = cust_d(c(1));
                    t = t + time(route(end),c+1);
                end
            end
        end
        for i = route
            cust(cust == i) = [];
        end
    end
end
                
                

        