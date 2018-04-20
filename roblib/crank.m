function crank
%----------------------------------------------
    function draw()
        clf(); hold on; axis([-4,8,-4,8]); axis square;
        draw_circle(c,r,'black',2);
        plot(w(1),w(2),'ored') ;
        plot([0,z(1),y(1)],[0,z(2),y(2)],'magenta','LineWidth',3);
        drawnow();
    end
%-----------------------------------------------
init; x=[-1;1];
L1=4;L2=3;dt=0.01;c=[1;2];r=4;
for t=0:dt:10,
    z=L1*[cos(x(1));sin(x(1))];
    y=z+L2*[cos(x(1)+x(2));sin(x(1)+x(2))];
    w=c+r*[cos(t);sin(t)]; dw=r*[-sin(t);cos(t)];
    v=w-y+dw;
    A=[-y(2) , -L2*sin(x(1)+x(2)); y(1) , L2*cos(x(1)+x(2))];
    u=inv(A)*v;
    x=x+u*dt;
    draw();
end;
end