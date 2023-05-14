function [fnc_call, fnc_str, fnc_name] = zef_read_function_call(file_name)


[~,fnc_name,~] = fileparts(file_name);
fnc_str = '';
%fnc_name = '';
fnc_call = '';
s0=strtrim(fileread(file_name));
s = s0;
if not(isempty(s))
    c_aux = s(1);
    nline = regexp(s,'\n');
    n_line_counter = 0;
    while isequal(c_aux,'%')
        n_line_counter = n_line_counter + 1;
        s = s0(nline(n_line_counter)+1:end);
        c_aux = s(1);
    end

    m_1 = regexp(s,'function');
    if not(isempty(m_1))
        if isequal(lower(strtrim(s(1:m_1(1)+7))),'function')
            m_2 = regexp(s,'=');
            if isempty(m_2)
                m_2(1) = length(s);
            end
            m_3 = regexp(s,')');
            if isempty(m_3)
                m_3(1) = length(s);
            end
            m_4 = regexp(s,'\n');
            if isempty(m_4)
                m_4(1) = length(s);
            end
            m_5 = regexp(s,'(');
            if isempty(m_5)
                m_5(1) =  length(s);
            end
            if m_5(1) >= m_4(1)
                m_3(1)=m_4(1);
                m_5(1)=m_4(1);
            end
            if m_2(1) >= m_4(1)
                m_2(1)=m_1(1)+8;
            end

            fnc_str = strtrim(s(m_1(1):m_3(1)));
            %fnc_name = strtrim(s(m_2(1)+1:m_5(1)-1));
            fnc_call = strtrim(s(m_1(1)+8:m_3(1)));
        else
            fnc_call = fnc_name;
        end
    else
        fnc_call = fnc_name;
    end

end
end
