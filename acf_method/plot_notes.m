function plot_notes(notes,durations)
    note_str = strcat(notes,durations);
    %arrayfun(@(x) string(x),note_str)
    note_str = join(note_str, ' ')

    score = "\version ""2.24.3"" \fixed c' {\clef treble\time 4/4"+newline+note_str+newline+"}";

    ly = "..\..\lilypond-2.24.3-mingw-x86_64\lilypond-2.24.3\bin\lilypond.exe";
    filename = "score.ly";
    file = fopen(filename,'wt');
    fprintf(file,"%s",score);
    fclose(file);

    cmd = ly+" "+filename;
    system(cmd);
    system("score.pdf");           
end

