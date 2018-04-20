function snake
%----------------------------------------------
    function draw(x,u)
        clf(); hold on; axis([-2,10,-2,10]); axis square;
        theta=x(3);
        draw_tank([x(1);x(2);theta],'black',1/3);
        beta=atan(u(1)); delta=x(5);  % back trolley
        blade=[-0.4 0.4;0 0;1 1];
        R=[cos(theta),-sin(theta),x(1);sin(theta),cos(theta),x(2);0 0 1];
        blade=R*[cos(beta),-sin(beta), 1;sin(beta),cos(beta) 0;0 0 1]*blade;
        plot(blade(1,:),blade(2,:),'magenta','LineWidth',3);   % front blade
        theta2=theta+delta; x2=x(1)-cos(theta2); y2=x(2)-sin(theta2);
        draw_tank([x2;y2;theta2],'blue',1/3);
        drawnow();
    end
%-----------------------------------------------
    function  xdot  = f(x,u)
        theta=x(3);v=x(4);delta=x(5);
        xdot=[v*cos(theta); v*sin(theta); v*u(1); ...
            -(u(1)+sin(delta))*u(2)-v; -v*(u(1)+sin(delta))];
    end
%-------------------- Main -------------------
init; x=[0;0;2;0.1;0]; % x,y,theta,v,delta
dt=0.02; p1=0.5;p2=3;p4=5;
thetabar=pi/6;
for t=0:dt:10,
    p3=-sawtooth(x(3)-thetabar);    
    u1=p1*cos(p2*t)+p3;
    u=[u1;p4*sign(-x(4)*(u1+sin(x(5))))];
    x=x+f(x,u)*dt;
    draw(x,u);
end;
end