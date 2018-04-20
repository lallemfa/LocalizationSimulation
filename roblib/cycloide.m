function cycloide

    function  xdot  = f(x,u)   % state : x =(x,y,theta,v)
        theta=x(3);v=x(4);
        xdot=[v*cos(theta); v*sin(theta); u(1); u(2)];
    end

    function u=control(x,w,dw,ddw)
        v=0.25 *( w - [x(1);x(2)])+1*(dw - [x(4)*cos(x(3));x(4)*sin(x(3))])+ddw;
        A=[-x(4)*sin(x(3)), cos(x(3)); x(4)*cos(x(3)), sin(x(3))];
        u=inv(A)*v;
    end

init;
x=[10;10;0;2]; %x=[x,y,theta,v)
dt=0.1; R=15; f1=0.02;f2=0.12;
for t=0:dt:100,
    clf; axis([-30,30,-30,30]); axis square; hold on;
    w = R*[sin(f1*t)+sin(f2*t);cos(f1*t)+cos(f2*t)];
    dw = R*[f1*cos(f1*t)+f2*cos(f2*t);-f1*sin(f1*t)-f2*sin(f2*t)];
    ddw=R*[-f1*f1*sin(f1*t)-f2*f2*sin(f2*t);-f1*f1*cos(f1*t)-f2*f2*cos(f2*t)];
    u=control(x,w,dw,ddw);
    x=x+f(x,u)*dt;
    draw_tank(x,'black');    plot(w(1),w(2),'+red');
    drawnow();
end;
end

