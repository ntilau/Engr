% skript zur Darstellung von Fehlern
clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setze Variablen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nr_of_ports = 16;

% setze Index der darzustellenden s-Matrix-Spalte
row = 1;

% setze Indexspanne der darzustellenden s-Matrix-Spaltenindices
col_start = 2;
col_end = 2;

% Frequenzbereich in Hertz
start_f = 30e3;
end_f = 100e6;

% Einteilung der Frequenzachse 'log' oder 'lin'
x_axis = 'log';

% s-Parameter neu laden?
load_s_params = 1;

hfss_path = 'W:\Bosch\hfss_sXp\s16p\standard_hi_res';
cst_path = 'W:\Bosch\fekoCST_sXp';
mor_path = 'E:\ykonkel\lte_solver\FCM4_simplified_16p\mor_system_matrices_5e6';
mor_sp_path = 'C:\ykonkel\Bosch\em_mor_sXp\singlepoint';
mor_mp_path = 'W:\Bosch\em_mor_sXp\s16p\multipoint';
ws_path = 'W:\Bosch\em_waveSolver_sXp\s16p\e';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lade s-Parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('file') || load_s_params
%     file{1} = sprintf('%s\\cst_s16p_base_mitDC.s%dp', cst_path, nr_of_ports);
    file{1} = sprintf('%s\\em_mor_mp_expPts_equalTo_evalPts.s%dp', mor_mp_path, nr_of_ports);
    file{2} = sprintf('%s\\sParam_e_dsweep_cmplt_hi_res.s%dp', ws_path, nr_of_ports);
%     file{2} = sprintf('%s\\sParam_av_veryhi_res_1_5e8_abc.s%dp', ws_path, nr_of_ports);
end
dum = cell(1,length(file));
for i = 1:length(file)
    dum{i} = TouchStone2DUM('', file{i});
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotte Datensaetze einer Zeile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% spezifikation der Linienfarben
line = {'-r' '-b' '-g' '-m'};

for n = col_start:col_end; % dum{1}.Nports
    col = n;
    figure(n);
    % Fehlerplot
    freq = to_hz(dum{1}.FrequencyUnits) * dum{1}.f;

    if strcmp(x_axis, 'log')
        loglog(freq, abs(dum{1}.S{row, col} - dum{2}.S{row, col}), line{1});
    else
        semilogy(freq, abs(dum{1}.S{row, col} - dum{2}.S{row, col}), line{1});
    end
    hold on;
    
    title_str = addslashes(sprintf('Abweichung %s - %s', dum{1}.Name, dum{2}.Name));
    title('Fehler HFSS - LTE\_MOR\_singlepoint');
    str_ylabel = addslashes(sprintf('|S_hfss(%d,%d) - S_mor(%d,%d)|', row, col, row, col));
    ylabel(str_ylabel);
    xlabel('freq (Hz)');

    xlim([start_f end_f]);
    grid on;
end






