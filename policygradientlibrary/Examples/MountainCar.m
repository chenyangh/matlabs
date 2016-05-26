function MountainCar;
    hold on;
    nx=20;
    ndx = 50;
    for i=-1.2:(1.7/nx):0.5
        for j=-0.07:(0.14/ndx):+0.07
            x = [i j];
            arrow(x, (nextX(x, 0)-x));
        end;
    end; 

function xn = nextX(x,u)
    xn(2) = x(2)+0.001*u-0.0025*cos(3*x(1));
    xn(1) = x(1)+xn(2);
     