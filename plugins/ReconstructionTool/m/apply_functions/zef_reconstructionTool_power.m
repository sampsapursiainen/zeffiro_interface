function [newRec] = zef_reconstructionTool_power(reconstruction)

newRec=reconstruction{:,1};
newRec=newRec.^2;

for frame=2:size(reconstruction,2)
    nextRec=reconstruction{:,frame};
    newRec=newRec+nextRec.^2;
end
newRec=newRec/size(reconstruction,2);
newRec={newRec};

end

