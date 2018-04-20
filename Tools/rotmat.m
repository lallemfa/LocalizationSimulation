function R = rotmat(phi,theta,psi)
    cf = cos(phi);   sf = sin(phi);
    ct = cos(theta); st = sin(theta);
    cp = cos(psi);   sp = sin(psi);
    
    R = [ ct*cp  -cf*sp+st*cp*sf    sp*sf+st*cp*cf;
          ct*sp   cp*cf+st*sp*sf   -cp*sf+st*cf*sp;
           -st       ct*sf             ct*cf     ];
end

