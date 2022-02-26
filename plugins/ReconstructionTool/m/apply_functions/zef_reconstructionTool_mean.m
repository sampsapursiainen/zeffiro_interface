function [newRec] = zef_reconstructionTool_mean(reconstruction)

newRec=reconstruction{:,1};

for frame=2:size(reconstruction,2)
    nextRec=reconstruction{:,frame};
    newRec=newRec+nextRec;
end
newRec=newRec/size(reconstruction,2);
newRec={newRec};

end

