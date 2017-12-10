function GTE = computeGTE(S)
%GTE = computeGE(F)
%GTE = computeGE(F, debug_)
% Baseline method to compute scores based on 
%    (Stetter 2013) Stetter, O., Battaglia, D., Soriano, J. & Geisel, T. 
%    Model-free reconstruction of excitatory neuronal connectivity from 
%    calcium imaging signals. PLoS Comput Biol 8, e1002653 (2012).
% Set flag debug_ to true to visualize histograms.

%==========================================================================
% Package: ChaLearn Connectomics Challenge Sample Code
% Source: http://connectomics.chalearn.org
% Authors: Javier Orlandi
% Date: Dec 2013
% Last modified: NA
% Contact: causality@chalearn.org
% License: GPL v3 see http://www.gnu.org/licenses/
%=========================================================================

%% Calculate the joint PDF
P = calculateJointPDFforGTE(S);

%% Calculate the GTE from the joint PDF
GTE = calculateGTEfromJointPDF(P);
