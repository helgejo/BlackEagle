function highscore = test4()
    try
        load('highscore_cannongame')
        highscore=highscore;
    catch
        h.lShots = zeros(1,10);
        h.tot3shots = zeros(1,10);
        h.tot5shots = zeros(1,10);
        h.tot7shots = zeros(1,10);
        h.tot10shots = zeros(1,10);
        highscore=h;
        save('highscore_cannongame','highscore');
    end
end

