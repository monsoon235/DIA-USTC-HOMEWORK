function phi = EVOLUTION_CV(I, phi0, mu, nu, lambda, delta_t, epsilon, numIter, g);
%   evolution_withoutedge(I, phi0, mu, nu, lambda_1, lambda_2, delta_t, delta_h, epsilon, numIter);
%   input: 
%       I: input image
%       phi0: level set function to be updated
%       mu: weight for length term
%       nu: weight for area term, default value 0
%       lambda:  weight for c1 fitting term
%       delta_t: time step
%       numIter: number of iterations
%   output: 
%       phi: updated level set function
%  
%   created on 04/26/2004
%   author: Chunming Li
%   email: li_chunming@hotmail.com
%   Copyright (c) 2004-2006 by Chunming Li


I = BoundMirrorExpand(I); % ¾µÏñ±ßÔµÑÓÍØ
phi = BoundMirrorExpand(phi0);
g = BoundMirrorExpand(g);
for k = 1 : numIter
    phi = BoundMirrorEnsure(phi);
    g = BoundMirrorEnsure(g);
    Curv = curvature(phi);
    
    fphi=(0.5/epsilon)*(1+cos(pi*phi/epsilon));
    DELTAPHI = fphi.*(phi<=epsilon)&(phi>=-epsilon);
    
    PHIxxyy = del2(phi);
 
    [gx,gy]=gradient(g);
    [phix,phiy]=gradient(phi); 

    norm=sqrt(phix.^2 + phiy.^2 + 1e-10);
    phixn=phix./norm;phiyn=phiy./norm;
    
    
    
    % updating the phi function
    phi=phi+delta_t*(mu*(4*PHIxxyy-Curv)+lambda*DELTAPHI.*(gx.*phixn+gy.*phiyn+g.*Curv)+nu*g.*DELTAPHI);    
end
phi = BoundMirrorShrink(phi); % È¥µôÑÓÍØµÄ±ßÔµ

