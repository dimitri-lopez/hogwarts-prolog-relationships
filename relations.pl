
:- [hogwarts].

studentOf(Student, Teacher) :-
    teacherOf(Teacher, Student).

classmates(StudentOne, StudentTwo):-
    teacherOf(Teacher, StudentOne),
    teacherOf(Teacher, StudentTwo).
liveFarAway(StudentOne, StudentTwo):- fail.
isSeniorOf(PersonA, PersonB):- fail.
listSeniors(Person, Seniors):- fail.
listJuniors(Person, Juniors):- fail.
oldestStudent(Person, House):- fail.
youngestStudent(Person, House):- fail.
oldestQuidditchStudent(Team, Student):- fail.
youngestQuidditchStudent(Team, Student):- fail.
rival(StudentOne, StudentTwo):- fail.
farRival(StudentOne, StudentTwo):- fail.
