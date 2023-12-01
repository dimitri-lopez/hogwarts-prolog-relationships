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
                     0 < Converted_Value
                 }.
has_item(Person, Item, Cost, Volume) -->
    person(Person), [has, item], item(Item), [that, costs], value(Cost), [dollars], comma,
    [and, occupies], value(Volume), [cubic, feet], period,
    {
        write("Person: "), write(Person), nl,
        write("Item: "), write(Item), nl,
        write("Cost: "), write(Cost), nl,
        write("Volume: "), write(Volume), nl
    }.

house(House) --> [House], {houseOf(House, _)}.
comparison(less_than) --> [less, than].
comparison(greater_than) --> [greater, than].
attribute(money) --> [total, price].
attribute(volume) --> [total, volume].
unit(money) --> [dollars].
unit(volume) --> [cubic, feet].
attribute_value(UnitType, Comparison, Value) --> attribute(UnitType), comparison(Comparison), value(Value), unit(UnitType).
house_request(House, UnitType1, Comparison1, Value1, UnitType2, Comparison2, Value2) -->
    house(House), [house, wants], attribute_value(UnitType1, Comparison1, Value1), [and], attribute_value(UnitType2, Comparison2, Value2), period.

parse_lines([]) :-
    write("Finished parsing all the lines."), nl.
parse_lines([Sentence | LinesToParse]) :-
    write("Original Sentence: "), write(Sentence), nl,
    (
        parse_item(Sentence) ->
        true ;
        parse_house_request(Sentence)
    ),
    parse_lines(LinesToParse).

parse_item(Sentence) :-
    phrase(has_item(Person, Item, Cost, Volume), Sentence),
    assert(
        item_info(Item, Person, Cost, Volume)
    ),
    write("Was able to parse item!"), nl.

parse_house_request(Sentence) :-
    phrase(house_request(House, UnitType1, Comparison1, Value1,
                         UnitType2, Comparison2, Value2),
           Sentence),
    write("House: "), write(House), nl,
    write("UnitType1: "), write(UnitType1), nl,
    write("Comparison1: "), write(Comparison1), nl,
    write("Value1: "), write(Value1), nl,
    write("UnitType2: "), write(UnitType2), nl,
    write("Comparison2: "), write(Comparison2), nl,
    write("Value2: "), write(Value2), nl,
    write("Was able to parse house request!"), nl.

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

