#CPATH=".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar"
CPATH=".:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar"

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

echo "Loading: [     ]"
git clone --quiet $1 student-submission
echo -e "\e[1ALoading: [#    ]"

if ! [ -f student-submission/ListExamples.java ]
then
    echo "Wrong file submitted, check file name!"
    exit 1
fi

cp TestListExamples.java student-submission/ListExamples.java grading-area
cp -r lib grading-area

cd grading-area
echo -e "\e[1ALoading: [##   ]"
javac -cp $CPATH *.java
if [ $? -ne 0 ]
then
    echo "Compilation error, check your semicolons or brackets!"
    exit 1
fi

echo -e "\e[1ALoading: [###  ]"
java -cp ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples > grade-output.txt

echo -e "\e[1ALoading: [#### ]"
DIDFAIL=$(grep -c "FAILURES" grade-output.txt)
echo -e "\e[1ALoading: [#####] Done!"
if [ $DIDFAIL > 0 ]
then
    echo -e "\e[1AThere was a failed test."
    exit 1
fi
echo -e "\e[1AAll tests successful! :)"

