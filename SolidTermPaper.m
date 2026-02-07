
% Parameters%

dt = 10^(-15);           % Step Size : 1fs
T_total = 12 * 10^(-12); % X Length : 12p sec
t = 0:dt:T_total;        % Vectorized t for calculations
N = length(t); %Number of dt's in T_total to assign values

% Constants
Temp = 300;                  % Temperature in Kelvins
q = 1.6 * 10^(-19);   % q
k = 1.38 * 10^(-23);    % Boltzmann
m0 = 9.11 * 10^(-31);  % m0
TimeLimit = [0 12];

% Initiate Simulation with initial conditions
w_init = 3/2*k*Temp;         % w0 approximated with 38meV with 3/2 kT/q as initial cond
w = zeros(1, N);      %Zero Buffer 
E_field = zeros(1, N);     % E-field Zero array 
v = zeros(1, N);      % Zero Buffer
m_m0 = zeros(1, N);
tp_plot = zeros(1, N);
tw_plot = zeros(1, N);
v(1) = 0;                  % Start from 0 to ensure 0 start
w(1) = w_init * q;
m_m0(1) = 1;

% Loop for chect every dt as index i
for i = 1:N-1 % Loop all dt's 
    t_ps = t(i) * 10^(12); % Unit is ps
    
    E_kVcm = 0; 
    % E-Field Values for corresponding t values
    if t_ps >= 0 && t_ps < 2
        E_kVcm = 8;
    elseif t_ps >= 2 && t_ps < 3
        E_kVcm = 1;
    elseif t_ps >= 3 && t_ps < 5
        E_kVcm = 12;
    elseif t_ps >= 5 && t_ps < 10
        E_kVcm = 1;
    elseif t_ps >= 10 && t_ps <= 12
        E_kVcm = 12;
    end
    
    % Convert E to SI Units (V/m)
   
    E_Vm = E_kVcm * 10^(5); %Unit in V/m
    E_field(i) = E_kVcm; % Vectorize the E-Field Values for Plotting
    
    % 2. Calculate Parameters based on current Energy w(i)
    
    % Convert to eV
    w_curr_eV = w(i) / q; 
   
    
   % Limit w values in an interval
    w_exp = w_curr_eV;
    if w_exp < 0.038
        w_exp = 0.038;
    elseif w_exp > 0.350
        w_exp = 0.350;
    end
   
    
    % Relaxation Times as in manueal (in terms of ps)
    % tau_p as in manuel
    tp_val = -29058.1 * w_exp^6 + 37288.3 * w_exp^5 - ...
    18885.1 * w_exp^4 + 4787.52 * w_exp^3 ... 
    - 635.55 * w_exp^2 + 41.0066 * w_exp - 0.74317;
             
    % tau_w as in manual
    tw_val = 5595.75 * w_exp^6 - 9458.1 * w_exp^5 ...
    + 7175.02 * w_exp^4 - 3066.82 * w_exp^3 + 703.821 * w_exp^2 ...
     - 71.1564 * w_exp + 3.80203;
             
    % Effective Mass in terms of m0
    m_ratio = 6.03057 * w_exp^5 - 13.478 * w_exp^4 ... 
    + 9.39288 * w_exp^3 - 1.907 * w_exp^2 ...
    + 0.389707 * w_exp + 0.0443495;

     m_m0(i) = m_ratio; 
     tp_plot(i) = tp_val;
     tw_plot(i) = tw_val;
    
    
    % Convert Parameters to SI
    m_kg = m_ratio * m0;  % m0 to kg
    w0_J = w_init * q; % eV to Joule Conversion w_init
    tau_p_SI = tp_val * 10^(-12); % ps to second
    tau_w_SI = tw_val * 10^(-12); % ps to sec

    dw_dt = (q * E_Vm * v(i)) - ((w(i) - w0_J) / tau_w_SI); % Derivative of w for current v and w values
    w(i+1) = w(i) + dt * dw_dt; % Create next variable by using derivative n current value (Euler method again)
    dv_dt = (q * E_Vm / m_kg) - (v(i) / tau_p_SI); % Derivative for current v value
    v(i+1) = v(i) + dt * dv_dt; % Euler method described in manuel
    % Equations as in the manuel note that derivative corresponds toformervalue in the loop so we don't need to index it%
    
end

t_ps_vector = t * 10^(12); %ps for visible plot
w_plot = w / q; %Joules to eV to better numbers
E_plot = E_field * 10^5; % kV/cm to V/m as in SI Units


% Plotting
figure;
subplot(3,1,1); 
plot(t_ps_vector, E_plot, 'r', 'LineWidth', 1.5);
xline([2,3,5,10])
title('Electric Field (V/m)');
xlabel('Time (ps)');
xlim(TimeLimit);
ylabel('E-Field (V/m)'); 


subplot(3,1,2);
plot(t_ps_vector, v , 'b', 'LineWidth', 1.5); 
xline([2,3,5,10])
title('Electron Drift Velocity (m/s)');
xlim(TimeLimit);
xlabel('Time (ps)');
ylabel('Velocity (m/s)'); 


subplot(3,1,3);
plot(t_ps_vector, w_plot, 'g', 'LineWidth', 1.5); 
title('Average Electron Energy (eV)');
xline([2,3,5,10])
xlim(TimeLimit);
xlabel('Time (ps)');
ylabel('Energy (eV)'); 

figure;
subplot(3,1,1);
plot(t_ps_vector, m_m0,"Color" ,[0.85 0.3 0.1], 'LineWidth', 1.5); 
title('Effective Mass (m0)');
xline([2,3,5,10])
xlim(TimeLimit);
xlabel('Time (ps)');
ylabel('Effective Mass (m0)'); 

subplot(3,1,2);
plot(t_ps_vector, tp_plot, 'm', 'LineWidth', 1.5); 
title('𝜏_p (ps))');
xline([2,3,5,10])
xlim(TimeLimit);
xlabel('Time (ps)');
ylabel('Picoseconds (ps)'); 

subplot(3,1,3);
plot(t_ps_vector, tw_plot, 'y', 'LineWidth', 1.5); 
title('𝜏_w (ps)');
xline([2,3,5,10])
xlim(TimeLimit);
xlabel('Time (ps)');
ylabel('Picoseconds (ps)'); 

