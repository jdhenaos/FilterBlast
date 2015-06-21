#!/bin/bash

formatdb -i ../Data/subject.fa -p F

blastall -p blastn -d ../Data/subject.fa -i ../Data/query.fa -o ../Data/query_subject.out -m 5

perl FiltroBlast.pl ../Data/query_subject.out

gedit ../Results/SignificativeFilter.out &
gedit ../Results/StudentPropose.out &
