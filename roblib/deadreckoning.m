function  deadreckoning
    function xdot=f(x,u)
        xdot=[x(4)*cos(x(5))*cos(x(3));
              x(4)*cos(x(5))*sin(x(3));
              x(4)*sin(x(5))/3;
              u(1);u(2)];
    end;
    %main
    dt=0.01;  
    x=[0;0;pi/3;4;0.3];
    zhat=[x(1);x(2);x(4)];
    Gz=zeros(3,3);
    Galphax=dt*diag([0 0 0.01 0.01 0.01]);
    Galphaz=dt*diag([0.01 0.01 0.01]);
    for t=0:dt:40,
       clf; hold on;
       axis([-50 50 -50 50]);  axis square;
       alphax=mvnrnd([0 0 0 0 0],Galphax)';
       ux=[0;0];  x=x+f(x,ux)*dt+alphax;
       uz=[0;0;dt*ux(1)];
       %y=[]; C=[]; Gbeta=[];  % without odometers
       y=x(4)+mvnrnd(0,0.1); C=[0 0 1]; Gbeta=0.1; % with odometers 
       Ak=[1 0 dt*cos(x(5))*cos(x(3));
           0 1 dt*cos(x(5))*sin(x(3));
           0 0 1];
       [zhat,Gz]=kalman(zhat,Gz,uz,y,Galphaz,Gbeta,Ak,C);       
       draw_ellipse(zhat(1:2),Gz(1:2,1:2),0.9,'black',2)
       draw_car(x);
       drawnow();
    end
end


