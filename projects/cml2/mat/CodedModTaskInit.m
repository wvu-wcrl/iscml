function TaskState = CodedModTaskInit(CodedModParam)
% This function uses LinkSimulation class to simulate the performance of a coded-modulation communication system.
%
% CodedModParam is a structure defining simulation parameters.
% CodedModParam = struct(...
%     'CodeType', [],...        % Type of the channel code used.
%     ...                       % =00 (Recursive Systematic Convolutional (RSC) code).
%     ...                       % =01 (Non-Systematic Convolutional (NSC) code), =02 (Tail-biting NSC code).
%     ...                       % =20 (General LDPC code specified by its parity-check matrix in alist format saved in a file).
%     ...                       % =21 (DVBS2 LDPC code), =22 (WiMax LDPC code).
%     'AListFilePath', [],...   % FULL path to alist file containing the parity-check matrix of LDPC code.
%     'EffectiveRate', 1/2,...  % Effective rate of LDPC code for DVBS2 and WiMax standards.
%     'FrameSize', 64800,...    % Size of the code (number of code bits).
%     'WiMaxLDPCInd', [],...    % Selects either code �A� or code �B� for rates 2/3 and 3/4 of WiMax LDPC codes.
%     ...                       % =0 (code rate type �A�), =1 (code rate type �B�), =[empty array] (all other code rates).
%     'Generator', [],...       % Binary generator matrix for convolutional code.
%     'ConvDepth', [],...       % Wrap depth used for tail-biting convolutional decoding (Default is 6 times the constraint length).
%     'DataLength', [],...      % Message data length for convolutional codes.
%     'SNRType', 'Es/N0 in dB', ...
%     'SNR', [],...             % Row vector of SNR points in dB.
%     'MaxTrials', 1e9, ...     % A vector of integers (or scalar), one for each SNR point. Maximum number of trials to run per point.
%     'MaxBitErrors', 5e10*ones(size(SNR)), ...
%     'MaxFrameErrors', 100*ones(size(SNR)), ...
%     'minBER', 1e-5, ...
%     'minFER', 1e-5, ...
%     'RunTime', 300, ...       % Simulation time in Seconds.
%     'MaxIteration', 30,...    % Maximum number of message passing decoding iterations for LDPC decoding (Default MaxIteration=30).
%     'DecoderType', 0,...      % Message passing LDPC decoding algorithm: =0 (sum-product) (DEFAULT), =1 (min-sum), =2 (approximate min-sum).
%     'ModulationObj', [],...
%     'ModulationType', [],...  % Type of modulation as a STRING with exact name of desired modulation.
%     ...                       % ='BPSK' (DEFAULT),'QPSK','PSK','QAM','APSK','HEX','HSDPA','custom'.
%     'ModulationParam', [],... % ALL parameters of the selected modulation in the specified order as a STRING.
%     ...                       % For BPSK or QPSK or HEX=['SignalProb'].
%     ...                       % For PSK or QAM=['Order,MappingType,SignalProb'].
%     ...                       % For HSDPA or APSK=['Order,SignalProb'].
%     ...                       % For custom modulation='SignalSet,SignalProb'.
%     'DemodType', 0,...        % Type of max_star algorithm that is used in demaping.
%     ...                       % =0 (linear approximation to log-MAP) (DEFAULT), =1 (max-log-MAP) (i.e. max*(x,y) = max(x,y)).
%     ...                       % =2 (constant-log-MAP), =3 (log-MAP, correction factor from small nonuniform table and interpolation).
%     ...                       % =4 (log-MAP, correction factor uses C function calls).
%     'ZeroRandFlag', 0,...     % A binary flag which is used when input vector to the encoder DataBits is not given to Encode method of CodedModulation class.
%     	                        % =0 generate a vector of ALL ZEROS (Default), =1 generate a RANDOM vector of bits.
%     'RandSeed',1000*sum(clock));  % New seed for the random generator of current worker.
%
% For NORMAL frames in DVBS2 standard: EffectiveRate = 1/4, 1/3, 2/5, 1/2, 3/5, 2/3, 3/4, 4/5, 5/6, 8/9, 9/10.
% For SHORT  frames in DVBS2 standard: EffectiveRate = 1/4, 1/3, 2/5, 1/2, 3/5, 2/3, 3/4, 4/5, 5/6, 8/9.
% In DVBS2 standard: FrameSize=64800 for NORMAL frames (Default) or 16200 for SHORT frames.
%
% For WiMax LDPC code FrameSize = 576:96:2304 and EffectiveRate = 1/2, 2/3, 3/4, 5/6.

% First, set the path.
OldPath = SetPath();

if( ~isfield(CodedModParam, 'CodeType') || isempty(CodedModParam.CodeType) ), CodedModParam.CodeType = 21; end
if( ~isfield(CodedModParam, 'SNRType') || isempty(CodedModParam.SNRType) ), CodedModParam.SNRType = 'Es/N0 in dB'; end
if( ~isfield(CodedModParam, 'MaxTrials') || isempty(CodedModParam.MaxTrials) ), CodedModParam.MaxTrials = 1e9; end
if( ~isfield(CodedModParam, 'MaxBitErrors') || isempty(CodedModParam.MaxBitErrors) ), CodedModParam.MaxBitErrors = 5e10*ones(size(CodedModParam.SNR)); end
if( ~isfield(CodedModParam, 'MaxFrameErrors') || isempty(CodedModParam.MaxFrameErrors) ), CodedModParam.MaxFrameErrors = 100*ones(size(CodedModParam.SNR)); end
if( ~isfield(CodedModParam, 'minBER') || isempty(CodedModParam.minBER) ), CodedModParam.minBER = 1e-5; end
if( ~isfield(CodedModParam, 'minFER') || isempty(CodedModParam.minFER) ), CodedModParam.minFER = 1e-5; end
if( ~isfield(CodedModParam, 'RunTime') || isempty(CodedModParam.RunTime) ), CodedModParam.RunTime = 300; end
if( ~isfield(CodedModParam, 'MaxIteration') || isempty(CodedModParam.MaxIteration) ), CodedModParam.MaxIteration = 30; end
if( ~isfield(CodedModParam, 'DecoderType') || isempty(CodedModParam.DecoderType) ), CodedModParam.DecoderType = 0; end
if( ~isfield(CodedModParam, 'DemodType') || isempty(CodedModParam.DemodType) ), CodedModParam.DemodType = 0; end
if( ~isfield(CodedModParam, 'ZeroRandFlag') || isempty(CodedModParam.ZeroRandFlag) ), CodedModParam.ZeroRandFlag = 0; end
if( ~isfield(CodedModParam, 'RandSeed') || isempty(CodedModParam.RandSeed) ), CodedModParam.RandSeed = 1000*sum(clock); end

CheckPeriod = 10;   % Checking time in number of Trials to see if the time is up.

if( isfield(CodedModParam, 'ModulationObj') && ~isempty(CodedModParam.ModulationObj) )
    ModObj = CodedModParam.ModulationObj;
else
    if( ~isfield(CodedModParam, 'ModulationType') || isempty(CodedModParam.ModulationType) ), CodedModParam.ModulationType = 'BPSK'; end
    if( ~isfield(CodedModParam, 'ModulationParam') || isempty(CodedModParam.ModulationParam) ), CodedModParam.ModulationParam = '[]'; end
    if( strcmpi(CodedModParam.ModulationType,'custom') )
        ModGenStr = ['CreateModulation' '(' CodedModParam.ModulationParam ')'];
    else
        ModGenStr = [upper(CodedModParam.ModulationType) '(' CodedModParam.ModulationParam ')'];
    end
    ModObj = eval(ModGenStr);
end

ModOrder = ModObj.Order;

switch CodedModParam.CodeType
    case 00 % Recursive Systematic Convolutional (RSC) code.
        % Default generator matrix for convolutional code is the constituent code of UMTS turbo code.
        if( ~isfield(CodedModParam, 'Generator') || isempty(CodedModParam.Generator) ), CodedModParam.Generator = [1 0 1 1 ; 1 1 0 1]; end
        if( ~isfield(CodedModParam, 'DataLength') || isempty(CodedModParam.DataLength) ), CodedModParam.DataLength = 512; end
        ChannelCodeObject = ConvCode(CodedModParam.Generator, CodedModParam.DataLength, 0, CodedModParam.DecoderType);
    case 01 % Non-Systematic Convolutional (NSC) code.
        % Default generator matrix for convolutional code is the constituent code of UMTS turbo code.
        if( ~isfield(CodedModParam, 'Generator') || isempty(CodedModParam.Generator) ), CodedModParam.Generator = [1 0 1 1 ; 1 1 0 1]; end
        if( ~isfield(CodedModParam, 'DataLength') || isempty(CodedModParam.DataLength) ), CodedModParam.DataLength = 512; end
        ChannelCodeObject = ConvCode(CodedModParam.Generator, CodedModParam.DataLength, 1, CodedModParam.DecoderType);
    case 02 % Tail-biting NSC code.
        % Default generator matrix for convolutional code is the constituent code of UMTS turbo code.
        if( ~isfield(CodedModParam, 'Generator') || isempty(CodedModParam.Generator) ), CodedModParam.Generator = [1 0 1 1 ; 1 1 0 1]; end
        if( ~isfield(CodedModParam, 'DataLength') || isempty(CodedModParam.DataLength) ), CodedModParam.DataLength = 512; end
        if( ~isfield(CodedModParam, 'ConvDepth') || isempty(CodedModParam.ConvDepth) ), CodedModParam.ConvDepth = -1; end
        ChannelCodeObject = ConvCode(CodedModParam.Generator, CodedModParam.DataLength, 2, CodedModParam.DecoderType, CodedModParam.ConvDepth);
    case 20	% General LDPC code specified by its parity-check matrix in alist format saved in a file.
        if( ~isfield(CodedModParam, 'AListFilePath') || isempty(CodedModParam.AListFilePath) )
            % error('CodedModTaskInit:EmptyAListFilePath',...
            %    'The FULL path to the alist file containing the parity-check matrix of LDPC code should be specified.');
            CodedModParam.AListFilePath = input('What is the FULL path to the ALIST file representing the parity-check matrix of your LDPC code?\n\n','s');
        end
        ChannelCodeObject = LDPCCode( CodedModParam.AListFilePath, [], [], CodedModParam.MaxIteration, CodedModParam.DecoderType );
    case 21	% DVBS2 LDPC code.
        if( ~isfield(CodedModParam, 'EffectiveRate') || isempty(CodedModParam.EffectiveRate) ), CodedModParam.EffectiveRate = 1/2; end
        if( ~isfield(CodedModParam, 'FrameSize') || isempty(CodedModParam.FrameSize) ), CodedModParam.FrameSize = 64800; end
        ChannelCodeObject = LDPC_DVBS2(CodedModParam.EffectiveRate, CodedModParam.FrameSize, CodedModParam.MaxIteration, CodedModParam.DecoderType);
    case 22	% WiMax LDPC code.
        if( ~isfield(CodedModParam, 'EffectiveRate') || isempty(CodedModParam.EffectiveRate) ), CodedModParam.EffectiveRate = 1/2; end
        if( ~isfield(CodedModParam, 'FrameSize') || isempty(CodedModParam.FrameSize) ), CodedModParam.FrameSize = 576; end
        if( ~isfield(CodedModParam, 'WiMaxLDPCInd') || isempty(CodedModParam.WiMaxLDPCInd) ), CodedModParam.WiMaxLDPCInd = 0; end
        ChannelCodeObject = LDPC_WiMax(CodedModParam.EffectiveRate, CodedModParam.FrameSize, CodedModParam.WiMaxLDPCInd, ...
            CodedModParam.MaxIteration, CodedModParam.DecoderType);
end

CodedModObj = CodedModulation(ChannelCodeObject, ModOrder, CodedModParam.DemodType, CodedModParam.ZeroRandFlag);

SNRdB = 5;
ChannelObj = AWGN( ModObj, 10^(SNRdB/10) );

TaskParam = struct(...
    'CodedModObj', CodedModObj, ...            % Coded modulation object.
    'ChannelObj', ChannelObj, ...              % Channel object (Modulation is a property of channel).
    'SNRType', CodedModParam.SNRType, ...
    'SNR', CodedModParam.SNR, ...              % Row vector of SNR points in dB.
    'MaxTrials', CodedModParam.MaxTrials, ...  % A vector of integers (or scalar), one for each SNR point. Maximum number of trials to run per point.
    'RunTime', CodedModParam.RunTime, ...      % Simulation time in Seconds.
    'CheckPeriod', CheckPeriod, ...            % Checking time in number of Trials.
    'MaxBitErrors', CodedModParam.MaxBitErrors, ...
    'MaxFrameErrors', CodedModParam.MaxFrameErrors, ...
    'minBER', CodedModParam.minBER, ...
    'minFER', CodedModParam.minFER, ...
    'RandSeed', CodedModParam.RandSeed);

Link = LinkSimulation(TaskParam);
TaskState = Link.SingleSimulate();

TaskState.NumCodewords = Link.SimParam.CodedModObj.NumCodewords;
TaskState.DataLength = Link.SimParam.CodedModObj.ChannelCodeObject.DataLength;

RemovePath(OldPath);

end


function OldPath = SetPath()
% Determine the home directory.
OldPath = path;
% Pos = regexp(OldPath,pathsep);
% HomeDir = OldPath(1:Pos(1)-1);
HomeDir = fullfile(filesep,'rhome','pcs','projects','cml2');

addpath( fullfile(HomeDir, 'mat') );
% This is the location of the mex directory for this architecture.
addpath( fullfile( HomeDir, 'mex', lower(computer) ) );
end


function RemovePath(OldPath)
path(OldPath);
end