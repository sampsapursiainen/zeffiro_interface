function [amp] = GMM2amplitude(dipoles,ind,frame,type)
amp = ones(size(dipoles,1),1);
L = evalin('base','zef.L');
f = zef_getFilteredData;

f=zef_getTimeStep(f, frame, true);
n_interp = length(ind);
ind = [3*ind-2,3*ind-1,3*ind];
L = L(:,ind);

if type == 2
    if evalin('base','isfield(zef,''reconstruction_information'')')
        if evalin('base','isfield(zef.reconstruction_information,''snr_val'')')
            snr_val = evalin('base','zef.reconstruction_information.snr_val');
        elseif evalin('base','isfield(zef.reconstruction_information,''snr_val'')')
            snr_val = evalin('base','zef.reconstruction_information.snr_val');
        else
            snr_val = evalin('base','zef.inv_snr');
        end
    else
        snr_val = evalin('base','zef.inv_snr');
    end
    std_lhood = 10^(-snr_val/20)*max(abs(f),[],'all');
    C_prior = std_lhood./sqrt(sum(L.^2,1)');
    L = L.*transpose(reshape(dipoles,[],1));
    z = C_prior.*L'*((L*(C_prior.*L')+std_lhood^2*eye(size(L,1)))\f);
    amp = sqrt(z(1:n_interp).^2+z((1:n_interp)+n_interp).^2+z((1:n_interp)+2*n_interp).^2);
else
    L = L.*transpose(reshape(dipoles,[],1));
    z = pinv(L)*f;
    L = L(:,1:n_interp)+L(:,(1:n_interp)+n_interp)+L(:,(1:n_interp)+2*n_interp);
    amp = pinv(L)*f;
    while sum(amp<0)>0 && sum(amp>0)>0
        c_ind = amp>0;
        L = L(:,c_ind);
        amp(c_ind) = pinv(L)*f;
        amp(not(c_ind))=0;
    end
    if sum(amp<0)>0 || sum(amp>0)==0
        amp = sqrt(z(1:n_interp).^2+z((1:n_interp)+n_interp).^2+z((1:n_interp)+2*n_interp).^2);
    end
    
end


end


