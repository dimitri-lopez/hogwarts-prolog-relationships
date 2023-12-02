% This is a minimally reproducible example doing what the constraint problem is
% asking for. It works great from my testing.
%
% Run using: swipl -s constraint.pl
%
% And then in the interpreter run:
% total_cost_constraint(Items).
%
% Pressing ";" will generate more items that satisfy. You know the drill...
% Sample facts representing items and their properties
item_property(apple, cost, 1).
item_property(book, cost, 5).
item_property(laptop, cost, 10).

subset([], []).
subset([H|T], [H|T1]):-
  subset(T,T1).
subset([_|T],T1):-
  subset(T, T1).

% Constraint: Total cost must be less than or equal to 15
total_cost_constraint(SelectedItems) :-
    findall(Item, item_property(Item, _, _), Items),
    subset(Items, SelectedItems),
    findall(Cost, (member(Item, SelectedItems), item_property(Item, cost, Cost)), Costs),
    sum_list(Costs, TotalCost),
    TotalCost =< 15.
