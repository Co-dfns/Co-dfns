function nasft(class)
%
% FUNCTION:  nasft(class)
% 
% Kernal FT: A 3-D fast-Fourier transform partial differential equation
% benchmark. From "The NAS Parallel Benchmarks", RNR Technical Report
% RNR-94-007, March 1994.  
% Function coded by: Benjamin J Buss, The Ohio State University (2004)
%
% INPUT(S):
%   class [optional] -- This code is set up to run one of any of the 5
%     specified classes of the problem.  The class may be passed in as an
%     agrument or entered when the menu prompts the user to enter the class.
%     Valid arguments are:
%      {'S','s',0} = Class S problem -- Sample to ensure code is error-free
%      {'W','w',1} = Class W problem -- Intended to run on workstations
%      {'A','a',2} = Class A problem
%      {'B','b',3} = Class B problem
%      {'C','c',4} = Class C problem -- Not tested
%
% Displayed to screen:
%     Header including CLASS, SIZE and number of ITERATIONS
%     For each iteration: ITERATION NUMBER and CHECKSUM (real and complex)
%     An indication of whether the checksum is correct or not
%     IF verification fails: "CORRECT" CHECKSUM
%     CLASS
%     A summary table: CLASS, SIZE, ITERATIONS, TIME, Mop/s, OP TYPE,
%     SUCCESS/FAILURE, VERSION, and RUN DATE.
%     
% REQUIRES vranlc.m to run <-- included in this file for this version, but
% will separate if a toolbox is created.

if nargin ~= 1,
    class=input('Please choose to run one of the following:\n (0) Class S\n (1) Class W\n (2) Class A\n (3) Class B\n (4) Class C\n');
end

t0=clock; % Begin timer.
switch (class)
    case (0)
        class='S'; n1=64; n2=64; n3=64; seed=314159265; N=6; runclass='Running Class S benchmark.';
    case (1)
        class='W'; n1=128; n2=128; n3=32; seed=314159265; N=6; runclass='Running Class W benchmark.';
    case (2)
        class='A'; n1=256; n2=256; n3=128; seed=314159265; N=6; runclass='Running Class A benchmark.';
    case (3)
        class='B'; n1=512; n2=256; n3=256; seed=314159265; N=20; runclass='Running Class B benchmark.';
    case (4)
        class='C'; n1=512; n2=512; n3=512; seed=314159265; N=20; runclass='Running Class C benchmark.';
end

% Display to screen:
fprintf('\n %s \n\n','NAS Parallel Benchmarks in MATLAB-serial version - FT Benchmark')
fprintf(' %s\n',runclass)
fprintf(' %s %3d%2s%3d%2s%3d\n','Size:',n1,'x',n1,'x',n1)
fprintf(' %s %5d\n\n','Iterations:',N)

% Random number generator:
r=vranlc(seed,2*n1*n2*n3);

% Assign to complex matrix.
U=zeros(n1,n2,n3);
U(1:n1*n2*n3)=complex(r(1:2:end),r(2:2:end));

% Clear variables to free up memory
clear r seed;

% Take 3D FFT using built-in function.
U=fft(U,n1,1);                                    %%% 3D FFT %%%
U=fft(U,n2,2);                                    %%% 3D FFT %%%
V=fft(U,n3,3);                                    %%% 3D FFT %%%

% Clear variables to free up memory
clear U

% More required constants:
alpha=10^(-6);     t=1;

% Define indices j,k,l.  Use given definition for j_bar to calculate
% j_bar_sq=j_bar.^2 -- k_bar_sq and l_bar_sq follow.
j=0:n1-1; k=0:n2-1; l=0:n3-1;
j_bar_sq=[j(1:n1/2) j(n1/2+1:n1)-n1].^2;
k_bar_sq=[k(1:n2/2) k(n2/2+1:n2)-n2].^2;
l_bar_sq=[l(1:n3/2) l(n3/2+1:n3)-n3].^2;

% Set up a coordinate system.
[km,jm]=meshgrid(k,j);  % Is very large if use [km,jm,lm]=meshgrid(k,j,l)

% Exponential term for t=1.  The exponential term for other values of t is
% computed as exp_term.^t
exp_term=zeros(n1,n2,n3);
for l=1:n3,
    exp_term(:,:,l)=exp(-4*alpha*pi^2*(j_bar_sq(jm+1)+k_bar_sq(km+1)+l_bar_sq(l))*t);
end

% Clear variables to free memory
clear jm km lm j k l j_bar_sq k_bar_sq l_bar_sq alpha;

% Initialize checksum.
checksum=zeros(N,1);

% Iterate for required values of t.
while t<N+1,
    % Calculate W as specified.
    W=(exp_term.^t).*V;
    
    % Take 3D IFFT using built-in function.
    W=ifft(W,n1,1);                                  %%% 3D IFFT %%%
    W=ifft(W,n2,2);                                  %%% 3D IFFT %%%
    X=ifft(W,n3,3);                                  %%% 3D IFFT %%%
    
    % Clear W to free memory
    clear W;
    
    %COMPUTE CHECKSUM
    %     j=0:1023;
    %     checksum(t)=sum(X(mod(j,n1)+1,mod(3*j,n2)+1,mod(5*j,n3)+1));
    % Above method will not work because "Maximum variable size allowed by the
    % program is exceeded." even for small test case.
    
    % RESULT FOR BOTH CHECKSUMS BELOW IS THE SAME...BUT THE SECOND IS FASTER
    %     for j=0:1023,
    %        checksum(t)=checksum(t)+X(mod(j,n1)+1,mod(3*j,n2)+1,mod(5*j,n3)+1);
    %    end
    
    for j=1:1024,
        q=mod(j,n1)+1;
        r=mod(3*j,n2)+1;
        s=mod(5*j,n3)+1;
        checksum(t)=checksum(t)+X(q,r,s);
    end
    fprintf(' %s %1d %s %5.12e %20.12e\n','T = ',t,' Checksum = ',real(checksum(t)),imag(checksum(t)))        
    
    % Clear variables to free memory
    clear X;
    
    % Increment t.
    t=t+1;
end

benchmark_time_sec=etime(clock,t0); % End timer.

switch class
    case 'S'
        cs = [complex(554.6087004964,484.5363331978);
            complex(554.6385409189,486.5304269511);
            complex(554.6148406171,488.3910722336);
            complex(554.5423607415,490.1273169046);
            complex(554.4255039624,491.7475857993);
	        complex(554.2683411902,493.2597244941)];
    case 'W'
        cs = [complex(567.3612178944,529.3246849175);
            complex(563.1436885271,528.2149986629);
            complex(559.4024089970,527.0996558037);
            complex(556.0698047020,526.0027904925);
            complex(553.0898991250,524.9400845633);
	        complex(550.4159734538,523.9212247086)];
    case 'A'
        cs = [complex(504.6735008193,511.4047905510);
            complex(505.9412319734,509.8809666433);
            complex(506.9376896287,509.8144042213);
            complex(507.7892868474,510.1336130759);
            complex(508.5233095391,510.4914655194);
	        complex(509.1487099959,510.7917842803)];
    case 'B'
        cs = [complex(517.7643571579,507.7803458597);
            complex(515.4521291263,508.8249431599);
            complex(514.6409228649,509.6208912659);
            complex(514.2378756213,510.1023387619);
            complex(513.9626667737,510.3976610617);
            complex(513.7423460082,510.5948019802);
            complex(513.5547056878,510.7404165783);
            complex(513.3910925466,510.8576573661);
            complex(513.2470705390,510.9577278523);
            complex(513.1197729984,511.0460304483);
            complex(513.0070319283,511.1252433800);
            complex(512.9070537032,511.1968077718);
            complex(512.8182883502,511.2616233064);
            complex(512.7393733383,511.3203605551);
            complex(512.6691062020,511.3735928093);
            complex(512.6064276004,511.4218460548);
            complex(512.5504076570,511.4656139760);
            complex(512.5002331720,511.5053595966);
            complex(512.4551951846,511.5415130407);
	        complex(512.4146770029,511.5744692211)];
    case 'C'
        cs = [complex(519.5078707457,514.9019699238);
            complex(515.5422171134,512.7578201997);
            complex(514.4678022222,512.2251847514);
            complex(514.0150594328,512.1090289018);
            complex(513.7550426810,512.1143685824);
            complex(513.5811056728,512.1496764568);
            complex(513.4569343165,512.1870921893);
            complex(513.3651975661,512.2193250322);
            complex(513.2955192805,512.2454735794);
            complex(513.2410471738,512.2663649603);
            complex(513.1971141679,512.2830879827);
            complex(513.1605205716,512.2965869718);
            complex(513.1290734194,512.3075927445);
            complex(513.1012720314,512.3166486553);
            complex(513.0760908195,512.3241541685);
            complex(513.0528295923,512.3304037599);
            complex(513.0310107773,512.3356167976);
            complex(513.0103090133,512.3399592211);
            complex(512.9905029333,512.3435588985);
            complex(512.9714421109,512.3465164008)];
    otherwise
        cs = [0;0;0];
        disp('unknown class')
end

err_r = max(abs((real(checksum) - real(cs)) ./ real(cs)));
err_i = max(abs((imag(checksum) - imag(cs)) ./ imag(cs)));
err=complex(err_r,err_i);
if ((err_r<=10^-12) & (err_i<=10^-12))
    fprintf(' %s\n','Result verification successful.')
    verif='SUCCESSFUL';
else
    fprintf(' %s %f\n','VERIFICATION FAILED.  The correct checksum is: ',cs)
    verif='UNSUCCESSFUL';
end
fprintf('%s %s\n\n',' class =',class)

fprintf('%s\n',' FT Benchmark Completed.')
fprintf('%s %15s\n',' Class           = ',class)
fprintf('%s %5d%2s%3d%2s%3d\n',' Size            = ',n1,'x',n1,'x',n1)
fprintf('%s %15d\n',' Iterations      = ',N)
fprintf('%s %15.3f\n',' Time in seconds = ',benchmark_time_sec)
fprintf('%s %15s\n',' Mop/s total     = ','unknown')
fprintf('%s %15s\n',' Operation type  = ','floating point')
fprintf('%s %15s\n',' Verification    = ',verif)
fprintf('%s %15s\n',' Version         = ','MATLAB')
fprintf('%s %15s\n',' Run date        = ',date)

%%%%%=======================================================%%%%%
function [y,x] = vranlc(x,n)
%
%% FUNCTION:  [y,x]=vranlc(x,n)
%% INPUTS:
%%   x = seed
%%   n = number of pseudorandom numbers desired
%% OUTPUTS:
%%   y = vector of n pseudorandom numbers
%%   x = altered seed so the sequence can be continued
%%
%% THIS IS A DIRECT TRANSLATION TO MATLAB FROM THE FORTRAN VERSION SUCH 
%% THAT a=fix(5^13) IS DEFINED INTERNALLY.  THESE COMMENTS FROM THE FORTRAN
%% VERSION:
%c---------------------------------------------------------------------
%c
%c   This routine generates N uniform pseudorandom double precision numbers in
%c   the range (0, 1) by using the linear congruential generator
%c
%c   x_{k+1} = a x_k  (mod 2^46)
%c
%c   where 0 < x_k < 2^46 and 0 < a < 2^46.  This scheme generates 2^44 numbers
%c   before repeating.  The argument A is the same as 'a' in the above formula,
%c   and X is the same as x_0.  A and X must be odd double precision integers
%c   in the range (1, 2^46).  The N results are placed in Y and are normalized
%c   to be between 0 and 1.  X is updated to contain the new seed, so that
%c   subsequent calls to VRANLC using the same arguments will generate a
%c   continuous sequence.  If N is zero, only initialization is performed, and
%c   the variables X, A and Y are ignored.
%c
%c   This routine is the standard version designed for scalar or RISC systems.
%c   However, it should produce the same results on any single processor
%c   computer with at least 48 mantissa bits in double precision floating point
%c   data.  On 64 bit systems, double precision should be disabled.
%c
%c---------------------------------------------------------------------

      a=fix(5^13);
      y=zeros(n,1);
%%      integer i,n
%%      double precision y,r23,r46,t23,t46,a,x,t1,t2,t3,t4,a1,a2,x1,x2,z
%%      dimension y(*)
r23 = 0.5^23; r46 = r23^2; t23 = 2.0^23; t46 = t23^2;

%c---------------------------------------------------------------------
%c   Break A into two parts such that A = 2^23 * A1 + A2.
%c---------------------------------------------------------------------
      t1 = r23 * a;
      a1 = fix (t1);
      a2 = a - t23 * a1;

%c---------------------------------------------------------------------
%c   Generate N results.   This loop is not vectorizable.
%c---------------------------------------------------------------------
      for i = 1:n,

%c---------------------------------------------------------------------
%c   Break X into two parts such that X = 2^23 * X1 + X2, compute
%c   Z = A1 * X2 + A2 * X1  (mod 2^23), and then
%c   X = 2^23 * Z + A2 * X2  (mod 2^46).
%c---------------------------------------------------------------------
        t1 = r23 * x;
        x1 = fix (t1);
        x2 = x - t23 * x1;
        t1 = a1 * x2 + a2 * x1;
        t2 = fix (r23 * t1);
        z = t1 - t23 * t2;
        t3 = t23 * z + a2 * x2;
        t4 = fix (r46 * t3);
        x = t3 - t46 * t4;
        y(i) = r46 * x;
      end
      