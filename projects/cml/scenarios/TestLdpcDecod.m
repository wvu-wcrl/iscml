% File TestLdpcDecod
%
% This is a set of scenarios for the Coded Modulation Library.
%
% The simulations specified in this file are for the LDPC code
% used by the DVB-S2 standard.
%
% The purpose of these tests is to compute the performance of the modular
%  LDPC decoder implemenation
%
% Last updated on 11/16/2012

% determine where your root directory is
load( 'CmlHome.mat' );

% determine where to store your files
base_name = 'TestLdpcDecod';
if ispc
    data_directory = strcat( cml_home, '\output\', base_name, '\' );
else
    data_directory = strcat( cml_home, '/output/', base_name, '/' );
end
if ~exist( data_directory, 'dir' )
    mkdir(data_directory);
end

MINBER = 1e-5;

% Short
record = 1;
effective_rate = '1/4'; % since a short code, this is not the actual rate!
sim_param(record).comment = strcat( 'Rate= ', ' ', effective_rate, ' short DVB-S2 LDPC code w/ BFSK in AWGN, old LDPC impl' );
sim_param(record).sim_type = 'coded';
sim_param(record).code_configuration = 2; % LDPC
sim_param(record).ldpc_impl = 'old';   % specify ldpc implementation
sim_param(record).SNR = [0:0.5:30];
sim_param(record).SNR_type = 'Eb/No in dB';
sim_param(record).framesize = 16200; 
sim_param(record).parity_check_matrix = strcat( 'InitializeDVBS2(', effective_rate , ',', int2str( sim_param(record).framesize ), ')' );
sim_param(record).modulation = 'FSK';
sim_param(record).csi_flag = 2;
sim_param(record).mod_order = 2;
sim_param(record).channel = 'AWGN';
sim_param(record).bicm = 1;
sim_param(record).demod_type = 0; 
sim_param(record).linetype = 'k-';
sim_param(record).max_iterations = 30;
sim_param(record).decoder_type = 0;
sim_param(record).filename = strcat( data_directory, 'DVBS2shortRate1by4_bfsk_oldimpl.mat');
sim_param(record).reset = 0;
sim_param(record).max_trials = 1e9*ones( size(sim_param(record).SNR) );
sim_param(record).minBER = MINBER; 
sim_param(record).max_frame_errors = 50*ones( size(sim_param(record).SNR) );
sim_param(record).plot_iterations = sim_param(record).max_iterations;
sim_param(record).save_rate = 5;
sim_param(record).legend = strcat('M=', num2str(sim_param(record).mod_order), ',',...
                                   'BICM=', num2str(sim_param(record).bicm), ',',...
                                    'LDPC Impl=', sim_param(record).ldpc_impl);



record = 2;
effective_rate = '1/4'; % since a short code, this is not the actual rate!
sim_param(record).comment = strcat( 'Rate= ', ' ', effective_rate, ' short DVB-S2 LDPC code w/ BFSK in AWGN, new LDPC impl' );
sim_param(record).sim_type = 'coded';
sim_param(record).code_configuration = 2; % LDPC
sim_param(record).ldpc_impl = 'new';   % specify ldpc implementation
sim_param(record).SNR = [0:0.5:30];
sim_param(record).SNR_type = 'Eb/No in dB';
sim_param(record).framesize = 16200; 
sim_param(record).parity_check_matrix = strcat( 'InitializeDVBS2(', effective_rate , ',', int2str( sim_param(record).framesize ), ')' );
sim_param(record).modulation = 'FSK';
sim_param(record).csi_flag = 2;
sim_param(record).mod_order = 2;
sim_param(record).channel = 'AWGN';
sim_param(record).bicm = 1;
sim_param(record).demod_type = 0; 
sim_param(record).linetype = 'r-';
sim_param(record).max_iterations = 30;
sim_param(record).decoder_type = 0;
sim_param(record).filename = strcat( data_directory, 'DVBS2shortRate1by4_bfsk_newimpl.mat');
sim_param(record).reset = 0;
sim_param(record).max_trials = 1e9*ones( size(sim_param(record).SNR) );
sim_param(record).minBER = MINBER; 
sim_param(record).max_frame_errors = 50*ones( size(sim_param(record).SNR) );
sim_param(record).plot_iterations = sim_param(record).max_iterations;
sim_param(record).save_rate = 5;
sim_param(record).legend = strcat('M=', num2str(sim_param(record).mod_order), ',',...
                                   'BICM=', num2str(sim_param(record).bicm), ',',...
                                    'LDPC Impl=', sim_param(record).ldpc_impl);


record = 3;
effective_rate = '1/4'; % since a short code, this is not the actual rate!
sim_param(record).comment = strcat( 'Rate= ', ' ', effective_rate, ' short DVB-S2 LDPC code w/ 8-FSK in AWGN, old LDPC impl' );
sim_param(record).sim_type = 'coded';
sim_param(record).code_configuration = 2; % LDPC
sim_param(record).ldpc_impl = 'old';   % specify ldpc implementation
sim_param(record).SNR = [0:0.5:30];
sim_param(record).SNR_type = 'Eb/No in dB';
sim_param(record).framesize = 16200; 
sim_param(record).parity_check_matrix = strcat( 'InitializeDVBS2(', effective_rate , ',', int2str( sim_param(record).framesize ), ')' );
sim_param(record).modulation = 'FSK';
sim_param(record).csi_flag = 2;
sim_param(record).mod_order = 8;
sim_param(record).channel = 'AWGN';
sim_param(record).bicm = 1;
sim_param(record).demod_type = 0; 
sim_param(record).linetype = 'b-';
sim_param(record).max_iterations = 30;
sim_param(record).decoder_type = 0;
sim_param(record).filename = strcat( data_directory, 'DVBS2shortRate1by4_8fsk_oldimpl.mat');
sim_param(record).reset = 0;
sim_param(record).max_trials = 1e9*ones( size(sim_param(record).SNR) );
sim_param(record).minBER = MINBER; 
sim_param(record).max_frame_errors = 50*ones( size(sim_param(record).SNR) );
sim_param(record).plot_iterations = sim_param(record).max_iterations;
sim_param(record).save_rate = 5;
sim_param(record).legend = strcat('M=', num2str(sim_param(record).mod_order), ',',...
                                   'BICM=', num2str(sim_param(record).bicm), ',',...
                                    'LDPC Impl=', sim_param(record).ldpc_impl);





record = 4;
effective_rate = '1/4'; % since a short code, this is not the actual rate!
sim_param(record).comment = strcat( 'Rate= ', ' ', effective_rate, ' short DVB-S2 LDPC code w/ 8-FSK in AWGN, new LDPC impl' );
sim_param(record).sim_type = 'coded';
sim_param(record).code_configuration = 2; % LDPC
sim_param(record).ldpc_impl = 'new';   % specify ldpc implementation
sim_param(record).SNR = [0:0.5:30];
sim_param(record).SNR_type = 'Eb/No in dB';
sim_param(record).framesize = 16200; 
sim_param(record).parity_check_matrix = strcat( 'InitializeDVBS2(', effective_rate , ',', int2str( sim_param(record).framesize ), ')' );
sim_param(record).modulation = 'FSK';
sim_param(record).csi_flag = 2;
sim_param(record).mod_order = 8;
sim_param(record).channel = 'AWGN';
sim_param(record).bicm = 1;
sim_param(record).demod_type = 0; 
sim_param(record).linetype = 'c-';
sim_param(record).max_iterations = 30;
sim_param(record).decoder_type = 0;
sim_param(record).filename = strcat( data_directory, 'DVBS2shortRate1by4_8fsk_newimpl.mat');
sim_param(record).reset = 0;
sim_param(record).max_trials = 1e8*ones( size(sim_param(record).SNR) );
sim_param(record).minBER = MINBER; 
sim_param(record).max_frame_errors = 50*ones( size(sim_param(record).SNR) );
sim_param(record).plot_iterations = sim_param(record).max_iterations;
sim_param(record).save_rate = 5;
sim_param(record).legend = strcat('M=', num2str(sim_param(record).mod_order), ',',...
                                   'BICM=', num2str(sim_param(record).bicm), ',',...
                                    'LDPC Impl=', sim_param(record).ldpc_impl);




record = 5;
effective_rate = '1/4'; % since a short code, this is not the actual rate!
sim_param(record).comment = strcat( 'Rate= ', ' ', effective_rate, ' short DVB-S2 LDPC code w/ 8-FSK in AWGN, new LDPC impl' );
sim_param(record).sim_type = 'coded';
sim_param(record).code_configuration = 2; % LDPC
sim_param(record).ldpc_impl = 'new';   % specify ldpc implementation
sim_param(record).SNR = [0:0.5:30];
sim_param(record).SNR_type = 'Eb/No in dB';
sim_param(record).framesize = 16200; 
sim_param(record).parity_check_matrix = strcat( 'InitializeDVBS2(', effective_rate , ',', int2str( sim_param(record).framesize ), ')' );
sim_param(record).modulation = 'FSK';
sim_param(record).csi_flag = 2;
sim_param(record).mod_order = 8;
sim_param(record).channel = 'AWGN';
sim_param(record).bicm = 2;
sim_param(record).demod_type = 0; 
sim_param(record).linetype = 'm-';
sim_param(record).max_iterations = 30;
sim_param(record).decoder_type = 0;
sim_param(record).filename = strcat( data_directory, 'DVBS2shortRate1by4_8fsk_newimpl_bicmid.mat');
sim_param(record).reset = 0;
sim_param(record).max_trials = 1e8*ones( size(sim_param(record).SNR) );
sim_param(record).minBER = MINBER; 
sim_param(record).max_frame_errors = 50*ones( size(sim_param(record).SNR) );
sim_param(record).plot_iterations = sim_param(record).max_iterations;
sim_param(record).save_rate = 5;
sim_param(record).legend = strcat('M=', num2str(sim_param(record).mod_order), ',',...
                                   'BICM=', num2str(sim_param(record).bicm), ',',...
                                    'LDPC Impl=', sim_param(record).ldpc_impl);

                                
plotme=0;
if (plotme == 1)
    CmlPlotTextBox({strcat('R=',sim_param(record).effective_rate)},...
        [0 0 0.1 0.1],...
         14,...
         1);
end