#! /bin/bash

#-----CONFIG-------
# characters in pattern file
HOT='$'		# Dark text
COLD='@'	# Light shadow
BLANK='~'	# Blank characters

# Number of commits
NO_HOT_COMMITS=100
NO_COLD_COMMITS=50
NO_BLANK_COMMITS=1

# URL of the repo to which dummy commits is pushed
REPO="git@github.com:arpith20/banner.git"
#------------------

DIR=`pwd`

# set git repo
rm -rf banner
mkdir banner
cd banner
git init
echo "# GitHubBanner" >> README.md
git add README.md
git remote add origin $REPO

# function to commit 
commit () {
	DATE2=$1
	TIMES=$2
	for (( i=0; i<$TIMES; i++ ))
	do
		COMMITDATE=`date -d"${DATE2}+${i} minutes" "+%a, %d %b %Y %H:%M:%S %z"`
		export GIT_COMMITTER_DATE="$COMMITDATE"
		git commit --date "$COMMITDATE" --allow-empty -m "$COMMITDATE"
	done
}

DAY=0;	# initialize to Sunday
CURRENTDATE=`date -d'last-sunday' $DATE_PATTERN`
WIDTH=`head -n 1 ${DIR}/pattern.txt | wc -m`
while read LINE; do
	DATE=`date -d"${CURRENTDATE}+${DAY} days" +%Y%m%d`
	for (( c=0; c<$WIDTH; c++ ))
	do
		DATECOMMIT=`date -d"${DATE}-$(($c-$WIDTH-1)) weeks" +%Y%m%d`
		CHAR=${LINE:$c:1}
		if [ "$CHAR" = "$HOT" ]; then
			commit $DATECOMMIT $NO_HOT_COMMITS
		fi
		if [ "$CHAR" = "$COLD" ]; then
			commit $DATECOMMIT $NO_COLD_COMMITS
		fi
		if [ "$CHAR" = "$BLANK" ]; then
			commit $DATECOMMIT $NO_BLANK_COMMITS
		fi
	done
	echo ""
	DAY=$((DAY+1))
done <${DIR}/pattern.txt

git push -f -u origin master