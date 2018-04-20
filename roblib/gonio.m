function gonio
    function xdot=f(x,u)
        xdot=[x(4)*cos(x(5))*cos(x(3));
            x(4)*cos(x(5))*sin(x(3));
            x(4)*sin(x(5))/3;
            u(1);u(2)];
    end;
    %--------------------------------------
    function [y,Gbeta,Ck]=g(x)
        Ck=[0,0,1]; y=x(4);  Gbeta=1;  %odometres
        for i=1:length(landmarks),
            a=landmarks(:,i);
            plot(a(1),a(2),'o black');
            da=a-x(1:2);
            delta=atan2(da(2),da(1))-x(3);
            if (norm(da)<15),
                yi=-a(1)*sin(x(3)+delta)+a(2)*cos(x(3)+delta);
                Cki=[-sin(x(3)+delta),cos(x(3)+delta),0];
                plot(a(1),a(2),'o red');
                y=[y;yi]; Ck=[Ck;Cki]; Gbeta=blkdiag(Gbeta,1);
            end;
        end;
        y=y+mvnrnd(zeros(size(y)),Gbeta)';
    end
%---------------------------------------------
    function onecar
        u=[0;0];
        x=[0;-20;pi/3;20;0.1];
        zhat=[0;0;0];
        Galpha=dt*0.001*eye(3,3);
        Gz=10^3*eye(3,3);
        for t=0:dt:10,
            clf; axis([-50,50,-50,50]); hold on;
            [y,Gbeta,Ck]=g(x);
            draw_car(x);
            Ak=eye(3,3)+dt*[0 0 cos(x(5))*cos(x(3)); 0 0 cos(x(5))*sin(x(3)); 0 0 0 ];
            uk=dt*[0;0;u(1)];
            [zhat,Gz]=kalman(zhat,Gz,uk,y,Galpha,Gbeta,Ak,Ck);
            draw_ellipse(zhat(1:2),Gz(1:2,1:2),0.9,'green',2);
            alphax=0*x;   alphax([1;2;4])=mvnrnd(zeros(3,1),Galpha)';
            x=x+f(x,u)*dt+alphax;
            drawnow();
        end;
    end;
    %----------------------------------------------------    
    function [yab,Gab,Cab]=gab(xa,xb)  % interaction between robots
        da=xb(1:2)-xa(1:2);  phi=atan2(da(2),da(1))-xa(3);
        yab=[];Gab=[];Cab=[];
        if (norm(da)<20),
            plot([xa(1),xb(1)],[xa(2),xb(2)],'red');
            Cab=[-sin(xa(3)+phi),cos(xa(3)+phi),0,sin(xa(3)+phi),-cos(xa(3)+phi),0];
            Gab=1; yab=mvnrnd(0,Gab);
        end;
    end
    %----------------------------------------------------    
    function [y,Gbeta,Ck]=gall(xa,xb)  % Observation function
        [ya,Ga,Cak]=g(xa);
        [yb,Gb,Cbk]=g(xb);
        [yab,Gab,Cabk]=gab(xa,xb);
        y=[ya;yb;yab];
        Gbeta=blkdiag(Ga,Gb,Gab);
        Ck=[blkdiag(Cak,Cbk);Cabk];
    end
    %----------------------------------------------------    
    function twocars
        ua=[0;0]; ub=[0;0]; 
        xa=[-13;-22;pi/3;15;0.1]; % initial state for robot A
        xb=[20;-10;pi/3;18;0.2]; % initial state for robot B
        zhat=zeros(6,1);  Gz=10^3*eye(6,6);                
        Galphaa=dt*diag([0.1,0.1,0.5]);  %state noise covariance
        Galpha=blkdiag(Galphaa,Galphaa)
        for t=0:dt:25,
            clf; axis([-50,50,-50,50]);   hold on;
            [y,Gbeta,Ck]=gall(xa,xb);
            draw_car(xa);  draw_car(xb);
            Aak=[1 0 dt*cos(xa(5))*cos(xa(3));  0 1 dt*cos(xa(5))*sin(xa(3)) ; 0 0 1 ];
            Abk=[1 0 dt*cos(xb(5))*cos(xb(3));  0 1 dt*cos(xb(5))*sin(xb(3)) ; 0 0 1 ];
            Ak=blkdiag(Aak,Abk)
            draw_ellipse(zhat(1:2),Gz(1:2,1:2),0.9,'magenta',2);
            draw_ellipse(zhat(4:5),Gz(4:5,4:5),0.9,'magenta',2);
            uk=dt*[0;0;ua(1);0;0;ub(1)];
            [zhat,Gz]=kalman(zhat,Gz,uk,y,Galpha,Gbeta,Ak,Ck);
            alphaa=0*xa; alphaa([1;2;4])=mvnrnd(zeros(3,1),Galphaa)';
            alphab=0*xb; alphab([1;2;4])=mvnrnd(zeros(3,1),Galphaa)';
            xa=xa+f(xa,ua)*dt+alphaa;
            xb=xb+f(xb,ub)*dt+alphab;
            drawnow();
        end;
    end
%-------    Main    --------
init;
dt=0.05;
landmarks=[0 15  30 15; 25  30  15 20];
%onecar;
twocars;
end




