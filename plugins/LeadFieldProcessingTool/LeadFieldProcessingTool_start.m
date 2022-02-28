
%LeadFieldProcessingTool_start

zef.LeadFieldProcessingTool.app = LeadFieldProcessingTool_app;

%set initial values

if ~isfield(zef.LeadFieldProcessingTool, 'bank')
    zef.LeadFieldProcessingTool.bank=[];
end

zef.LeadFieldProcessingTool.bankSize=size(zef.LeadFieldProcessingTool.bank,2);

if zef.LeadFieldProcessingTool.bankSize>=1

    for zef_LeadfieldProcessingTool_startIndex=1:zef.LeadFieldProcessingTool.bankSize
         zef.LeadFieldProcessingTool.bankPosition=zef_LeadfieldProcessingTool_startIndex;

          if ~isfield(zef.LeadFieldProcessingTool.bank{zef_LeadfieldProcessingTool_startIndex}, 'lead_field_id')
            warning('old project data. IDs are set sequentially');
            [zef.lead_field_id,zef.lead_field_id_max] = zef_update_lead_field_id(zef.lead_field_id,zef.lead_field_id_max,'bank_oldData');
            zef.LeadFieldProcessingTool.bank{zef_LeadfieldProcessingTool_startIndex}.lead_field_id=zef.lead_field_id_max;
          end

        zef_LeadfieldProcessingTool_updateTable;
    end
    clear zef_LeadfieldProcessingTool_startIndex;
end

if ~isfield(zef, 'lf_tag')
    zef.lf_tag='';
end

zef.LeadFieldProcessingTool.app.currentLeadfield.Data={zef.lf_tag, zef.imaging_method_cell{zef.imaging_method}, size(zef.sensors, 1), size(zef.source_positions, 1), zef.lead_field_id};

%app functions
zef.LeadFieldProcessingTool.app.AddButton.ButtonPushedFcn='zef_LeadFieldProcessingTool_addCurrentData2bank';
zef.LeadFieldProcessingTool.app.loadTraButton.ButtonPushedFcn='zef_LeadfieldProcessingTool_loadTra';
zef.LeadFieldProcessingTool.app.Mag2GradButton.ButtonPushedFcn='zef_LeadfieldProcessingTool_mag2Grad';
zef.LeadFieldProcessingTool.app.replaceButton.ButtonPushedFcn='zef_LeadfieldProcessingTool_aux2current';

zef.LeadFieldProcessingTool.app.deleteButton.ButtonPushedFcn='zef_LeadfieldProcessingTool_delete';
zef.LeadFieldProcessingTool.app.CombineButton.ButtonPushedFcn='zef_LeadfieldProcessingTool_combine';
zef.LeadFieldProcessingTool.app.refreshButton.ButtonPushedFcn='zef_LeadfieldProcessingTool_refresh';

%zef.LeadFieldProcessingTool.app.currentLeadfield.CellEditCallback='zef_LeadfieldProcessingTool_currentTableUpdate';
zef.LeadFieldProcessingTool.app.BankTable.CellEditCallback='zef_LeadfieldProcessingTool_BankTableLabelUpdate';

% name type numSens numPos

%set fonts
%set(findobj(zef.GMMclustering.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);

