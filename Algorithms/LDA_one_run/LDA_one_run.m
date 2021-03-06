% Runs a single LDA recognition result based on one sample from VS output
% directory, samp_dir

samp_dir = 'C:\Users\Beverly\Desktop\CD_VMGLite_1_4_0\CD_VMGLite_1_4_0\SDK\VMGLite_SDK_VS2013_v_1_2\Test_SDK_VS2013\MyFiles\Release';
distinct = 5;
input_dir = 'C:\Users\Beverly\Documents\GitHub\Hand_Gesture_Recognition\Grouped_Data';
test_samp = 5;
train_samp = 1;
rank = 8;
volunteers = 18;
% create training
[train,~,training_COL] = dataProducer(input_dir,train_samp,test_samp);
%create single sample
test = [];
filename = dir(fullfile(samp_dir,'output.csv'));
fullfile(samp_dir,filename.name);
test = csvread(fullfile(samp_dir, filename.name),1,1,[1,1,1,8]);
test = test.';
% pretty arbitrary for loop, no string parsing; all based on Grouped_Data
% folder format; group must be cell
for i = 1 : training_COL
    group(i,:) = cellstr((offset(i, train_samp,volunteers)));
end
lda = fitcdiscr(train.',group);
%label results 
[ldaClass, score, cost] =predict(lda,test.');

%convert back to char in order to use accuracy()
for i = 1 : training_COL
    char_group(i,:) = ((offset(i, train_samp,volunteers)));
end

%convert back to char in order to use accuracy()
temp = [];
for i= 1: 1
    if (strlength(char(ldaClass(i,:))) < 7) % # of char must add up to 7 'due to # of letters in pointer'
        temp = (char(ldaClass(i,:)));
        while (strlength(temp) < 7)
            temp = horzcat(temp, ' ');
        end
        char_ldaClass(i,:) = temp;
    else
        char_ldaClass(i,:) = char(ldaClass(i,:));
    end
end
fileID = fopen('recog.txt','w');
fprintf(fileID,char_ldaClass);
fclose(fileID);
