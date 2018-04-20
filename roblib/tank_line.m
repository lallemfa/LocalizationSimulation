function tank_line
    function xdot=f(x,u)
        theta=x(3);
        xdot=[cos(theta);sin(theta);u];
    end
init;
a=[-30;-4];b=[30;6];
x=[-20;-10;4];  % x,y,theta
dt=0.1;
for t=0:dt:50;
    clf(); hold on; axis([-30 30 -30 30]); axis square;
    phi=angle(b-a); m=x(1:2);
    e=det([b-a,m-a])/norm(b-a); % distance to the line
    thetabar=phi-atan(e);
    u=sawtooth(thetabar-x(3));
    x=x+f(x,u)*dt;
    draw_tank(x,'blue');
    plot([a(1);b(1)],[a(2);b(2)],'red');
    drawnow();
end
end

