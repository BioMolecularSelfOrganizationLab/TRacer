classdef TRACEdata < handle
    %TRACEDATA class definition
    %   Holds extracted traces, metainformation and data about measurement
    
    properties
        
        % Ancestry:
        
        Parent
        
        % META information
        ExcitationColor
        ExcitationFrameTime
        ALEXindex % Index of Excitation
        
        % DATA
        Cumulated % Maximum Intensity / Cumulated single frame from data for this excitation color only
        
        TracesRaw % Raw traces as extracted
        TracesBackground %
        TracesCorrected % BG corrected intensity traces
        StepsFitFunction
        AuxiliarArray   % auxiliar array for step function
        RealStep
        MonomerNumber
        
        CategoryAnalysis    % array of #(categories) ANALYSISdata objects
        
        TracesCategory = '1' % trace category. 'Uncategorized' by default
        
        SNR = {} % signal to noise ratio from trace extraction
        Steps = {} % (bleach) intensity steps in these traces
        
        ManualSelection       % holds X Values of manually selected eval/bleach steps. 1 step: 0->step; 2 steps: start-> stop
        
    end
    
    methods
        % CLASS CONSTRUCTOR
        function C = TRACEdata(T, ind)
            C.Parent = T;       % assign parent property, so the class knows its heritage
            C.ALEXindex = ind;
            
        end
        
        function C = CalcCumulated(C,firstFrame,windowSize,mode)
            % calculate cumulated image with 15 frame moving avg window and display
            C.Cumulated = cumIMG(C.Parent.RawData,C.Parent.Parent.ALEXsequence,C.ALEXindex,firstFrame,windowSize,mode);
        end
        
        function C = FindSteps(C)
            if ~isempty(C.TracesCorrected)
                B = {};
                for i = 1:length(C.TracesCorrected)
                    try
                        B{i} = findBleachstep(C.TracesCorrected{i},'variance',10,1);
                    catch
                        B{i} = 0;
                    end
                end
                C.Steps = B;
            end
            
        end
        
        function C = CalcSNR(C)
            C.SNR =  [];
            m = 'woBG';
            switch m
                case 'classic'
                    for i = 1:length(C.TracesCorrected)
                        if C.Steps{i} > 0
                            m1 = mean(C.TracesCorrected{i}(1:C.Steps{i}));
                            m2 = mean(C.TracesBackground{i}(C.Steps{i}:end));
                            %m2 = mean(C.TracesBackground{79});
                            s = std(C.TracesCorrected{i}(1:C.Steps{i}));
                            C.SNR(i) = (m1-m2)/s;
                        else
                            C.SNR(i) = NaN;
                        end
                    end
                    
                case 'defBG'
                    for i = 1:length(C.TracesCorrected)
                        t = C.TracesCorrected{i} + C.TracesBackground{i};
                        m1 = mean(t);
                        m2 = mean(C.TracesBackground{15});
                        s = std(C.TracesCorrected{i});
                        C.SNR(i) = (m1-m2)/s;
                    end
                case 'woBG'
                    for i = 1:length(C.TracesCorrected)
                    t = C.TracesCorrected{i};
                    C.SNR(i) = mean(t)/std(C.TracesCorrected{i});
                    end;
            end
            
            if ~isempty(C.SNR)
                C.SNR(C.SNR(:)<0) = NaN;
                C.SNR(C.SNR(:) == -Inf) = NaN;
                nanmean(C.SNR)
                nanstd(C.SNR)
            end
            
        end
    end
    
end
