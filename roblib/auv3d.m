function auv3d
    function u = control(x,w,dw,ddw)
        v=x(4); psi=x(5); theta=x(6); phi=x(7);
        ct=cos(theta); st=sin(theta);
        cf=cos(phi); sf=sin(phi); cp=cos(psi); sp=sin(psi);
        A=[ct*cp,-v*ct*sp,-v*st*cp;
            ct*sp, v*ct*cp,-v*st*sp;
            -st,     0    ,-v*ct]*[1 0 0;0 v*sf/ct v*cf/ct;0 v*cf,-v*sf];
        dp=v*[ct*cp; ct*sp; -st];
        p=x(1:3);
        u=A^(-1)*(0.04*(w-p) + 0.4*(dw-dp) +ddw);
    end
%------------------------------------------------
    function [w,dw,ddw] = setpoint(t)
        f1=0.01; f2=f1*6; f3=f1*3; R=20;
        w=R*[sin(f1*t)+sin(f2*t); cos(f1*t)+cos(f2*t);
            sin(f3*t)];
        dw=R*[f1*cos(f1*t)+f2*cos(f2*t);
            -f1*sin(f1*t)-f2*sin(f2*t); f3*cos(f3*t)];
        ddw=R*[-f1^2*sin(f1*t)-f2^2*sin(f2*t);
            -f1^2*cos(f1*t)-f2^2*cos(f2*t); -f3^2*sin(f3*t)];
    end
%------------------------------------------------
    function draw(x,w)
        clf;axis([-25,25,-15,25,-10,25]);
        axis square;hold on;
        Auv0=[ 0  0  10  0   0   10   0   0 ;
            -1  1   0 -1  -0.2  0  0.2  1 ;
            0  0   0  0   1    0   1   0] ;
        w0=0.1*Auv0;
        Auv0=[Auv0;ones(1,length(Auv0))];
        w0  =[w0;ones(1,length(w0))]; % setpoint
        E=eulermat(x(7),x(6),x(5)); %phi,theta,psi
        R=[E,[x(1);x(2);x(3)];0 0 0 1];
        Rw=[E,[w(1);w(2);w(3)];0 0 0 1];
        Auv=R*Auv0; w1=Rw*w0;
        plot3(Auv(1,:),Auv(2,:),Auv(3,:),'blue');
        plot3(Auv(1,:),Auv(2,:),0*Auv(3,:),'black'); % shadow
        plot3(w1(1,:),w1(2,:),w1(3,:),'red'); % setpoint
        drawnow();
    end
%------------------------------------------------------
    function xdot = f(x,u)
        v=x(4); psi=x(5); theta=x(6); phi=x(7);
        ct=cos(theta); st=sin(theta); tt=tan(theta);
        cf=cos(phi); sf=sin(phi); cp=cos(psi); sp=sin(psi);
        xdot=[v*ct*cp;v*ct*sp;-v*st;u(1);
            (sf/ct)*v*u(2)+(cf/ct)*v*u(3);
            cf*v*u(2)-sf*v*u(3);
            -0.1*sf*ct+tt*(sf*v*u(2)+cf*v*u(3))];
    end
%----------------  Main  ------------------------
init; dt=0.1;
x=[0;0;0;0.1;0;0;0];
for t=0:dt:100,
    [w,dw,ddw] = setpoint(t);
    u=control(x,w,dw,ddw);
    x=x+dt*f(x,u);
    draw(x,w);
end
end

