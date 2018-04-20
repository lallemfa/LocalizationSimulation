function dubins
    function xdot=f(x,u)
        xdot=[cos(x(3));sin(x(3));u];
    end
%  --------------Main----------------
x=[0;0;0.1];
dt=0.1;
init;
for t=0:dt:30;
    clf; axis([-20,20,-20,20]); axis square; hold on;
    thetabar=pi/2; % setpoint
    thetatilde=thetabar-x(3);    
    %u=sawtooth(thetatilde)/pi;          % u in [-1,1]    
    %u=sawtooth(thetatilde,1)/(2*pi);    % u in [0,1]   
    u=sawtooth(thetatilde,-1)/(2*pi)      % u in [-1,0]           
    x=x+f(x,u)*dt;
    draw_tank(x,'blue');
    drawnow();
end
end