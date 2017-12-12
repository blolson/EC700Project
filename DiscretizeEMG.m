function [kEMG_SPIKES, kEMG_SPIKES_DISCRETIZED] = DiscretizeEMG(EMG_DATA)
%   Blade Olson, BU 12/8/17
   
    kEMG_SPIKES = zeros(length(EMG_DATA(:,1)),2);
    emg_spike_cell = cell(2,1);
    kEPSILON = 1e-3; % To avoid weird effects at bin edges
    kBINS = 2;

    for v = 1:2
        fprintf('DiscretizeEMG row:%d\n',v);
%         emg_diff_std = std(EMG_DATA(:,v));
%         emg_diff_mean = mean(mean(EMG_DATA(:,v)));
        kEMG_SPIKES(:,v) = EMG_DATA(:,v);
%         kEMG_SPIKES(kEMG_SPIKES > emg_diff_mean + emg_diff_std);
        emg_spike_cell{v,1} = Discretize(kEMG_SPIKES(:,v));
    end
    
%     binEdges = linspace(mean(emg_spike_cell{v,1}(:,1))-kEPSILON, max(emg_spike_cell{v,1}(:,1))+kEPSILON, kBINS+1);
    binEdges = linspace(min(emg_spike_cell{v,1}(:,1))-kEPSILON, max(emg_spike_cell{v,1}(:,1))+kEPSILON, kBINS+1);

    kEMG_SPIKES_DISCRETIZED = zeros(length(emg_spike_cell{1,1}),size(emg_spike_cell,1));
    for v = 1:2
        fprintf('Bin row:%d\n',v);
          
        for j = 1:(length(binEdges)-1)
            hits = emg_spike_cell{v,1}(:,1) >= binEdges(j) & emg_spike_cell{v,1}(:,1) < binEdges(j+1);
            kEMG_SPIKES_DISCRETIZED(hits, v) = j;
        end
    end
    
%     kEMG_SPIKES_DISCRETIZED = zeros(length(emg_spike_cell{1,1}),size(emg_spike_cell,1));
%     for v = 1:size(emg_spike_cell,1)
%         kEMG_SPIKES_DISCRETIZED(:,v) = emg_spike_cell{v,1};
%     end
    
end