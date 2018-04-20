function anneal
function draw(p,y)
       clf; axis([-1,10,-1,8]); axis('square'); hold on;
       draw_tank(p,'blue',0.1);
       theta=p(3)+(0:7)'*pi/4;
       X=zeros(1,16); Y=X;
       X(1:2:15)=p(1);
       X(2:2:16)=p(1)+y.*cos(theta);
       Y(1:2:15)=p(2);
       Y(2:2:16)=p(2)+y.*sin(theta);
 	   plot(X,Y,'red','LineWidth',1);
           for i=1:length(A),
              plot([A(1,i) B(1,i)],[A(2,i) B(2,i)],'black','LineWidth',2);
           end           
end

function  y=f(p)
    y=inf(8,1);
	for i=1:8
  		u=[cos((i-1)*pi/4+p(3));sin((i-1)*pi/4+p(3))];
	  	m=[p(1);p(2)];
  		for j=1:length(A),
	    		a=A(:,j);
    			b=B(:,j);
    			if det([a-m u])*det([b-m u]) <= 0
      				alpha=-det([b-a m-a])/det([b-a u]);
      				if alpha >= 0
		        		y(i)=min(alpha,y(i));
      				end
    			end
  		end
  end
end

function  j1=j(p)
    j1=norm(y-f(p));
end    

init;
A=[0 7 7 9 9 7 7 4 2 0   5 6 6 5 ;...    % room
   0 0 2 2 4 4 7 7 5 5   2 2 3 3 ];
B=[7 7 9 9 7 7 4 2 0 0   6 6 5 5 ; ... 
   0 2 2 4 4 7 7 5 5 0   2 3 3 2];
y=[6.4;3.6;2.3;2.1;1.7;1.6;3.0;3.1];
p0=[0;0;0];  % initial guess
T=10;		% T= temperature
while (T>0.01)
        p=p0+T*randn(3,1);
     	draw(p,y);
        if j(p)<j(p0), p0=p; end;
   		T=0.999*T ;
        drawnow();
end

end