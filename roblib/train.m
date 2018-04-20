function train
%-----------------------------------------
    function  xdot  = f(x,u)   % state : x =(x,y,theta,v)
        xdot=[x(4)*cos(x(3)); x(4)*sin(x(3)); u(1); u(2)];
    end
%-----------------------------------------
    function u=control(x,w,dw)
        A=[-x(4)*sin(x(3)) cos(x(3));
            x(4)*cos(x(3)) sin(x(3))];
        y=[x(1);x(2)];
        dy=[x(4)*cos(x(3));x(4)*sin(x(3))];
        u = A\((w-y)+2*(dw-dy));
    end
%-----------  Main  ------------
init;
xa=[10;0;1;1]; xb=[0;0;1;2]; xc=[-10;0;1;3]; % a l'endroit
dt=0.02; l=6; Lx=15;Ly=7;
for t=0:dt:10,
    clf; axis([-30,30,-30,30]); axis square; hold on;
    s=0:0.01:2*pi;  p=[Lx*cos(s);Ly*sin(s)];
    plot(p(1,:),p(2,:),'magenta');
    wa = [ Lx*sin(0.1*t); Ly*cos(0.1*t)];
    dwa=[Lx*0.1*cos(0.1*t);-Ly*0.1*sin(0.1*t)];
    ua=control(xa,wa,dwa);
    wb=[xa(1)-l*cos(xa(3));xa(2)-l*sin(xa(3))];
    dwb=[xa(4)*cos(xa(3))+l*ua(1)*sin(xa(3)); xa(4)*sin(xa(3))-l*ua(1)*cos(xa(3))];
    ub=control(xb,wb,dwb);
    wc=[xb(1)-l*cos(xb(3));xb(2)-l*sin(xb(3))];
    dwc= [xb(4)*cos(xb(3))+l*ub(1)*sin(xb(3)); xb(4)*sin(xb(3))-l*ub(1)*cos(xb(3))];
    uc=control(xc,wc,dwc);
    draw_tank(xa,'red');    plot(wa(1),wa(2),'+red');
    draw_tank(xb,'blue');   plot(wb(1),wb(2),'+blue');
    draw_tank(xc,'black');  plot(wc(1),wc(2),'+black');
    xa=xa+f(xa,ua)*dt;
    xb=xb+f(xb,ub)*dt;
    xc=xc+f(xc,uc)*dt;
    drawnow();
end;
end

