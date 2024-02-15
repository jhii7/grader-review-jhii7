CPATH=".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar"

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone --quiet $1 student-submission

if ! [ -f student-submission/ListExamples.java ]
then
    echo "Wrong file submitted"
    exit 1
fi

cp TestListExamples.java student-submission/ListExamples.java grading-area
cp -r lib grading-area

cd grading-area

javac -cp $CPATH *.java
if [ $? -ne 0 ]
then
    echo "Compilation error"
    exit 1
fi

java -cp ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples > grade-output.txt

DIDFAIL=$(grep -c "FAILURES" grade-output.txt)
if [ $DIDFAIL > 0 ]
then
    echo "There was a failed test."
    exit 1
fi
echo "All tests successful! :)"

