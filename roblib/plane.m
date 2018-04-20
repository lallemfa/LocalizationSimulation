function plane
    function u = control(x)
        phi=x(4);   theta=x(5);  psi=x(6);  v=norm(x(7:9));
        psibar=atan2(x(2),x(1))+0.5*pi+tanh(0.02*(norm(x(1:2))-rbar));
        thetabar=-0.3*tanh(0.1*(zbar-x(3)));
        phibar=tanh(2*sawtooth(psibar-psi));
        u=[  5*(1+tanh(vbar-v)); % throttle
            -0.3*(tanh(5*(thetabar-theta))+abs(sin(phi)));
            -0.3*tanh(phibar-phi)];
    end
%------------------------------------------------
    function draw(x,u)
        uleft=-u(2)+u(3);  uright=-u(2)-u(3);
        plane0=[0  0  6  0   0  0  0   1  6 0 ;
                0 -1  0  1  -1  0  0   0  0 0;
                0  0  0  0   0  0  1  0.2 0 0;
                1  1  1  1   1  1  1   1  1 1] ;
        e=0.5;
        aileron=[-e   0  0 -e -e; -e  -e  e  e -e;
                  0   0  0  0  0;  1   1  1  1  1];
        R=[eulermat(-x(4),-x(5),x(6)),[x(1);x(2);-x(3)];0 0 0 1];
        ailLeft=R*[eulermat(0,uleft(1),0),[0;1-e;0];0 0 0 1]*aileron;
        ailRight=R*[eulermat(0,uright(1),0),[0;e-1;0];0 0 0 1]*aileron;
        plane=R*plane0;
        plot3(plane(1,:),plane(2,:),plane(3,:),'blue');
        plot3(ailLeft(1,:),ailLeft(2,:),ailLeft(3,:),'red');
        plot3(ailRight(1,:),ailRight(2,:),ailRight(3,:),'red');
        plot3(plane(1,:),plane(2,:),0*plane(3,:),'black'); % shadow
        drawnow();
    end
%------------------------------------------------------
    function xdot=f(x,u)
        v=x(7:9); w=x(10:12); V=norm(v);
        alpha =  atan(x(9)/x(7));   beta=asin(x(8)/V); phi=x(4); theta=x(5);  psi=x(6);
        cf=cos(phi);sf=sin(phi); ct=cos(theta);st=sin(theta); tt=tan(theta);        
        sa=sin(alpha); ca=cos(alpha); cb=cos(beta);sb=sin(beta);
        Fa=0.002*V^2*...
            [  -ca*cb, ca*sb, sa; sb, cb, 0; -sa*cb, sa*sb, -ca]...
            *[4+(-0.3+10*alpha+10*w(2)/V+2*u(3)+0.3*u(2))^2+abs(u(2))+3*abs(u(3));
            -50*beta+10*(w(3)-0.3*w(1))/V;
            10+500*alpha+400*w(2)/V+50*u(3)+10*u(2)];        
        xdot=[eulermat(phi,theta,psi)*v;  
              [1,tt*sf, tt*cf; 0,cf,-sf; 0,sf/ct ,cf/ct]*w;
                9.81*[-st;ct*sf;ct*cf]+Fa+[u(1);0;0]-cross(w,v);
               [-w(3)*w(2)+0.1*V^2*(-beta -2*u(3)+(-5*w(1)+w(3))/V);
                 w(3)*w(1)+0.1*V^2*(-0.1-2*alpha+0.2*u(3)-3*u(2)-30*w(2)/V);
                0.1*w(1)*w(2)+0.1*V^2*(beta+0.5*u(3)+0.5*(w(1)-2*w(3))/V)]
             ];
    end
%----------------  Main  ------------------------
init;
x=[0;0;-5;0;0;0;30;0;0;0;0;0]; %[x;y;z;phi;theta;psi;v;w]
rbar=100;  zbar=-50;   vbar=15; dt=0.02;
e=150;  clf;axis([-e,e,-e,e,-e,e]); axis square;hold on;
C0=[];
for t=0:0.1:2*pi,
    C0=[C0,[rbar*cos(t);rbar*sin(t);-zbar]];
end
plot3(C0(1,:),C0(2,:),C0(3,:),'green');
for k=0:50/dt,
    u=control(x);
    x=x+dt*f(x,u);
    if (mod(k,20)==0),  draw(x,u);  end
end
end