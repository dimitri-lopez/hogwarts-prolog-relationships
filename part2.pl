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
attribute(cost) --> [total, price].
attribute(volume) --> [total, volume].
unit(cost) --> [dollars].
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

% Generate all subsets of a list
subset([], []).
subset([H|T], [H|T1]):-
  subset(T,T1).
subset([_|T],T1):-
  subset(T, T1).

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
    write("Was able to parse house request!"), nl,

    findall([Item, Person, Cost, Volume], item_info(Item, Person, Cost, Volume), AllItems),
    write("AllItems: "), write(AllItems), nl,
    subset(AllItems, SelectedItems),
    findall(Cost, (member(Item, SelectedItems), nth0(2, Item, Cost)), Costs),
    write("Costs: "), write(Costs), nl,
    % NOTE: All I want to do on this line is sum up the costs in a list. Not
    % sure why uncommenting this line causes AllItems to infinitely grow in
    % size. Figure out this bug and you are basically done. See constraint.pl
    % for a minimally reproducible example.
    %
    %% sum_list(Costs, TotalCost), % LINE IN QUESTION
    %
    % Not sure how it is happening but perhaps the assert statement in
    % parse_item is being run multiple times? The subset function may be broken?
    % Though when trying it with constraint.pl it works fine as far as I can
    % tell. idk just some thoughts that I have had.
    %
    % Another thing to note. The findall state above creating AllItems is likely
    % storing way more information than it needs to. I think all it needs is the
    % ItemName and then in the constraint satisfaction you can all the items
    % using item_info(ItemName, _, _, _)
    %
    % Last little things in my brain noggin:
    % 1. There are multiple items with the same name but with different
    % properties. These should be treated as different items. See pdf expected
    % output for details
    % 2. subset produces an empty list as one of the examples. You probably want
    % to fix that or add another constraint that an empty list won't satisfy.
    % 3. Something that has saved me a lot of time on this hw is to start with
    % very small examples and then build up. I just dont know the intricasies of
    % the language enough to do otherwise. If you start running into issues I
    % would recommend doing likewise (like reduce the number of items and houses
    % in the input).
    %
    % You're smart you'll figure it out. Have fun :)
    %% fulfills_constraint(UnitType1, Comparison1, Value1, Items),
    %% fulfills_constraint(UnitType2, Comparison2, Value2, Items),

    write("Was able to find something that meets all the constraints"), nl,
    write("Items: "), write(SelectedItems), nl.

% NOTE: Not sure if any of the constraint stuff below works. I am pretty sure
% that it does however I just havent been able to test it properly.
fulfills_constraint(UnitType, Comparison, Value, Items) :-
    (UnitType == cost ->
         cost_constraint(Comparison, Value, Items) ;
         volume_constraint(Comparison, Value, Items)
    ).

cost_constraint(Comparison, Value, Items) :-
    write("Cost Constraint: "), write("Comparison: "), write(Comparison), write("Value: "), write(Value), nl,
    findall(Cost, (member(Item, Items), item_info(ItemName, _, Cost, _)), Costs),
    sum_list(Costs, TotalCost),
    (Comparison == less_than ->
         TotalCost < Value ;
         TotalCost > Value
    ).
volume_constraint(Comparison, Value, Items) :-
    findall(Volume, (member(Item, Items), item_info(ItemName, _, _, Volume)), Volumes),
    sum_list(Volumes, TotalVolume),
    (Comparison == less_than ->
            TotalVolume < Value ;
            TotalVolume > Value
    ).

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

