function [T, X, T1, X1, T2, X2] = Sim_1D_R02(Rocket, Env, tspan, x0, AB_drag, theta, EventType, EventVal, EventDir)

Option = odeset('RelTol', 1e-3, 'AbsTol', 1e-6);

switch(EventType)
    case 'Altitude'
        Option = odeset(Option, 'events', @AltEvent);
    case 'Velocity'
        Option = odeset(Option, 'events', @SpeedEvent);
    case 'None'
        Option = [];
    otherwise
        error(["Error: Invalid event argument. "...
        "In Sim_1D Event arguments are either "...
        "'Alitude', 'Velocity' or 'None'."]);
end

[T, X] = ode45(@(t,x) Rocket_Kinematic_R3(t, x, Rocket, Env, AB_drag, theta, 1.1, 1),...
               tspan, x0, Option);
[T1, X1] = ode45(@(t,x) Rocket_Kinematic_R3(t, x, Rocket, Env, AB_drag, theta, 1, 1),...
               tspan, x0, Option);
[T2, X2] = ode45(@(t,x) Rocket_Kinematic_R3(t, x, Rocket, Env, AB_drag, theta, 0.9, 1),...
               tspan, x0, Option);

    function [value, isterminal, direction] = AltEvent(T,X)
        %   Stop simulation at apogee
        value = (X(1)< EventVal)-0.5;   % altitude reaches beginning of burn phase
        isterminal = 1; % Stop the integration
        direction = EventDir;      
    end

    function [value, isterminal, direction] = SpeedEvent(T,X)
        %   Stop simulation at apogee
        value = X(2)-EventVal;   % altitude reaches beginning of burn phase
        isterminal = 1; % Stop the integration
        direction = EventDir;      
    end

end