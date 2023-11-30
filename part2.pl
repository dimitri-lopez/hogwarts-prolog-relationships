:- [hogwarts].
:- [part2Helper].

% NOTE: This matches on a wild card. For the life of me I wasnt able to figure
% out how to match on the "blank" character.
period --> [_].
comma --> [_].

person(Person) --> [Person], {houseOf(_, Person)}.
item(Item) --> [Item], {catch(char_type(Item, lower), _, fail)}.
value(Value) --> [Value], {
                     atom(Value),
                     atom_number(Value, Converted_Value),
                     integer(Converted_Value),
                     0 < Converted_Value
                 }.
value(Value) --> [Value], {
                     atom(Value),
                     atom_number(Value, Converted_Value),
                     integer(Converted_Value),
                     0 < Converted_Value,
                     write("Value: "), write(Value), nl
                 }.
has_item(Person, Item, Cost, Volume) --> person(Person), [has, item], item(Item), [that, costs], value(Cost), [dollars, comma, and, occupies], value(Volume), [cubic, feet, period].

house(House) --> [House], {
                     houseOf(House, _),
                     write("Parsed House: "), write(House), nl
                 }.
comparison --> [less, than] | [greater, than].
attribute(money) --> [total, price].
attribute(volume) --> [cubic, feet].
unit(money) --> [dollars].
unit(volume) --> [cubic, feet].
attribute_value --> attribute(UnitType), comparison, value(_), unit(UnitType).
house_request --> house(House), [house, wants], attribute_value, [and], attribute_value, period.

parse_lines([]) :-
    write("Finished parsing all the lines."),
    write("\n").
parse_lines([Sentence | _]) :-
    write("Original Sentence: "),
    write(Sentence),
    write("\n"),
    %% phrase(has_item(Person, Item, Cost, Volume), Sentence),
    %% write("Person: "), write(Person), nl,
    %% write("Item: "), write(Item), nl,
    %% write("Cost: "), write(Cost), nl,
    %% write("Volume: "), write(Volume), nl,

    phrase(house_request, Sentence),
    write("Was able to parse!"), nl,
    write("\n").

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

