% skript zum plotten von S-Parametern
clear all;
close all;

addpath('..\idem_pcode');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setze Variablen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nr_of_ports = 16;

% setze Index der darzustellenden s-Matrix-Spalte
row = 1;

% setze Indexspanne der darzustellenden s-Matrix-Spaltenindices
col_start = 1;
col_end = 5;

% Frequenzbereich in Hertz
start_f = 1;
end_f = 500e6;

% Einteilung der Frequenzachse 'log' oder 'lin'
x_axis = 'log';

% s-Parameter neu laden?
load_s_params = 1;

hfss_path = 'W:\Bosch\hfss_sXp\s16p\standard_hi_res';
cst_path = 'W:\Bosch\fekoCST_sXp';
mor_path = 'E:\ykonkel\lte_solver\FCM4_simplified_16p\mor_system_matrices_5e6';
mor_sp_path = 'C:\ykonkel\Bosch\em_mor_sXp\singlepoint';
mor_mp_path = 'C:\ykonkel\Bosch\em_mor_sXp\s16p\multipoint';
ws_path = 'C:\ykonkel\Bosch\em_waveSolver_sXp\s16p\e';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lade s-Parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file{1} = sprintf('%s\\em_mor_mp_expPts_equalTo_evalPts.s%dp', mor_mp_path, nr_of_ports);
file{2} = sprintf('%s\\sParam_e_dsweep_cmplt_hi_res.s%dp', ws_path, nr_of_ports);
%     file{3} = sprintf('%s\\sParam_av_veryhi_res_1_5e8_abc.s%dp', ws_path, nr_of_ports);
%     file{4} = sprintf('%s\\cst_s16p_base_mitDC.s%dp', cst_path, nr_of_ports);

dum = cell(1,length(file));
for i = 1:length(file)
    dum{i} = TouchStone2DUM('', file{i});
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotte Datensaetze einer Zeile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cell array zum Erstellen der Legende
names = cell(1, length(file));
for i = 1:length(dum)
    names{i} = addslashes(dum{i}.Name);
end

% spezifikation der Linienfarben
line = {'-r' '-b' '-g' '-m'};

for n = col_start:col_end; % dum{1}.Nports
    col = n;
    figure(n);
    % Betragskennlinie
    subplot(2,1,1);
    for i = 1:length(dum)
        freq = to_hz(dum{i}.FrequencyUnits) * dum{i}.f;

        if strcmp(x_axis, 'log')
            semilogx(freq, db(abs(dum{i}.S{row, col})), line{i});
        else
            plot(freq, db(abs(dum{i}.S{row, col})), line{i});
        end
        hold on;
    end
    title('Betragskennlinie');
    str_ylabel = sprintf('S(%d,%d) (dB)', row, col);
    ylabel(str_ylabel);
    xlabel('freq (Hz)');
    legend(names, 'Location', 'SouthWest');
    xlim([start_f end_f]);
    grid on;
    
    % Phasenkennlinie
    subplot(2,1,2);
    for i = 1:length(dum)
        freq = to_hz(dum{i}.FrequencyUnits) * dum{i}.f;
        
        if strcmp(x_axis, 'log')
            semilogx(freq, 180 / pi * angle(dum{i}.S{row, col}), line{i});
        else
            plot(freq, 180 / pi * angle(dum{i}.S{row, col}), line{i});
        end
        hold on;
    end
    title('Phasenkennlinie');
    str_ylabel = sprintf('S(%d,%d) (deg)', row, col);
    ylabel(str_ylabel);
    xlabel('freq (Hz)');
    xlim([start_f end_f]);
    ylim([-180 180]);
    grid on;
    
end






