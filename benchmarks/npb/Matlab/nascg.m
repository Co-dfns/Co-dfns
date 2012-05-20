function nascg(class)
%
% FUNCTION nascg(class)
% 
% Kernal CG: Solving an unstructured sparse linear system by the conjugate
% gradient method. From "The NAS Parallel Benchmarks", RNR Technical Report
% RNR-94-007, March 1994.  Coded by: Ben Buss, OSU
%
% INPUT(S):
%   class [optional] -- This code is set up to run one of any of the 5
%     specified classes of the problem.  The class may be passed in as an
%     agrument or entered when the menu prompts the user to enter the class.
%     Valid arguments are:
%      {'S','s',0} = Class S problem -- Sample to ensure code is error-free
%      {'W','w',1} = Class W problem -- Intended to run on workstations
%      {'A','a',2} = Class A problem
%      {'B','b',3} = Class B problem -- Not tested
%      {'C','c',4} = Class C problem -- Not tested
%
% Displayed to screen:
%     Header including CLASS, SIZE and number of ITERATIONS
%     For each iteration: ITERATION NUMBER, ||r||, and ZETA
%     An indication of completion
%     An indication of whether the checksum is correct or not
%     Calculated ZETA and ERROR
%     A summary table: CLASS, SIZE, ITERATIONS, TIME, Mop/s, OP TYPE,
%     SUCCESS/FAILURE, VERSION, and RUN DATE.
%
% REQUIRES vranlc.m to run <-- included in this file for this version, but
% will separate if a toolbox is created.


if nargin ~= 1,
    class=input('Please choose to run one of the following:\n (0) Class S\n (1) Class W\n (2) Class A\n (3) Class B\n (4) Class C\n');
end

switch class
    case {'S','s',0}
        class='S'; na=1400; niter=15; nonzer=7; shift=10; z_verify=8.5971775078648; runclass='Running Class S benchmark.';
    case {'W','w',1}
        class='W'; na=7000; niter=15; nonzer=8; shift=12; z_verify=10.362595087124; runclass='Running Class W benchmark.';
    case {'A','a',2}
        class='A'; na=14000; niter=15; nonzer=11; shift=20; z_verify=17.130235054029; runclass='Running Class A benchmark.';
    case {'B','b',3}
        class='B'; na=75000; niter=75; nonzer=13; shift=60; z_verify=22.712745482631; runclass='Running Class B benchmark.';
    case {'C','c',4}
        class='C'; na=150000; niter=75; nonzer=15; shift=110; z_verify=28.973605592845; runclass='Running Class C benchmark.';
end
rcond=0.1;

% Display to screen:
fprintf('\n %s \n\n','NAS Parallel Benchmarks in MATLAB-serial version - CG Benchmark')
fprintf(' %s\n',runclass)
fprintf(' %s %11d\n','Size:',na)
fprintf(' %s %5d\n\n','Iterations:',niter)

% Initialize random number generator:
seed=314159265; [rnd,seed]=vranlc(seed,1);

%%%%t0=clock; % Begin timer (MAKEA ONLY)

%%%%%%%%%%%%%%%%%%%
%%% BEGIN MAKEA %%%
%%%%%%%%%%%%%%%%%%%

% Make nn1 the smallest power of 2 that is greater than na
nn1=2.^(1:25);
ind=find(nn1>=na);
nn1=nn1(ind(1));             

% Initialize variables
A=sparse(na,na);
wi=1;
ratio=rcond^(1/na);
x=sparse(na,1); 

% Iterative loop to make A matrix
for j=1:na,
    nzv=0;    
    
    % Want the number of nonzero values in vector x to equal nonzer.
    while nzv<nonzer,
        % Pseudo-random generation of nonzero position and value.
        [ve,seed]=vranlc(seed,2);
        i=fix(nn1*ve(2))+1;
        
        % Only use the value if the position is in-bounds and empty.
        if (i<=na & x(i)==0), 
            x(i)=ve(1); 
            nzv=nzv+1;
        end
    end
    % Set the value of the position equating to the iteration number to 0.5
    x(j)=0.5; 
    
    % Specified creation of the A matrix.
A=A+wi*x*x'; 
    
    % Prepare the next weighting factor and clear x.
    wi=wi*ratio;
    x=x*0;
end
% Add (rcond-shift) to the diagonal of matrix A
A=A+(rcond-shift)*speye(size(A));
%%%-----------%%%
%%% END MAKEA %%%
%%%-----------%%%

% Clear unused variables
clear rcond rnd nzv ratio wi seed i nn1 nonzer ve ind x t0

%Display to screen:
fprintf('%15s %13s %22s\n','iteration','||r||','zeta')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% BEGIN INVERSE POWER METHOD %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize variables
x=ones(na,1);
t0=clock; % Begin timer.
% Iterative conjugate gradient loop
for it=1:niter,
    %% BEGIN CONJUGATE GRADIENT COMPUTATION %%%
    z=zeros(size(x));
    r=x;
    rho=r'*r;
    p=r;
    for i=1:25,
        q=A*p;
        alpha=rho/(p'*q);
        z=z+alpha*p;
        rho_0=rho;
        r=r-alpha*q;
        rho=r'*r;
        beta=rho/rho_0;
        p=r+beta*p;
    end
    % Compute residual norm explicitly: ||r||=||x-A*z||
    r_norm=sqrt((x-A*z)'*(x-A*z));
    %%% END CG COMPUTATION %%%
    xi=shift+1/(x'*z);

    % Print it, r_norm, & xi
    fprintf('%12d %25.12e %20.13f\n',it,r_norm,xi)
    x=z/sqrt(z'*z); 
end

% End timer.
benchmark_time_sec=etime(clock,t0);
%%%--------------------------%%%
%%% END INVERSE POWER METHOD %%%
%%%--------------------------%%%

% Display to screen:
fprintf(' %s\n','Benchmark completed')
if abs(xi-z_verify)>10^(-10),
    fprintf(' %s\n','VERIFICATION FAILED')
    verif='UNSUCCESSFUL';
else
    fprintf(' %s\n','VERIFICATION SUCESSFUL')
    verif='  SUCCESSFUL';
end
fprintf(' %s %11.12e\n','Zeta is',xi)
fprintf(' %s %10.12e\n\n\n','Error is',(xi-z_verify))

fprintf('%s\n',' CG Benchmark Completed.')
fprintf('%s %15s\n',' Class           = ',class)
fprintf('%s %15d\n',' Size            = ',na)
fprintf('%s %15d\n',' Iterations      = ',niter)
fprintf('%s %15.3f\n',' Time in seconds = ',benchmark_time_sec)
fprintf('%s %15s\n',' Mop/s total     = ','unknown')
fprintf('%s %15s\n',' Operation type  = ','floating point')
fprintf('%s %15s\n',' Verification    = ',verif)
fprintf('%s %15s\n',' Version         = ','MATLAB')
fprintf('%s %15s\n',' Run date        = ',date)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y,x] = vranlc(x,n)
%
%% FUNCTION: [y,x]=vranlc(x,n)
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