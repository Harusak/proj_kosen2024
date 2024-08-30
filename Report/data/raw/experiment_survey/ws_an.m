clear;
files = dir('./*.csv');
file_name_cell={files.name};
file_name_string_array = string(file_name_cell);
numfile=length(file_name_string_array);
moony_ws = cell(numfile,1);
cnt= 1;
for i=1:numfile
    moony_ws{i} = readtable(file_name_string_array{i});
end

for i=1:numfile
    for j=1:40
        fig_face(j,i) = mean(moony_ws{i}.Likeface(moony_ws{i}.targetID ==j));
        fig_obj(j,i) = mean(moony_ws{i}.Likeobject(moony_ws{i}.targetID ==j));
    end
end
face_up = fig_face(1:20,:);
face_inv = fig_face(21:40,:);
gAve_like = mean(fig_face,2);
like_up = gAve_like(1:20);
like_inv = gAve_like(21:40);


files2 = dir('../result/*.csv');
file_name_cell2={files2.name};
file_name_string_array2 = string(file_name_cell2);
numfile2=length(file_name_string_array2);
moony_ex = cell(numfile2/2,1);

rej_flag = 1;

for i=1:numfile2
    if contains(file_name_string_array2{i},"EXP01") == 1
        moony_ex{i} = readtable(append('../result/',file_name_string_array2{i}));
        toDelete = moony_ex{i}.breakTime < 0.1 | moony_ex{i}.ans == "FALSE" | moony_ex{i}.breakTime == 999;
        moony_ex{i}(toDelete,:) = [];
    end
end

if rej_flag == 1
    for i=1:(numfile2/2)
        %Calculation of Mean and Standard Error
        exM_mean{1,i} = mean(moony_ex{i}.breakTime);
        exM_std{1,i} = std(moony_ex{i}.breakTime);
        %Calculation of 3sigma
        Tsigma_M{1,i} = exM_std{1,i}*3;
        %Delete 3sigma±mean
        toDeleteRJM = moony_ex{i}.breakTime <= exM_mean{1,i} - Tsigma_M{1,i} | moony_ex{i}.breakTime >= exM_mean{1,i} + Tsigma_M{1,i};
        moony_ex{i}(toDeleteRJM,:) = [];
        %Selection up and Inv
        moony_up{1,i} = moony_ex{i}.breakTime(moony_ex{i}.targetCategory == "Upright") ;
        moony_inv{1,i} = moony_ex{i}.breakTime(moony_ex{i}.targetCategory == "Inverted") ;
    end

end

% BT_fig = [];
for i=1:numfile2/2
    for j=1:40
        BT_fig(j,i) = mean(moony_ex{i}.breakTime(moony_ex{i}.targetID ==j));
    end
end
Gmean_fig = mean(BT_fig,2,"omitnan");
BT_up = BT_fig(1:20,:);
BT_inv = BT_fig(21:40,:);
BT_sub = BT_up ./ BT_inv;
img_No = 1:40;
% subju = [face_up(:,5) BT_up(:,11)];
% subji = [face_inv(:,5) BT_inv(:,11)];
%sub_sub = [face_up(:,5) BT_sub(:,11)];
% TU = array2table(subju,'VariableNames',{'facelike','meanBT'});
% Ti = array2table(subji,'VariableNames',{'facelike','meanBT'});
%Tsub = array2table(sub_sub,'VariableNames',{'facelike','meanBT'});
% figure("Name","scatter_face_up");
% S = scatter(TU,'facelike','meanBT','filled');
% figure("Name","scatter_face_inv");
% S2 = scatter(Ti,'facelike','meanBT','filled');

% subj01 = [fig_face(:,8) BT_fig(:,8)];
% % subj02 = [fig_obj(:,5) BT_fig(:,11)];
% subj = array2table(subj01,'VariableNames',{'facelike','meanBT'});
% % subj2 = array2table(subj02,'VariableNames',{'objectlike','meanBT'});
% figure("Name","scatter_face");
% S3 = scatter(subj,'facelike','meanBT','filled');
% hold on
% h1=lsline;
% h1.Color = 'r';
% hold off
%figure("Name","scatter_face_sub");
%S4 = scatter(Tsub,'facelike','meanBT','filled');
% 
% figure("Name","scatter_object");
% S2 = scatter(subj2,'objectlike','meanBT','filled');
gmean_subj = [gAve_like Gmean_fig];

[R,P] = corrcoef(gAve_like,Gmean_fig);
mdl = fitlm(gAve_like,Gmean_fig);

g = array2table(gmean_subj,'VariableNames',{'facelike','meanBT'});
figure("Name","scatter_gAve");
S5 = scatter(g,'facelike','meanBT','filled');
hold on
h2 = lsline;
h2.Color = 'r';
hold off