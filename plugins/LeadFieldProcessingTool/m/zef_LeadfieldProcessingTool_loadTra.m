
[zef.LeadFieldProcessingTool.traName, zef.LeadFieldProcessingTool.traPath]=uigetfile('./', 'select tra file', '*.dat');

zef.LeadFieldProcessingTool.tra=readmatrix(strcat(zef.LeadFieldProcessingTool.traPath, zef.LeadFieldProcessingTool.traName));

