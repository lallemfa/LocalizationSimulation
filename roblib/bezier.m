function bezier
    function  xdot  = f(x,u)
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
%-----------------------------------------
    function y=b(i,n,t)
        y=prod(1:n)/(prod(1:i)*(prod(1:n-i)))*(1-t)^(n-i)*t^i;
    end
%-----------------------------------------
    function y=db(i,n,t)
        if (n==i),   y=n*t^(n-1);
        elseif (i==0),   y=-n*(1-t)^(n-1);
        else   y=prod(1:n)/(prod(1:i)*(prod(1:n-i)))*...
                (i*(1-t)^(n-i)*t^(i-1)-(n-i)*(1-t)^(n-i-1)*t^i);
        end
    end
%-----------------------------------------
    function w=setpoint(t)
        w=0;
        for i=0:n,  w=w+b(i,n,t)*P(:,i+1);  end;
    end
%-----------------------------------------
    function dw=dsetpoint(t)
        dw=0;
        for i=0:n, dw=dw+db(i,n,t)*P(:,i+1); end;
    end
%-----------------------------------------
init; dt=0.1;
axis([-1 11 -1 11]); axis square; hold on;
A1=[2 4 2 ; 0 2 7 ];
A2=[7 8 3 ; 2 3 10];
fill(A1(1,:),A1(2,:),'black');
fill(A2(1,:),A2(2,:),'black');
P=[1 1  1 1  2    3  4 5  5 7 8  10  9 8;
    1 4  7 9  10  8  6 4  1 0 0  1  4 8];
n=length(P)-1;
plot(P(1,:),P(2,:),'oblack','LineWidth',4);
tmax=50; x=[0;0;0;1]; k=0;
for t=0:dt:tmax,
    w = setpoint(t/tmax);
    dw=(1/tmax)*dsetpoint(t/tmax);
    u=control(x,w,dw);
    if mod(k,10)==0, draw_tank(x,'black',0.1);  end
    plot(w(1),w(2),'.red');
    x=x+f(x,u)*dt;
    drawnow();
    k=k+1;
end;
end
