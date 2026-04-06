## ----------------------------------------------------------------------
## em_momentum_test.m  —  Momentum & energy in EM waves (Octave demo)
## ----------------------------------------------------------------------

function em_momentum_test()

  ## ---------- Physical constants ----------
  c0   = 299792458;        % m/s
  mu0  = 4*pi*1e-7;        % H/m
  eps0 = 1/(mu0*c0^2);     % F/m

  printf("\n=== Electromagnetic Wave Momentum Demo ===\n");
  printf("c = %.3e m/s   mu0 = %.3e   eps0 = %.3e\n\n", c0, mu0, eps0);

  ## ---------- Configuration ----------
  E0 = 100;                % field amplitude [V/m]
  f  = 1e7;                % frequency [Hz]
  T  = 1/f;                % period [s]
  nCycles = 5;
  Nper = 2000;

  ## Beam parameters for pressure example
  P_beam   = 1.0;          % beam power [W]
  A_beam   = 1e-4;         % beam area [m^2]
  I_beam   = P_beam / A_beam;  % intensity [W/m^2]

  ## ---------- Time base ----------
  tt = linspace(0, nCycles*T, nCycles*Nper).';
  omega = 2*pi*f;

  ## ---------- Fields ----------
  Ex = E0 * cos(omega * tt);
  Ey = zeros(size(tt));
  Bx = zeros(size(tt));
  By = Ex / c0;
  Sz = (1/mu0) * (Ex .* By);     % Poynting vector z-component
  u  = 0.5 * (eps0*Ex.^2 + By.^2/mu0);  % energy density

  ## ---------- Averages ----------
  u_avg = mean(u);
  S_avg = mean(Sz);
  g_avg = S_avg / c0^2;

  printf("Average energy density <u> = %.6e J/m^3\n", u_avg);
  printf("Average Poynting flux  <S> = %.6e W/m^2\n", S_avg);
  printf("Average momentum density <g> = <S>/c^2 = %.6e kg/(m^2·s)\n\n", g_avg);

  ## ---------- Radiation pressure ----------
  p_abs = I_beam / c0;      % absorber
  p_ref = 2*I_beam / c0;    % perfect mirror
  F_abs = p_abs * A_beam;
  F_ref = p_ref * A_beam;
  printf("Beam: P = %.3g W  area = %.3g m^2  I = %.6e W/m^2\n", P_beam, A_beam, I_beam);
  printf("Radiation pressure: absorber = %.6e Pa, mirror = %.6e Pa\n", p_abs, p_ref);
  printf("Force on absorber = %.6e N, mirror = %.6e N\n\n", F_abs, F_ref);

  ## ---------- Combined figure ----------
  figure(1); clf;
  subplot(3,1,1);
  plot(tt, Ex, 'b'); grid on;
  ylabel('E-field [V/m]');
  title('Electric field vs time');

  subplot(3,1,2);
  plot(tt, Sz, 'r'); grid on;
  ylabel('S_z [W/m^2]');
  title('Poynting vector (energy flux)');

  subplot(3,1,3);
  plot(tt, u, 'k'); grid on;
  xlabel('Time [s]');
  ylabel('Energy density [J/m^3]');
  title('Energy density');

  ## (Removed sgtitle for compatibility)
  printf("Simulation complete — graphs will stay open.\n");
  printf("Close them manually when done.\n\n");

  ## ---------- Keep figures open ----------
  set(0, "showhiddenhandles", "on");
  waitfor(findobj("type", "figure", "-not", "beingdeleted", "on"));

endfunction

## ---------- Run automatically ----------
em_momentum_test();
