function schuler
    function v=f(x,a)
    g=10;
    % x=[theta;alpha;dtheta;dalpha];
    v=[x(3);x(4);
       a/r;
       -a/r+((l2-l1)/(l1^2+l2^2))*(g*sin(x(2))-a*cos(x(2)))];
    end

    function draw(x)
        clf(); hold on; axis('off'); axis([-12,12,-12,12]); axis square;
        draw_circle([0;0],r,'black',2);
        theta=x(1);alpha=x(2);
        p=[r*cos(theta);r*sin(theta)];
        beta=alpha+theta;
        plot(p(1),p(2),'o red');
        plot([ p(1), p(1)-l1*cos(beta)], [p(2), p(2)-l1*sin(beta)],'blue');     % pendulum down
        plot([ p(1), p(1)+l2*cos(beta)], [p(2), p(2)+l2*sin(beta)],'red');     % pendulum high
        drawnow(); 
    end    

init; r=10;
l1=1;  l2=(-r+sqrt(r^2+4*(l1*r-l1^2)))/2;  
dt=0.05;
x=[1;1*0.2;0;0];	
for t=0:dt:100,
  a=randn(1);  
  %x=x+f(x,a)*dt; % with Euler 
  x=x+dt*(0.25*f(x,a)+0.75*(f(x+dt*(2/3)*f(x,a),a))); % with Runge Kutta
  draw(x);
end

end
