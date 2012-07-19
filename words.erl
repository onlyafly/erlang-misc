%% Kevin Albrecht
%% Program to generate words in secret language.

-module(words).

-export([root/1, particle/0]).

-define(V, ["a", "e", "i", "o", "u", "ay", "aw",
            "ä", "ë", "ï", "ö", "ü", "äy", "äw",
            "á", "é", "í", "ó", "ú", "áy", "áw"
           ]).
-define(C, ["m", "n", "ng", "p", "t", "k", "s", "z", "sh", "zh", "r", "ch", "tl"]).
-define(N, ["m", "n", "ng"]).
-define(F, ["m", "n", "ng", "s", "z", "sh", "zh", "r"]). % not p,t,k,ch,tl

seed() ->
    {A1, A2, A3} = now(),
    random:seed(A1, A2, A3).

root(Syllables) ->
    seed(),
    root_seeded(Syllables).
root_seeded(1) -> 
    makeSyllable(choose([v, vf, cv, cvf]));
root_seeded(Syllables) ->
    makeSyllable(choose([v, vn, cv, cvn])) ++ root_seeded(Syllables - 1).

particle() ->
    seed(),
    particle(choose([1,2])).
particle(0) ->
    "";
particle(Size) ->
    makeSyllable(choose([v, vc, cv, cvc])) ++ particle(Size - 1).

makeSyllable(v) -> choose(?V);
makeSyllable(vn) -> choose(?V) ++ choose(?N);
makeSyllable(vf) -> choose(?V) ++ choose(?F);
makeSyllable(vc) -> choose(?V) ++ choose(?C);
makeSyllable(cv) -> choose(?C) ++ choose(?V);
makeSyllable(cvn) -> choose(?C) ++ choose(?V) ++ choose(?N);
makeSyllable(cvf) -> choose(?C) ++ choose(?V) ++ choose(?F);
makeSyllable(cvc) -> choose(?C) ++ choose(?V) ++ choose(?C).

choose(Xs) ->
    Len = length(Xs),
    I = random:uniform(Len),
    lists:nth(I, Xs).
