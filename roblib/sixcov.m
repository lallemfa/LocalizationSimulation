init;
axis([-15,15,-13,13]); hold on;
G1=eye(2,2);
G2=3*eye(2,2);
A1=[1 0;0 3];  
G3=A1*G2*A1'+G1;   
A2=[cos(pi/4) -sin(pi/4);sin(pi/4) cos(pi/4)]; 
G4=A2*G3*A2';         
G5=G4+G3;             
G6=A2*G5*A2';         


draw_ellipse([0;0],G1,0.9,'black');
draw_ellipse([0;0],G2,0.9,'blue',2);
draw_ellipse([0;0],G3,0.9,'black',3);
draw_ellipse([0;0],G4,0.9,'blue',4);
draw_ellipse([0;0],G5,0.9,'black',5);
draw_ellipse([0;0],G6,0.9,'blue',6);



