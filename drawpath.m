function drawpath(x,y,z) 
x = reshape([x.fitness],2,(numel([x.fitness]))/2);
plot3(x(1,:),z(1,:),y(1,:),'r*','MarkerSize',8);
xlabel('f1'); ylabel('f2');zlabel('f3')
title('Pareto Optimal Front');

