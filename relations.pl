
:- [hogwarts].

studentOf(Student, Teacher) :-
    teacherOf(Teacher, Student).

classmates(StudentOne, StudentTwo):-
    teacherOf(Teacher, StudentOne),
    teacherOf(Teacher, StudentTwo).
liveFarAway(StudentOne, StudentTwo):-
    houseOf(FirstHouse, StudentOne),
    houseOf(SecondHouse, StudentTwo),
    FirstHouse \= SecondHouse,
    farLocation(FirstHouse, SecondHouse).
isSeniorOf(PersonA, PersonB):- fail.
listSeniors(Person, Seniors):- fail.
listJuniors(Person, Juniors):- fail.
isStudent(Person):-
    \+ isTeacher(Person).
isTeacher(Person):-
    teacherOf(Person, _).
isOlder(Person1, Person2):-
    Person1 #\= Person2,
    birthYear(Person1, BirthYear1),
    birthYear(Person2, BirthYear2),
    BirthYear1 > BirthYear2.
oldestStudent(Person, House):-
    isStudent(Person).

youngestStudent(Person, House):- fail.
oldestQuidditchStudent(Team, Student):- fail.
youngestQuidditchStudent(Team, Student):- fail.
rival(StudentOne, StudentTwo):-
    houseOf(House1, StudentOne),
    houseOf(House2, StudentTwo),
    House1 \= House2.
farRival(StudentOne, StudentTwo):-
    liveFarAway(StudentOne, StudentTwo).
