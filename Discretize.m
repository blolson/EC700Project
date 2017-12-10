function mod_spike_train = Discretize(kRAW_SPIKE_TRAIN)
%   Blade Olson, BU 12/8/17
   
    kTIME_BIN_SIZE = 25;
  
    %1) create a zeros matrix that is 1/25th the length of the current matrix
    %2) for each 25-row window, make that window entry equal to the sum of
    %the 25 rows for that column
    %3) get max at the end and see if we have any window that is greater
    %than 1
    
    mod_spike_train = zeros(ceil(length(kRAW_SPIKE_TRAIN)/kTIME_BIN_SIZE), size(kRAW_SPIKE_TRAIN,2));
    
    for v = 1:size(mod_spike_train,2)
        for i = 0:size(mod_spike_train,1)
            raw_index = i*kTIME_BIN_SIZE + 1;
            raw_end = min((raw_index+kTIME_BIN_SIZE-1),length(kRAW_SPIKE_TRAIN));
            mod_spike_train(i+1,v) = sum(kRAW_SPIKE_TRAIN(raw_index:raw_end,v));
        end
        fprintf('Discretize column:%d, max:%d\n',v,max(mod_spike_train(:,v)));
    end
end