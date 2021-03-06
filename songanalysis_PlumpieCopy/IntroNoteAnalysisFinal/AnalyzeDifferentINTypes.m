function [] = AnalyzeDifferentINTypes(IntroNoteResults, PlotFeatCols)

% =========== Program usage ===============================================
% AnalyzeDifferentINTypes(IntroNoteResults, PlotFeatCols)
% Inputs:
% =========================================================================

% =========== Rationale for program =======================================
% Some birds start their motifs in multiple different ways at the beginning
% of a bout.
% This program is to analyze what happens when bouts start with different
% syllables other than INs.
% Two main questions being asked:
% 1) Are there properties of the syllables that precede motif onset that
% are conserved despite differences in the identities of the actual
% syllables?
% 2) Is the first motif syllable different depending on what preceded it?
% =========================================================================

% First, for each bout, pull out the repeated syllables just before song
% motif onset

for i = 1:length(IntroNoteResults.BoutDetails),
    RepeatedSylls{i} = find(IntroNoteResults.BoutDetails(i).labels(1:IntroNoteResults.MotifStartIndex(i)) == IntroNoteResults.SyllBeforeMotifs(i));
    if (length(RepeatedSylls{i}) > 1)
        NonContiguousSpacing = find(diff(RepeatedSylls{i}) > 1);
        if (~isempty(find(NonContiguousSpacing)))
            RepeatedSylls{i} = RepeatedSylls{i}((NonContiguousSpacing(end) + 1):end);
        end
    end
end

% Now plot the results out for the different features separately for each
% type of starting syllable

% First plot the features of the first motif syllable separately for each
% feature depending on what came just before it
MinNumber = 5;

AllFirstMotifSylls = [];
for i = 1:length(IntroNoteResults.SyllBeforeMotif),
    Trials = find(IntroNoteResults.SyllBeforeMotifs == IntroNoteResults.SyllBeforeMotif(i));
    NumTrials(i) = length(Trials);
    Index = 1;
    for j = 1:length(Trials),
        FirstMotifSyllFeats{i}(Index,:) = IntroNoteResults.BoutDetails(Trials(j)).Feats(IntroNoteResults.MotifStartIndex(Trials(j)),:);
        FirstMotifSyll{i}(Index) = IntroNoteResults.BoutDetails(Trials(j)).labels(IntroNoteResults.MotifStartIndex(Trials(j)));
        Index = Index + 1;
    end
    AllFirstMotifSylls = [AllFirstMotifSylls FirstMotifSyll{i}];
end

UniqueAllFirstMotifSylls = unique(AllFirstMotifSylls);

for i = 1:length(IntroNoteResults.SyllBeforeMotif),
    for j = 1:length(UniqueAllFirstMotifSylls),
        if (NumTrials(i) > MinNumber)
            ActualTrials = find(FirstMotifSyll{i} == UniqueAllFirstMotifSylls(j));
            MeanFeatValues{j}(i,:) = mean(FirstMotifSyllFeats{i}(ActualTrials,1:4));
            STDFeatValues{j}(i,:) = std(FirstMotifSyllFeats{i}(ActualTrials,1:4));
        else
            MeanFeatValues{j}(i,:) = FirstMotifSyllFeats{i}(1,1:4);
            STDFeatValues{j}(i,:) = zeros(1,4);
        end
    end
end

for k = 1:length(UniqueAllFirstMotifSylls),
    figure;
    hold on;
    set(gcf, 'Color', 'w', 'Position', [427 162 700 500]);

    FeatNames = [{'Duration (sec)'} {'Mean Log Amplitude (db)'} {'Mean Weiner Entropy'} {'Mean Frequency (Hz)'}];

    for i = 1:size(MeanFeatValues{k},2);
        subplot(2,2,i);
        Bar(i) = bar(MeanFeatValues{k}(find(NumTrials >= MinNumber), i));
        set(Bar(i), 'FaceColor', 'w', 'EdgeColor', 'k');
        hold on;
        errorbar(MeanFeatValues{k}(find(NumTrials >= MinNumber), i), STDFeatValues{k}(find(NumTrials >= MinNumber), i), 'ko');

        if (i == 1)
            Index = 1;
            for j = [find(NumTrials >= MinNumber)],
                text(Index - 0.5, MeanFeatValues{k}(j, i) + STDFeatValues{k}(j, i), ['(', num2str(NumTrials(j)), ')']);
                Index = Index + 1;
            end
        end
        set(gca, 'XTickLabel', mat2cell(IntroNoteResults.SyllBeforeMotif(find(NumTrials >= MinNumber)), 1, ones(1,length(find(NumTrials >= MinNumber)))));
        set(gca, 'FontSize', 14);
        ylabel(FeatNames{i}, 'FontSize', 14);
        BracketIndex = find(FeatNames{i} == '(');
        if (~iscell(IntroNoteResults.BoutDetails(1).SongFile))
            DotIndex = find((IntroNoteResults.BoutDetails(1).SongFile == '.') | (IntroNoteResults.BoutDetails(1).SongFile == '_'));
            BirdName = IntroNoteResults.BoutDetails(1).SongFile(1:(DotIndex - 1));
        else
            DotIndex = find((IntroNoteResults.BoutDetails(1).SongFile{1} == '.') | (IntroNoteResults.BoutDetails(1).SongFile{1} == '_'));
            BirdName = IntroNoteResults.BoutDetails(1).SongFile{1}(1:(DotIndex - 1));
        end

        if (~isempty(BracketIndex))
            title([BirdName, ': ', UniqueAllFirstMotifSylls(k), ': ', FeatNames{i}(1:BracketIndex(1)-1)], 'FontSize', 14);
        else
            title([BirdName, ': ', UniqueAllFirstMotifSylls(k), ': ', FeatNames{i}], 'FontSize', 14);
        end
    end
end
disp('Finished');