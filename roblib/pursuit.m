function pursuit

function  xdot  = f(x,u)   % state : x =(x,y,theta)
xdot=[u(1)*cos(x(3)); u(1)*sin(x(3)); u(2)];
end


init;
xa=[-10;-10;0];
xb=[-5;-5;0];
dt=0.02;
for t=0:dt:50,
    clf(); hold on; axis([-30,30,-30,30]); axis square;           
    v=[3;sin(0.2*t)];     
    x=[cos(xa(3)),sin(xa(3)),0;-sin(xa(3)), cos(xa(3)),0;0,0,1]*(xb-xa);
    w=[10;0];   dw=[0;0];
    u=inv([-1 x(2);0 -x(1)])*(w-x(1:2)+dw-v(1)*[cos(x(3));sin(x(3))]);    
    draw_tank(xa,'blue');        draw_tank(xb,'red');    
    xa=xa+f(xa,u)*dt;
    xb=xb+f(xb,v)*dt;
    drawnow();
end;
end
