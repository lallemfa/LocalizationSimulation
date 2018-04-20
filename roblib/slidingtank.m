function slidingtank
%-----------------------------------------
    function  xdot  = f(x,u)   % state : x =(x,y,theta,v)
        xdot=[x(4)*cos(x(3)); x(4)*sin(x(3)); u(1); u(2)];
    end
%-----------------------------------------
    function u=control(x,w,dw,ddw,mode)
        A=[-x(4)*sin(x(3)) cos(x(3));
            x(4)*cos(x(3)) sin(x(3))];
        y=[x(1);x(2)];
        dy=[x(4)*cos(x(3));x(4)*sin(x(3))];
        if mode=='classic',
            ddy=(w-y)+2*(dw-dy)+ddw;
        else  % sliding mode
            ddy=100*sign(w-y+dw-dy);    
        end
        u = A\ddy;
    end
%-----------  Main  ------------
init;
x=[10;0;1;1]; 
dt=0.01; L=10;
E=[];
for t=0:dt:3,
    clf; axis([-30,30,-30,30]); axis square; hold on;
    s=0:0.01:50;  p=[L*cos(s);L*sin(3*s)];
    plot(p(1,:),p(2,:),'magenta');
    w = L*[cos(t); sin(3*t)];
    dw=L*[-sin(t);3*cos(3*t)];
    ddw=L*[-cos(t);-9*sin(3*t)];
    u=control(x,w,dw,ddw,'sliding'); % 'sliding' or 'classic'
    draw_tank(x,'red');    plot(w(1),w(2),'+red');
    x=x+f(x,u)*dt;
    E=[E,abs(x(1)-w(1))+abs(x(2)-w(2))];
    drawnow();
end;
figure(2)
plot(E);
end

