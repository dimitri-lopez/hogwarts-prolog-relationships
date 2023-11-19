
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
isSeniorOf+(PersonA, PersonB):-
    directSeniorOf(PersonA, PersonB).
isSeniorOf+(PersonA, PersonB):-
    directSeniorOf(PersonA, Person),
    isSeniorOf+(Person, PersonB).
isSeniorOf(PersonA, PersonB):-
    isSeniorOf+(PersonA, PersonB).
listSeniors(Person, Seniors):-
    findall(Senior, isSeniorOf(Senior, Person), Seniors).
listJuniors(Person, Juniors):-
    findall(Junior, isSeniorOf(Person, Junior), Juniors).
isStudent(Person):-
    \+ isTeacher(Person).
isTeacher(Person):-
    teacherOf(Person, _).
isOlder(Person1, Person2):-
    Person1 \= Person2,
    birthYear(Person1, BirthYear1),
    birthYear(Person2, BirthYear2),
    BirthYear1 < BirthYear2.
isYounger(Person1, Person2):-
    Person1 \= Person2,
    birthYear(Person1, BirthYear1),
    birthYear(Person2, BirthYear2),
    BirthYear1 > BirthYear2.
oldestStudent(Person, House):-
    isStudent(Person),
    houseOf(House, Person),
    %% There does not exist a student in the house that is older.
    not(
        (
            houseOf(House, StudentInHouse),
            StudentInHouse \= Person,
            isOlder(StudentInHouse, Person)
        )
    ).
youngestStudent(Person, House):-
    isStudent(Person),
    houseOf(House, Person),
    %% There does not exist a student in the house that is younger.
    not(
        (
            houseOf(House, StudentInHouse),
            StudentInHouse \= Person,
            isYounger(StudentInHouse, Person)
        )
    ).
isQuidditchPlayer(Student):-
    quidditchTeamOf(_, Student).
oldestQuidditchStudent(Team, Student):-
    quidditchTeamOf(Team, Student),
    QuidditchPlayers = forall(Person, quidditchTeamOf(Team, Person)),
    not((
        member(Player, QuidditchPlayers),
        isOlder(Player, Student)
        )).
youngestQuidditchStudent(Team, Student):-
    quidditchTeamOf(Team, Student),
    QuidditchPlayers = forall(Person, quidditchTeamOf(Team, Person)),
    not((
            member(Player, QuidditchPlayers),
            isYounger(Player, Student)
        )).
rival(StudentOne, StudentTwo):-
    houseOf(House1, StudentOne),
    houseOf(House2, StudentTwo),
    House1 \= House2.
farRival(StudentOne, StudentTwo):-
    liveFarAway(StudentOne, StudentTwo).
