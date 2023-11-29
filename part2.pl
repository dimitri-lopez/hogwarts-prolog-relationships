:- [hogwarts].
:- [part2Helper].

%% sentence --> [has_item] | [request].
%% has_item --> [Person] has item [Item] that costs [Value] dollars, and occupies [Value] cubic feet.
%% request --> house_name, volume_constraint_type, price_constraint_type, price_amount.

%% person --> houseOf(_, Person).
%% item --> {a, b, c, ..., x, y, z}.
%% value --> {1, 2, 3, ...}.
%% house --> houseOf(House, _).
%% attributeValue --> Attribute, Comparison, Value, Unit.
%% comparison --> less_than | greater_than.
%% attribute --> total_price | total_volume.
%% unit --> dollars | cubic_feet.


%% parse_sentence(Sentence) :-
%% has_item --> [Person] has item [Item] that costs [Value] dollars, and occupies [Value] cubic feet.
%% has_item(Person, Item, Cost, Volume) --> Person, [has, item], Item, [that, costs], Cost, Volume.
has_item(Person, Item, Cost, Volume) --> [Person, has, item, Item, that, costs, Cost | Volume].
person(Person) --> [Person], houseOf(_, Person). % This doesn't work yet.
%% person(Person) --> [Name], {atom{Item}}.
%% item(Item) --> [Item], {atom(Item)}.

parse_lines([]) :-
    write("Finished parsing all the lines."),
    write("\n").
parse_lines([Sentence | _]) :-
    write("Original Sentence: "),
    write(Sentence),
    write("\n"),
    phrase(has_item(Person, Item, Cost, Volume), Sentence),
    write("Person: "), write(Person), nl,
    write("Item: "), write(Item), nl,
    write("Cost: "), write(Cost), nl,
    write("Volume: "), write(Volume), nl,
    write("\n").

    %% parse_lines(Lines).



% Hints:
%   for NLP parser make sure you match the type of the atom: 
%      it may come in handy that print and write are two different method of printing within prolog 

% Main 
main :-
    current_prolog_flag(argv, [DataFile|_]),
    open(DataFile, read, Stream),
    read_file(Stream,Lines), %Lines contain all the information within line split by spaces, comma and period.
    parse_lines(Lines),
    %% write(Lines),
    close(Stream).

