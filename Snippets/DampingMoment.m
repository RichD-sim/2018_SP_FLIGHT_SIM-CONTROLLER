function C2 = DampingMoment(t,Rocket,Calpha,CP,Velocity)
% Give damping moment based on rocket geometry & motor caracteristics
%

%--------------------------------------------------------------------------
% 1 Intrasic parameter
%--------------------------------------------------------------------------
rho = 1.22; % Air density at launch pad [kg/m3]
[M,dMdt,Cm,dCmdt,I_L,dI_Ldt,I_R,dI_Rdt] = Mass_Properties(t,Rocket,'Linear');

%--------------------------------------------------------------------------
% 2 Subparameter
%--------------------------------------------------------------------------
%2.1 Thrust damping coefficient 
CR2 = dMdt*(Rocket.L-Cm).^2;

%2.2 Aerodynamic damping coefficient
CNa_Total = sum(Calpha.*(CP-Cm).^2);
CA2 = rho*Velocity*Rocket.Sm/2*CNa_Total;

%--------------------------------------------------------------------------
% 3 Total Damping Coefficient
%--------------------------------------------------------------------------
C2 = CR2+CA2;
end

