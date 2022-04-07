#!/bin/bash

# Not used atm
# Keep for future reference

IGNORE_TABLES_LIST=(
    matomo_archive_blob_2008_12
    matomo_archive_blob_2009_01
    matomo_archive_blob_2009_02
    matomo_archive_blob_2009_03
    matomo_archive_blob_2009_04
    matomo_archive_blob_2009_05
    matomo_archive_blob_2009_06
    matomo_archive_blob_2009_07
    matomo_archive_blob_2009_08
    matomo_archive_blob_2009_09
    matomo_archive_blob_2009_10
    matomo_archive_blob_2009_11
    matomo_archive_blob_2009_12
    matomo_archive_blob_2010_01
    matomo_archive_blob_2010_02
    matomo_archive_blob_2010_03
    matomo_archive_blob_2010_04
    matomo_archive_blob_2010_05
    matomo_archive_blob_2010_06
    matomo_archive_blob_2010_07
    matomo_archive_blob_2010_08
    matomo_archive_blob_2010_09
    matomo_archive_blob_2010_10
    matomo_archive_blob_2010_11
    matomo_archive_blob_2010_12
    matomo_archive_blob_2011_01
    matomo_archive_blob_2011_02
    matomo_archive_blob_2011_03
    matomo_archive_blob_2011_04
    matomo_archive_blob_2011_05
    matomo_archive_blob_2011_06
    matomo_archive_blob_2011_07
    matomo_archive_blob_2011_08
    matomo_archive_blob_2011_09
    matomo_archive_blob_2011_10
    matomo_archive_blob_2011_11
    matomo_archive_blob_2011_12
    matomo_archive_blob_2012_01
    matomo_archive_blob_2012_02
    matomo_archive_blob_2012_03
    matomo_archive_blob_2012_04
    matomo_archive_blob_2012_05
    matomo_archive_blob_2012_06
    matomo_archive_blob_2012_07
    matomo_archive_blob_2012_08
    matomo_archive_blob_2012_09
    matomo_archive_blob_2012_10
    matomo_archive_blob_2012_11
    matomo_archive_blob_2012_12
    matomo_archive_blob_2013_01
    matomo_archive_blob_2013_02
    matomo_archive_blob_2013_03
    matomo_archive_blob_2013_04
    matomo_archive_blob_2013_05
    matomo_archive_blob_2013_06
    matomo_archive_blob_2013_07
    matomo_archive_blob_2013_08
    matomo_archive_blob_2013_09
    matomo_archive_blob_2013_10
    matomo_archive_blob_2013_11
    matomo_archive_blob_2013_12
    matomo_archive_blob_2014_01
    matomo_archive_blob_2014_02
    matomo_archive_blob_2014_03
    matomo_archive_blob_2014_04
    matomo_archive_blob_2014_05
    matomo_archive_blob_2014_06
    matomo_archive_blob_2014_07
    matomo_archive_blob_2014_08
    matomo_archive_blob_2014_09
    matomo_archive_blob_2014_10
    matomo_archive_blob_2014_11
    matomo_archive_blob_2014_12
    matomo_archive_blob_2015_01
    matomo_archive_blob_2015_02
    matomo_archive_blob_2015_03
    matomo_archive_blob_2015_04
    matomo_archive_blob_2015_05
    matomo_archive_blob_2015_06
    matomo_archive_blob_2015_07
    matomo_archive_blob_2015_08
    matomo_archive_blob_2015_09
    matomo_archive_blob_2015_10
    matomo_archive_blob_2015_11
    matomo_archive_blob_2015_12
    matomo_archive_blob_2016_01
    matomo_archive_blob_2016_02
    matomo_archive_blob_2016_03
    matomo_archive_blob_2016_04
    matomo_archive_blob_2016_05
    matomo_archive_blob_2016_06
    matomo_archive_blob_2016_07
    matomo_archive_blob_2016_08
    matomo_archive_blob_2016_09
    matomo_archive_blob_2016_10
    matomo_archive_blob_2016_11
    matomo_archive_blob_2016_12
    matomo_archive_blob_2017_01
    matomo_archive_blob_2017_02
    matomo_archive_blob_2017_03
    matomo_archive_blob_2017_04
    matomo_archive_blob_2017_05
    matomo_archive_blob_2017_06
    matomo_archive_blob_2017_07
    matomo_archive_blob_2017_08
    matomo_archive_blob_2017_09
    matomo_archive_blob_2017_10
    matomo_archive_blob_2017_11
    matomo_archive_blob_2017_12
    matomo_archive_blob_2018_01
    matomo_archive_blob_2018_02
    matomo_archive_blob_2018_03
    matomo_archive_blob_2018_04
    matomo_archive_blob_2018_05
    matomo_archive_blob_2018_06
    matomo_archive_blob_2018_07
    matomo_archive_blob_2018_08
    matomo_archive_blob_2018_09
    matomo_archive_blob_2018_10
    matomo_archive_blob_2018_11
    matomo_archive_blob_2018_12
    matomo_archive_blob_2019_01
    matomo_archive_blob_2019_02
    matomo_archive_blob_2019_03
    matomo_archive_blob_2019_04
    matomo_archive_blob_2019_05
    matomo_archive_blob_2019_06
    matomo_archive_blob_2019_07
    matomo_archive_blob_2019_08
    matomo_archive_blob_2019_09
    matomo_archive_blob_2019_10
    matomo_archive_blob_2019_11
    matomo_archive_blob_2019_12
    matomo_archive_blob_2020_01
    matomo_archive_blob_2020_02
    matomo_archive_blob_2020_03
    matomo_archive_blob_2020_04
    matomo_archive_blob_2020_05
    matomo_archive_blob_2020_06
    matomo_archive_blob_2020_07
    matomo_archive_blob_2020_08
    matomo_archive_blob_2020_09
    matomo_archive_blob_2020_10
    matomo_archive_blob_2020_11
    matomo_archive_blob_2020_12
    matomo_archive_blob_2021_01
    matomo_archive_blob_2021_02
    matomo_archive_blob_2021_03
    matomo_archive_blob_2021_04
    matomo_archive_blob_2021_05
    matomo_archive_blob_2021_06
    matomo_archive_blob_2021_07
    matomo_archive_blob_2021_08
    matomo_archive_blob_2021_09
    matomo_archive_blob_2021_10
    matomo_archive_blob_2021_11
    matomo_archive_numeric_2008_12
    matomo_archive_numeric_2009_01
    matomo_archive_numeric_2009_02
    matomo_archive_numeric_2009_03
    matomo_archive_numeric_2009_04
    matomo_archive_numeric_2009_05
    matomo_archive_numeric_2009_06
    matomo_archive_numeric_2009_07
    matomo_archive_numeric_2009_08
    matomo_archive_numeric_2009_09
    matomo_archive_numeric_2009_10
    matomo_archive_numeric_2009_11
    matomo_archive_numeric_2009_12
    matomo_archive_numeric_2010_01
    matomo_archive_numeric_2010_02
    matomo_archive_numeric_2010_03
    matomo_archive_numeric_2010_04
    matomo_archive_numeric_2010_05
    matomo_archive_numeric_2010_06
    matomo_archive_numeric_2010_07
    matomo_archive_numeric_2010_08
    matomo_archive_numeric_2010_09
    matomo_archive_numeric_2010_10
    matomo_archive_numeric_2010_11
    matomo_archive_numeric_2010_12
    matomo_archive_numeric_2011_01
    matomo_archive_numeric_2011_02
    matomo_archive_numeric_2011_03
    matomo_archive_numeric_2011_04
    matomo_archive_numeric_2011_05
    matomo_archive_numeric_2011_06
    matomo_archive_numeric_2011_07
    matomo_archive_numeric_2011_08
    matomo_archive_numeric_2011_09
    matomo_archive_numeric_2011_10
    matomo_archive_numeric_2011_11
    matomo_archive_numeric_2011_12
    matomo_archive_numeric_2012_01
    matomo_archive_numeric_2012_02
    matomo_archive_numeric_2012_03
    matomo_archive_numeric_2012_04
    matomo_archive_numeric_2012_05
    matomo_archive_numeric_2012_06
    matomo_archive_numeric_2012_07
    matomo_archive_numeric_2012_08
    matomo_archive_numeric_2012_09
    matomo_archive_numeric_2012_10
    matomo_archive_numeric_2012_11
    matomo_archive_numeric_2012_12
    matomo_archive_numeric_2013_01
    matomo_archive_numeric_2013_02
    matomo_archive_numeric_2013_03
    matomo_archive_numeric_2013_04
    matomo_archive_numeric_2013_05
    matomo_archive_numeric_2013_06
    matomo_archive_numeric_2013_07
    matomo_archive_numeric_2013_08
    matomo_archive_numeric_2013_09
    matomo_archive_numeric_2013_10
    matomo_archive_numeric_2013_11
    matomo_archive_numeric_2013_12
    matomo_archive_numeric_2014_01
    matomo_archive_numeric_2014_02
    matomo_archive_numeric_2014_03
    matomo_archive_numeric_2014_04
    matomo_archive_numeric_2014_05
    matomo_archive_numeric_2014_06
    matomo_archive_numeric_2014_07
    matomo_archive_numeric_2014_08
    matomo_archive_numeric_2014_09
    matomo_archive_numeric_2014_10
    matomo_archive_numeric_2014_11
    matomo_archive_numeric_2014_12
    matomo_archive_numeric_2015_01
    matomo_archive_numeric_2015_02
    matomo_archive_numeric_2015_03
    matomo_archive_numeric_2015_04
    matomo_archive_numeric_2015_05
    matomo_archive_numeric_2015_06
    matomo_archive_numeric_2015_07
    matomo_archive_numeric_2015_08
    matomo_archive_numeric_2015_09
    matomo_archive_numeric_2015_10
    matomo_archive_numeric_2015_11
    matomo_archive_numeric_2015_12
    matomo_archive_numeric_2016_01
    matomo_archive_numeric_2016_02
    matomo_archive_numeric_2016_03
    matomo_archive_numeric_2016_04
    matomo_archive_numeric_2016_05
    matomo_archive_numeric_2016_06
    matomo_archive_numeric_2016_07
    matomo_archive_numeric_2016_08
    matomo_archive_numeric_2016_09
    matomo_archive_numeric_2016_10
    matomo_archive_numeric_2016_11
    matomo_archive_numeric_2016_12
    matomo_archive_numeric_2017_01
    matomo_archive_numeric_2017_02
    matomo_archive_numeric_2017_03
    matomo_archive_numeric_2017_04
    matomo_archive_numeric_2017_05
    matomo_archive_numeric_2017_06
    matomo_archive_numeric_2017_07
    matomo_archive_numeric_2017_08
    matomo_archive_numeric_2017_09
    matomo_archive_numeric_2017_10
    matomo_archive_numeric_2017_11
    matomo_archive_numeric_2017_12
    matomo_archive_numeric_2018_01
    matomo_archive_numeric_2018_02
    matomo_archive_numeric_2018_03
    matomo_archive_numeric_2018_04
    matomo_archive_numeric_2018_05
    matomo_archive_numeric_2018_06
    matomo_archive_numeric_2018_07
    matomo_archive_numeric_2018_08
    matomo_archive_numeric_2018_09
    matomo_archive_numeric_2018_10
    matomo_archive_numeric_2018_11
    matomo_archive_numeric_2018_12
    matomo_archive_numeric_2019_01
    matomo_archive_numeric_2019_02
    matomo_archive_numeric_2019_03
    matomo_archive_numeric_2019_04
    matomo_archive_numeric_2019_05
    matomo_archive_numeric_2019_06
    matomo_archive_numeric_2019_07
    matomo_archive_numeric_2019_08
    matomo_archive_numeric_2019_09
    matomo_archive_numeric_2019_10
    matomo_archive_numeric_2019_11
    matomo_archive_numeric_2019_12
    matomo_archive_numeric_2020_01
    matomo_archive_numeric_2020_02
    matomo_archive_numeric_2020_03
    matomo_archive_numeric_2020_04
    matomo_archive_numeric_2020_05
    matomo_archive_numeric_2020_06
    matomo_archive_numeric_2020_07
    matomo_archive_numeric_2020_08
    matomo_archive_numeric_2020_09
    matomo_archive_numeric_2020_10
    matomo_archive_numeric_2020_11
    matomo_archive_numeric_2020_12
    matomo_archive_numeric_2021_01
    matomo_archive_numeric_2021_02
    matomo_archive_numeric_2021_03
    matomo_archive_numeric_2021_04
    matomo_archive_numeric_2021_05
    matomo_archive_numeric_2021_06
    matomo_archive_numeric_2021_07
    matomo_archive_numeric_2021_08
    matomo_archive_numeric_2021_09
    matomo_archive_numeric_2021_10
    matomo_archive_numeric_2021_11
)
IGNORE_TABLES=""
for i in "${IGNORE_TABLES_LIST[@]}"
do
    IGNORE_TABLES=$IGNORE_TABLES"--ignore-table=matomo.$i "
done

IGNORE_TABLES_COMMA_SEPARATED=""
for i in "${!IGNORE_TABLES_LIST[@]}"
do
    if [ $i == 0 ]
    then
        IGNORE_TABLES_COMMA_SEPARATED+="'${IGNORE_TABLES_LIST[$i]}'"
    else
        IGNORE_TABLES_COMMA_SEPARATED+=",'${IGNORE_TABLES_LIST[$i]}'"
    fi
done

