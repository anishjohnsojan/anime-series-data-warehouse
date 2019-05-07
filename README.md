# anime-series-data-warehouse
R-script codes to extract, transform and create comma separated files for data extracted from three different sources.

Each R-script is associated with one data source. The data is extracted from the following sources:
a. My Anime List:
https://myanimelist.net/topanime.php
The script loops across the top 500 anime by scraping tables and extracting relevant data on the fly.

Once all the data is accumulated in each variable (column wise), the appropriate transformations are carried out.

This is then merged to form a data-frame and written as a comma separated file.

b. Anime Planet:

https://www.anime-planet.com/anime/all

The data from this site is scrapped using the ParseHub web-scraper to extract data based on the hover event of each anime, and then placed into a CSV file.

The data is loaded into a dataframe and then appropriate transformations are carried out to find common series in source one and two.

c. Some Anime Things:
http://www.someanithing.com/334

The data is extracted by using the htmltab function in R. Appropriate formatting is carried out, before combining the Year and the Title of each Anime to find data that is common across all three sources.
