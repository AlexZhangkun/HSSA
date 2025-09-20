function draw2(x) 
x = reshape([x.fit],2,(numel([x.fit]))/2);
plot(x(1,:),x(2,:),'r*','MarkerSize',8);
xlabel('f1'); ylabel('f2');
title('Pareto Optimal Front');