swipl -s part1Tester.pl -t main --quiet > part1Result.txt
swipl -s part2.pl  -t main --quiet -- example1.txt  > part2Result1.txt
passed=$(grep "Passed" part1Result.txt | wc -l)
failed=$(grep "Failed" part1Result.txt | wc -l)
total=$((passed + failed))
echo Diagnostics for part 1: $passed / $total
echo ------------------------------
echo Passed the following test cases: $passed / $total
grep "Passed" part1Result.txt
echo
echo Failed the following test cases: $failed / $total
grep "Failed" part1Result.txt


# For running part 2:
swipl -s part2.pl -t main --quiet -- example1.txt
