*************   P   R   O   G   R   A   M       H   E   A   D   E   R   *****************
*****************************************************************************************
*                                                                                       *
*   PROGRAM:    1 - Performing Queries.sas                                              *
*   PURPOSE:    Illustrate how to perform Structured Query Language queries in SAS      *
*   AUTHOR:     Jud Blatchford                                                          *
*   CREATED:    2018-04-20                                                              *
*                                                                                       *
*   VENUE:      University of Colorado Cancer Center - Biostatistics Core Journal Club  *
*   DATA USED:  Source. SrcHit2016, SrcHit2017, SrcField2017, PlayerInfo, TeamInfo      *
*   SOFTWARE:   SAS (r) Proprietary Software 9.4 (TS1M4)                                *
*   MODIFIED:   DATE        BY  REASON                                                  *
*               ----------  --- ------------------------------------------------------- *
*               2018-11-08  PJB Slight modifications for the presentation               *
*                                                                                       *
*   CONTENTS:                                                                           *
*   	Section 1.0 - Using SQL in SAS                                                  *
*   	Section 1.1 - The FROM Clause                                                   *
*   	Section 1.2 - The SELECT Clause                                                 *
*   	Section 1.3 - The WHERE Clause                                                  *
*   	Section 1.4 - The ORDER BY Clause                                               *
*   	Section 1.5 - The GROUP BY Clause                                               *
*   	Section 1.6 - The HAVING Clause                                                 *
*   	Section 1.7 - Additional Material                                               *
*   	Section 1.8 - Solutions                                                         *
*                                                                                       *
*****************************************************************************************
***********************************************************************************; RUN;


*   Instructions:
    1)  Change the path in the %LET statement to the location of your root folder which
			contains this program and the SAS data sets
    2)  Submit the %LET and LIBNAME statements below   *;
%LET    Root = C:/Dropbox/2 - Education/6 - Presentations/2018-11-13 - UCCCC Biostatistics Core - Performing SQL Queries;
LIBNAME Source  "&Root";

*	Note:  Forward slashes are used for portability across operating environments
		   -Some operating environments require forward slashes
		   -Windows accepts forward slashes but might convert them to backslashes   *;




*   SECTION 1.0 - USING SQL IN SAS   *; RUN;


*	Structured Query Language (SQL) is a standardized language used by many software products
	The first SQL product was released in 1981 and now there are over 75 SQL products

	IBM developed the first mainframe computers to store large amounts of data
	The next issue was how to export data from the computers
	Structured Query Language (SQL) was developed by IBM with a primary
		purpose to extract data, a.k.a. query the data
		Other purposes for which SQL is commonly used include:
			Joining tables
			Create reports
			Subsetting data
			Examining relationships between data values
			Creating new tables and views
			Add, modify, or drop data in tables and views
			Etc

	SQL terminology is slightly different from SAS terminology (but is synonymous):
		SAS TERM			SQL TERM			DATA PROCESSING TERM
		-----------			--------			--------------------
		Data set			Table				File
		Observarion			Row					Record
		Variable			Column				Field

	SQL is implemented in SAS using the SQL procedure, PROC SQL
		PROC SQL follows ANSI standards and comes with several SAS enhancements
		PROC SQL is a useful supplement to the DATA step
		Sometimes a single PROC SQL step can accomplish what would require
			multiple DATA and PROC steps!

	PROC SQL can combine data from 2 or more different types of data sources
		(e.g. a SAS data set and an external database)
		Note:  PROC SQL does not process raw (i.e. text) data files

	The PROC SQL statement invokes the procedure and loads the SQL processor
		into memory and now is ready to execute statements (e.g. perform a query)
	The QUIT statement ends the procedure and removes the SQL processor from memory
		(before the QUIT statement is submitted you'll see "PROC SQL running" in the banner)
	In between those 2 statements can be any number of statements
		(e.g. queries, creating tables, etc)   *;

PROC SQL;

	* Enter code for 1st query *;

	* Enter code for 2nd query *;

	* Etc *;

	QUIT;


*	Several statements in PROC SQL include clauses

	The SELECT statement retrieves and displays data (i.e. it queries the data)
	It is the primary tool of PROC SQL, is used for constructing all queries,
		and is made up of the following clauses:

	SELECT (required)
		INTO (Note: This clause is not covered in this lecture)
		FROM (required)
		WHERE
		GROUP BY
		HAVING
		ORDER BY

	The clauses must be written in the order shown above, with SELECT and FROM being required
	Note:  The semicolon is only used at the end of the entire SELECT statement

	By default, a query creates a report, but can also create a table or view (later lecture)
	
	SAS has SQL documentation online:
	Go to www.Support.SAS.com
	->	Click the 'Documentation' tile
	->	Enter 'SQL' into the 'Search Documentation' search bar and click 'Search'
	->	The first link returned should be the line to:
			'SAS 9.4 SQL Procedure User's Guide, Fourth Edition'   *;




*   SECTION 1.1 - THE FROM CLAUSE   *; RUN;

*	The FROM clause is required and specifies the source table (or view) to be queried
	When multiple tables are queried the table list is comma-separated
	Recall:  SAS uses 2-level names where the:
				A) 1st level is the library reference (i.e. libref) designating the physical location
				B) 2nd level is the name of the table   *;


*   Illustration 1 - Using the FROM Clause   *; RUN;

*	Goal:  Query all data from the 'SrcHit2017' table   *;
PROC SQL;
	SELECT	*
		FROM Source.SrcHit2017;
	QUIT;
*	The asterisk is the wildcard character which is a shortcut to display all columns
 	Note:  This query created a report with all rows and all columns displayed.
			The columns are displayed in the order they are stored in the table.
			Other clauses are used to filter the rows and columns.   *;

*	By default, PROC SQL produces a report when a query is submitted
	I will show how the report is similar to those produced by PROC PRINT

	Recall:  In PROC PRINT by default all observations and variables are displayed
				(the VAR statement is optional)   *;
PROC PRINT DATA = Source.SrcHit2017;
	RUN;


* --------------------------- *
|   Comprehension Check 1.1   |
* --------------------------- *
	Task:  Create a report which displays all columns from the table containing
			the 2017 fielding data ('Source.SrcField2017')
	Instructions:  Replace each instance of 'Aaaaa' or [keyword] etc   *;
PROC SQL;
	SELECT	*
		[keyword] Aaaaa.Bbbbb;
	QUIT;




*   SECTION 1.2 - THE SELECT CLAUSE   *; RUN;

*	The SELECT clause lists the columns which will appear in the output
	The syntax begins with the keyword SELECT followed by a comma-delimited list of columns
	Note:  SQL uses comma-delimited lists, so SAS adopted that syntax for PROC SQL to conform to the convention
			Recall that SAS typically uses spaces to delimit lists of variables   *;


*   Illustration 1 - Specifying a List of Columns to Display   *; RUN;

*	The SELECT clause controls 1) the columns displayed, and 2) their order
		i.e. it filters the columns
	By default column attributes are used to format the output
		(i.e. labels are displayed if the column has a label)

	Goal:  Write a query to display the 2017 player names and the number of home runs   *;
PROC SQL OUTOBS=10;
	SELECT	Name, HR
		FROM Source.SrcHit2017;
	QUIT;
*	To force PROC SQL to ignore permanent labels, specify the NOLABEL system option   *;


*   Illustration 2 - Reproducing the report with PROC PRINT   *; RUN;

*	Recall:
	1)	The LABEL or SPLIT= option is required to display variable labels in PROC PRINT
	2)	The NOOBS option suppresses the 'Obs' column   *;
PROC PRINT DATA = Source.SrcHit2017 (OBS=10) LABEL NOOBS;
	VAR	Name HR;
	RUN;


*   Illustration 3 - Displaying Row Numbers   *; RUN;

*	The NUMBER option (in the PROC SQL statement) displays the row numbers   *;
PROC SQL NUMBER OUTOBS=10;
	SELECT	Name, HR
		FROM Source.SrcHit2017;
	QUIT;

*	Recall:  In PROC PRINT the 'Obs' header is controlled by the OBS= option   *;
PROC PRINT DATA = Source.SrcHit2017 (OBS=10) LABEL OBS='Row';
	VAR	Name HR;
	RUN;


*   Illustration 4 - Changing Column Headers   *; RUN;

*	Column headers may be changed by using the LABEL= option following the column name
		(the LABEL= is optional)

	Goal:  Incorporate appropriate labels for the displayed columns   *;
PROC SQL NUMBER OUTOBS=10;
	SELECT	Name	LABEL = 'MLB Player',
			HR		LABEL = '2017 HRs'
		FROM Source.SrcHit2017;
	QUIT;

*	Recall:  Use a LABEL statement in PROC PRINT to control the variable headers   *;
PROC PRINT DATA = Source.SrcHit2017 (OBS=10) LABEL OBS='Row';
	VAR	Name HR;
	LABEL	Name	= 'MLB Player'
			HR		= '2017 HRs';
	RUN;


*   Illustration 5 - Performing Multiple Queries   *; RUN;

*	Goal:  Perform the above query for both the 2016 and 2017 hitting data   *;
PROC SQL NUMBER OUTOBS=10;

	SELECT	Name	LABEL = 'MLB Player',
			HR		LABEL = '2016 HRs'
		FROM Source.SrcHit2016;

	SELECT	Name	LABEL = 'MLB Player',
			HR		LABEL = '2017 HRs'
		FROM Source.SrcHit2017;

	QUIT;

*	Note:  Each statement executes as soon as the SQL processor executes the semicolon
		(this is why the RUN statement is not needed)
	Re-run the previous step 1 statement at a time and watch the banner   *;


*   Illustration 6 - Incorporating Titles   *; RUN;

*	TITLE statements are still global statements, but because in PROC SQL each statement
		executes immediately, different TITLE statements within PROC SQL will each
		execute and can be changed before the QUIT statement   *;
PROC SQL NUMBER OUTOBS=10;

	TITLE1	'Home Runs - 2016';
	SELECT	Name, HR
		FROM Source.SrcHit2016;

	TITLE1	'Home Runs - 2017';
	SELECT	Name, HR
		FROM Source.SrcHit2017;

	QUIT;
TITLE;
*	Recall:  A null TITLE statement will cancel all titles in effect (a "best practice")   *;


*   Illustration 7 - Displaying a New Column as a Character Constant   *; RUN;

*	Note:  New columns only exist for the query
			(i.e. they are not part of the table, unless a table or view is created)   *;
TITLE1	'MLB Home Runs in 2017';
PROC SQL NUMBER OUTOBS=10;
	SELECT	'2017', Name, HR
		FROM Source.SrcHit2017;
	QUIT;
TITLE;

*	Use the AS keyword to create a column alias (displayed in the column header)
		The alias must use valid SAS naming conventions
	If both an alias and label are specified, the label is displayed
	An alias is useful because it allows you to reference the column elsewhere in the query

	Goal:  Display the text 'Season' as the column header   *;
TITLE1	'MLB Home Runs in 2017';
PROC SQL NUMBER OUTOBS=10;
	SELECT	'2017' AS Season, Name, HR
		FROM Source.SrcHit2017;
	QUIT;
TITLE;


*   Illustration 8 - Creating New Columns   *; RUN;

*	New columns may be defined in the SELECT clause by using an appropriate expression

	Goal:  Create the batting average (H/AB) for each row   *;
TITLE1	'MLB 2017 Batting Averages';
PROC SQL NUMBER OUTOBS=10;
	SELECT	Name, H, AB,
			H / AB AS AVG
		FROM Source.SrcHit2017;
	QUIT;
TITLE;


*   Illustration 9 - Controlling the Formatting of Values   *; RUN;

*	Use the FORMAT= option (a SAS enhancement) to specify a format for values of a column

	Note:  If a column has a format, that format is automatically applied   *;
TITLE1	'MLB 2017 Batting Averages';
PROC SQL NUMBER OUTOBS=10;
	SELECT	Name, H, AB,
			H / AB AS AVG	FORMAT = 4.3
		FROM Source.SrcHit2017;
	QUIT;
TITLE;


* --------------------------- *
|   Comprehension Check 1.2   |
* --------------------------- *
	Task:  Create a report which displays
			1) Player name (Name)
			2) At Bats (AB)
			3) Strikeouts (K)
			4) A newly created column with header 'AB Per K', defined as
				at-bats per strikeout (AB / K), displayed with 1 decimal place
	Instructions:  Replace each instance of 'Aaaaa' etc
					The same value should be placed wherever the same string is seen   *;
PROC SQL NUMBER OUTOBS=10;
	SELECT	Aaaaa, Bbbbb, Ccccc,
			Bbbbb / Ccccc LABEL = 'Ddddd' FORMAT = EEEEE
		FROM Source.SrcHit2017;
	QUIT;


*   Illustration 10 - Using Functions   *; RUN;

*	Summary functions may be used to summarize data in PROC SQL
		Examples of functions that may be used include:
			SUM, MIN, MAX, RANGE, NMISS, etc

	When multiple arguments are specified as function arguments, the function operates horizontally
		(i.e. on each individual row)
	This is how a SAS function operates on an observation in the DATA step   *;
PROC SQL NUMBER OUTOBS=10;
	SELECT	Name, R, RBI, HR,
			SUM(R, RBI, -HR) LABEL = 'Runs Created'
		FROM Source.SrcHit2017;
	QUIT;

*	NB:  When a single argument is specified as the function argument, the function operates vertically
		(i.e. on the individual column)   *;
PROC SQL;
	SELECT	SUM(R)		FORMAT = COMMA6.	LABEL = 'Total Runs',
			SUM(RBI)	FORMAT = COMMA6.	LABEL = 'Total RBI',
			SUM(HR)		FORMAT = COMMA6.	LABEL = 'Total Home Runs'
		FROM Source.SrcHit2017;
	QUIT;
*	Note:  Format specifications are not inherited in PROC SQL (so I specified them)
	When the goal is to summarize vertically only 1 argument may be specified in a function

	Recall:  PROC MEANS inherits the format specifications of the variables
	Producing the same report using PROC MEANS   *;
PROC MEANS DATA = Source.SrcHit2017 NOPRINT;
	VAR	R RBI HR;
	OUTPUT OUT = WORK.Summaries (DROP = _TYPE_ _FREQ_)
		SUM (R RBI HR) = SumR SumRBI SumHR;
	RUN;

PROC PRINT DATA = WORK.Summaries NOOBS SPLIT = '/';
	LABEL	SumR	= '/Total Runs'
			SumRBI	= '/Total RBI'
			SumHR	= 'Total Home/Runs';
	RUN;

*	PROC SQL supports 4 functions (N, NMISS, MIN, and MAX) for character data
	Functions may be nested (illustrated below)  *;
PROC SQL;
	SELECT	N(Name)					LABEL = 'Rows with Non-Missing Names'	FORMAT = COMMA5.,
			NMISS(Name)				LABEL = 'Rows with Missing Names',
			SCAN(MIN(Name), 1, ',')	LABEL = 'First Alphabetically'			FORMAT = $UPCASE.,
			SCAN(MAX(Name), 1, ',')	LABEL = 'Last Alphabetically'
		FROM Source.SrcHit2017;
	QUIT;

*	Code to display the maximum (i.e. last) case-insensitive last name   *;
PROC SQL;
	SELECT	SCAN(MIN(Name), 1, ',')			LABEL = 'First Alphabetically',
			SCAN(MAX(UPCASE(Name)), 1, ',')	LABEL = 'Last Alphabetically'
		FROM Source.SrcHit2017;
	QUIT;
*	Note:  The value could be displayed in mixed case by nesting the functions within
			the PROPCASE function   *;


*	Illustration 11 - Using the DISTINCT Option to Eliminate Duplicate Rows   *; RUN;

*	The DISTINCT keyword eliminates duplicate rows
	It applies to the combination of all columns listed in the SELECT statement

	Goal:  Create a list of unique positions from the fielding data   *;
PROC SQL NUMBER;
	SELECT	DISTINCT POS
		FROM Source.SrcField2017;
	QUIT;
*	Note:  The values returned are sorted   *;

*	Goal:  Retrieve a list of unique League / Division combinations from the 'TeamInfo' table   *;
PROC SQL NUMBER;
	SELECT	DISTINCT League, Division
		FROM Source.TeamInfo;
	QUIT;


*	Illustration 12 - The COUNT Function   *; RUN;

*	The COUNT summary function is used to count rows
	This is the only function that allows an asterisk (*) as an argument

	It is generally used in 3 ways:
		Use						Returns the Total Number of
		---------------------	-------------------------------------------
	1)	COUNT(*)				Rows in a Table (or a Group)
	2)	COUNT(column)			Non-missing rows in a Table (or a Group)
	3)	COUNT(DISTINCT column)	Unique values in a column

	Task:  How many different countries were our cohort of MLB players born in?

	Let's first look at the data set   *;
PROC SQL NUMBER OUTOBS=10;
	SELECT *
		FROM Source.PlayerInfo;
	QUIT;

*	Determine the number of countries represented by the cohort of players   *;
PROC SQL;
	SELECT COUNT(DISTINCT SCAN(BirthLoc, 2, ','))
			LABEL = 'Number of Countries of Birth'
		FROM Source.PlayerInfo;
	QUIT;

*	Q: What would you need to change to see the actual countries?
	A: Just remove the COUNT() syntax (I'd also add the NUMBER option)
	The DISTINCT keyword is used to display unique values (it doesn't count them)	*;


*   Illustration 13 - Creating Columns Conditionally   *; RUN;

*	Case Expressions provide a way of creating values conditionally
		They are similar to the DATA step's SELECT statement
			(and logically similar to the IF/THEN/ELSE construct)
			and must be a valid expression
	They start with the keyword CASE and are closed with the keyword END
	They use one or more WHEN/THEN clauses to conditionally process rows
	They may be used anywhere a column name may be used

	There are 2 types of Case Expressions (each shown below)
	Each WHEN condition is evaluated until the first true condition is found
	For both, if the WHEN condition is true, the result-expression following THEN
		is processed and its value is assigned to the CASE expression's result
		(often a new column), and the remaining WHEN conditions are bypassed
	For the most efficient processing, write the WHEN conditions in order
		of decreasing frequency (just like for IF/THEN/ELSE DATA step processing)

	Task:  Create a column to classify defensive positions as either
			'Pitcher', 'Infielder', 'Outfielder', or 'OTHER'

*	Syntax #1:  Using CASE-OPERAND Form
	CASE-OPERAND form specifies an expression after the CASE keyword, then
		uses an	equality test to compare the expression with the
		condition following each WHEN keyword
	When testing an equality, using CASE-OPERAND form is most efficient because
		the expression is only evaluated once (as opposed to after each WHEN clause)
	This form does not allow the use of AND or OR keywords for a compound expression   *;
PROC SQL NUMBER OUTOBS=10;
	SELECT	PlayerID, Name, POS,
				CASE POS
					WHEN 'P'  THEN 'Pitcher'
					WHEN 'C'  THEN 'Catcher'
					WHEN '1B' THEN 'Infielder'
					WHEN '2B' THEN 'Infielder'
					WHEN '3B' THEN 'Infielder'
					WHEN 'SS' THEN 'Infielder'
					WHEN 'LF' THEN 'Outfielder'
					WHEN 'CF' THEN 'Outfielder'
					WHEN 'RF' THEN 'Outfielder'
					ELSE           'Other Position'
				END AS PosGrp 'Position Group'
		FROM Source.SrcField2017;
	QUIT;

*	The ELSE expression is optional and is used to specify the expression
		to apply when none of the WHEN expressions are true
	If ELSE is omitted, missing values will be assigned when none of the
		WHEN conditions are satisfied (a NOTE will be written in the log)

	It may be more concise to use other comparisons besides equality

	Syntax #2:  Simple Case Expression
	Alternatively, you do not need to specify an expression following CASE,
		and can code different case expressions following each WHEN keyword (as shown below)
		This syntax must be used when inequalities are used in the conditional logic
	This form allows for the use or AND or OR keywords for a compound expression   *;
PROC SQL NUMBER OUTOBS=10;
	SELECT	PlayerID, Name, POS,
				CASE
					WHEN POS = 'P'                        THEN 'Pitcher'
					WHEN POS = 'C'                        THEN 'Catcher'
					WHEN POS IN('1B', '2B', '3B', 'SS')   THEN 'Infielder'
				/* Just showing the use of OR to create a compound Boolean expression
					[I would've coded it as WHEN POS IN('LF', 'CF', 'RF')] */
					WHEN POS='LF' OR POS='CF' OR POS='RF' THEN 'Outfielder'
					ELSE                                       'Other Position'
				END AS PosGrp 'Position Group'
		FROM Source.SrcField2017;
	QUIT;

*	Task:  Create categories of hitters

	This shows how an example using inequality comparisons, where
		the simple case expression syntax must be used   *;
PROC SQL NUMBER OUTOBS=150;
	SELECT	PlayerID, Name, R, RBI, HR, R+RBI-HR AS RP 'Runs Produced',
				CASE
					WHEN CALCULATED RP > 180 THEN '*** Superstar ***'
					WHEN CALCULATED RP > 140 THEN 'ALL-STAR!'
					WHEN CALCULATED RP > 100 THEN 'Value Added'
					ELSE                          ' '
				END AS Rating 'Player Rating'
		FROM Source.SrcHit2017;
	QUIT;




*   SECTION 1.3 - THE WHERE CLAUSE   *; RUN;

*	The WHERE clause specifies the condition(s) that must be met for the displayed rows
		i.e. it filter the rows
	Without the WHERE clause all rows from the underlying table are processed
	The condition(s) in the WHERE clause may be any valid SAS expression(s)   *;


*   Illustration 1 - Using the WHERE Clause   *; RUN;

*	Goal:  Display all rows with 40 or more home runs   *;
TITLE1	'Rows with 40+ Home Runs in 2017';
PROC SQL NUMBER;
	SELECT	Name, HR
		FROM Source.SrcHit2017
		WHERE HR >= 40;
	QUIT;
TITLE;


*   Illustration 2 - Specifying Multiple WHERE Conditions   *; RUN;

*	Note:  A SELECT statement may only contain 1 WHERE clause, so you must use a compound
			expression to apply multiple criteria
	Multiple expressions may be applied in the WHERE clause by using logical
		operators (AND, OR, NOT)

*	Goal:  Display New York Yankee players who hit at least 30 home runs in 2017   *;
TITLE1	'New York Yankees with 30+ Home Runs';
PROC SQL NUMBER;
	SELECT	TeamID, Name, HR
		FROM Source.SrcHit2017
		WHERE	TeamID = '147'	AND
				HR >= 30;
	QUIT;
TITLE;


*   Illustration 3 - Columns Used in the WHERE Clause Don't Need to Be Displayed   *; RUN;

*	The WHERE clause can specify any column(s) from underlying tables
		(i.e. not just displayed columns)   *;
TITLE1	'Batting Average for Yankees with 30+ Home Runs';
PROC SQL NUMBER;
	SELECT	Name,
			H/AB AS AVG FORMAT = 4.3
		FROM Source.SrcHit2017
		WHERE	TeamID = '147'	AND
				HR >= 30;
	QUIT;
TITLE;


*   Illustration 4 - Using a Created Column in the WHERE Clause   *; RUN;

*	Task:  Create a report of Diamondback players who hit at least .300   *;
TITLE1	'Diamondbacks Players Who Hit .300+';
PROC SQL NUMBER;
	SELECT	Name,
			H/AB AS AVG FORMAT = 4.3
		FROM Source.SrcHit2017
		WHERE	TeamID = '109'	AND
				AVG >= 0.300;
	QUIT;
TITLE;
*	Check the log!

	Recall:  Filtering with WHERE is done "up front" by the engine that reads the data
		i.e. the WHERE clause is processed before the SELECT clause, 
		and the SQL processor looks in the table for each column named in the WHERE clause
	As a result, to include any created column in the WHERE statement requires
		alerting SAS to this by using the CALCULATED keyword

	Although the expression could be repeated in the WHERE clause (instead of using
		"CALCULATED alias"), this is inefficient because SQL has to perform the calculation twice   *; 
TITLE1	'Diamondbacks Players Who Hit .300+';
PROC SQL NUMBER;
	SELECT	Name,
			H/AB AS AVG FORMAT = 4.3
		FROM Source.SrcHit2017
		WHERE	TeamID = '109'	AND
				CALCULATED AVG >= 0.300;
	QUIT;
TITLE;

*	Calculated columns may be used in other parts of the query as well
	e.g. when creating another column based on a calculated column   *;
PROC SQL NUMBER;
	SELECT	Name,
			H/AB AS AVG FORMAT = 4.3,
			2*CALCULATED AVG LABEL = '2 x AVG' FORMAT = 4.3
		FROM Source.SrcHit2017
		WHERE	TeamID = '109' AND
				CALCULATED AVG >= 0.300;
	QUIT;


* --------------------------- *
|   Comprehension Check 1.3   |
* --------------------------- *
	Task:  Create a report based on the 'Source.SrcField2017' table which displays
			1) Player name (Name)
			2) Position (POS)
			3) A new column 'Total Chances' (TC), defined a TC = PO+A+E
			Filter the report to display only outfielders (LF, CF, or RF)
				who had at least 300 total chances
	Instructions:  Replace each instance of 'Aaaaa' or [expression] etc
					The same value should be placed wherever the same string is seen   *;
PROC SQL NUMBER;
	SELECT	Aaaaa, Bbbbb, 
			[expression1] AS Ccccc LABEL = 'Total Chances'
		FROM Source.SrcField2017
		WHERE	[expression2] AND
				[expression3];
	QUIT;
			



*   SECTION 1.4 - THE ORDER BY CLAUSE   *; RUN;

*	The ORDER BY clause specifies the order of (a.k.a. sorts) the displayed rows from a query
	By default columns listed in the ORDER BY clause are sorted is ASCENDING (alisas ASC) order
		(keyword not needed)

	NB:  Data from a table are not automatically returned in a particular order
	The ORDER BY clause must be used to guarantee a particular order of the data   *;


*	Illustration 1 - Using the ORDER BY Clause   *; RUN;

*	Goal:  Order the players by batting average   *;
PROC SQL NUMBER;
	SELECT	Name, H, AB,
			H/AB AS AVG FORMAT = 4.3
		FROM Source.SrcHit2017
		ORDER BY AVG;
	QUIT;
*	Note:  CALCULATED is not needed because ORDER BY is processed after the columns are created,
			so SAS "knows" about new columns by the time it reaches the ORDER BY clause   *;


*	Illustration 2 - Sorting in Descending Order   *; RUN;

*	To specify descending order, follow the column with the DESCENDING keyword (alias is DESC)
	Placing DESCENDING after the column is the ANSI standard, so SAS adopted this
		(Note that this is different that for PROC SORT)

	Goal:  Order the players by descending batting average   *;
PROC SQL NUMBER;
	SELECT	TeamID, Name, H, AB,
			H/AB AS AVG FORMAT = 4.3
		FROM Source.SrcHit2017
		ORDER BY AVG DESCENDING;
	QUIT;

*	Goal:  Restrict the report to players with 502+ plate appearances
			(502 is the minimum number for players to qualify for the batting title)   *;
TITLE1 '2017 MLB Batting Leaders';
PROC SQL NUMBER OUTOBS=10;
	SELECT	Name,
			H/AB AS AVG LABEL = 'Batting Average' FORMAT = 4.3
		FROM Source.SrcHit2017
		WHERE PA >= 502
		ORDER BY AVG DESCENDING;
	QUIT;
TITLE;
*	Note:  The alias AVG wasn't needed for the column header, but was included for the ORDER BY clause   *;


*	Illustration 3 - Referencing Columns   *; RUN;

*	Columns may be referenced using either their 1) name, 2) alias, or 3) position in the SELECT clause
	This illustrates using the position in the ORDER BY clause (so an alias isn't needed)   *;
TITLE1 '2017 MLB Batting Leaders';
PROC SQL NUMBER OUTOBS=10;
	SELECT	Name,
			H/AB LABEL = 'Batting Average' FORMAT = 4.3
		FROM Source.SrcHit2017
		WHERE PA >= 502
		ORDER BY 2 DESCENDING;
	QUIT;
TITLE;


*	Illustration 4 - Specifying Multiple ORDER BY Columns   *; RUN;

*	Note:  When multiple columns are specified, the 2nd column only affects the order
			when values are tied for the first column specified
	Columns are specified in a comma-delimited list

	Goal:  Sort by home runs (descending), then alphabetically by name within tied values of HR
	Note:  The multiple columns must be a comma-delimited list   *;
TITLE1 '2017 MLB Home Run Leaders';
PROC SQL NUMBER OUTOBS=10;
	SELECT	Name, HR
		FROM Source.SrcHit2017
		ORDER BY HR DESCENDING, Name;
	QUIT;
TITLE;


* --------------------------- *
|   Comprehension Check 1.4   |
* --------------------------- *
	Task:  Create a report based on the 'Source.SrcField2017' table which displays
			1) Player name (Name)
			2) Position (POS)
			3) Double Plays (DP)
			Filter the report to display only infielders (1B, 2B, 3B, and SS)
				who had at least 100 games played (G)
			Order the report by descending double-plays within each position
	Instructions:  Replace each instance of 'Aaaaa' or [expression] etc
					The same value should be placed wherever the same string is seen   *;
PROC SQL NUMBER;
	SELECT	Name, POS, DP
		FROM	Source.SrcField2017
		WHERE	[expression1]	AND
				[expression2]
		ORDER BY Aaaaa, Bbbbb CCCCC;
	QUIT;




*   SECTION 1.5 - THE GROUP BY CLAUSE   *; RUN;

*	The GROUP BY clause is used to summarize data by groups (instead of over a whole table)
	This clause classifies the data into groups based on the specified column(s)
	It is designed to be used in queries that include 1 or more summary functions

	Note:  If the grouping column contains missing values, PROC SQL will treat missing
			values as a group   *;


*	Illustration 1 - Creating Summaries Grouped by Levels of a Column   *; RUN;

*	Recall:  In Section 1.2 we used functions.
	When a single argument is specified the function summarizes the column   *;
PROC SQL;
	SELECT	SUM(HR)		FORMAT = COMMA6.	LABEL = 'Total Home Runs'
		FROM Source.SrcHit2017;
	QUIT;

*	Including a GROUP BY clause will create separate summaries within each level
		of the GROUP BY column (i.e. the rows are aggregated in a series of groups).
	Columns in the GROUP BY clause are most commonly classification columns (but could be any column)
	Although not required, it's sensible to display the grouping column(s) in the GROUP BY clause

	Goal:  Create a report of the number of home runs hit by each team   *;
PROC SQL NUMBER;
	SELECT	TeamID,
			SUM(HR)		FORMAT = COMMA6.	LABEL = 'Total Home Runs'
		FROM Source.SrcHit2017
		GROUP BY TeamID;
	QUIT;


*	Illustration 2 - Sorting by a Summarized Column   *; RUN;

*	Note:  By default, the report will also be ordered by the columns in the GROUP BY clause
			However, sorting by a different column may be specified

	Goal:  Display results by descending number of home runs by team
	Functions can only be specified in the SELECT and HAVING clauses
			(i.e. SUM(HR) can't be specified in the ORDER BY clause)
		Therefore, either reference the column position or create an alias and reference the alias   *;
PROC SQL NUMBER;
	SELECT	TeamID,
			SUM(HR)	LABEL = 'Total Team Home Runs',
			MAX(SB)	LABEL = 'Most SB by Player' /* simply showing the use of another function */
		FROM Source.SrcHit2017
		GROUP BY TeamID
		ORDER BY 2 DESCENDING;
	QUIT;
*	Internally, the GROUP BY clause first sorts the rows by each GROUP BY column(s)
		so that the data can be aggregated by that column
		Then, if there is an ORDER BY specification, additional processing is required
			to display the report in the specified order   *;


*	Illustration 3 - Designating Columns Correctly   *; RUN;

*	When generating grouped summaries, the only columns included should typically be:
		1)	Columns used to define the groups
		2)	Columns which are summarized
	Including columns which are not summarized or in the GROUP BY clause tend to yield undesired results

	The 'Name' column has been added but it is not in the GROUP BY clause and is not summarized   *;
PROC SQL NUMBER;
	SELECT	TeamID, Name,
			SUM(HR)	FORMAT = COMMA6.	LABEL = 'Total Team Home Runs'
		FROM Source.SrcHit2017
		GROUP BY TeamID
		ORDER BY 3 DESCENDING;
	QUIT;
*	This query is requesting both summary and detail (i.e. individual) data	in the same report
	This requires the summarized results to be created and then re-merged back with the detail data
		(Notice the note "The query requires remerging summary statistics back with the original data.")
	This issue can also happen without the GROUP BY clause, if both a summarized and
		non-summarized column are specified in the same query (e.g. SUM(HR) and SB)   *; 


*	Illustration 4 - Using GROUP BY Without a Summary Function   *; RUN;

*	When a GROUP BY clause is used but a summary function is not specified,
		SAS writes a warning in the log and changes the GROUP BY to an ORDER BY
		clause (essentially treating the entire table as a single group)   *;
 PROC SQL NUMBER;
	SELECT	TeamID, HR /* No summary function is used */
		FROM Source.SrcHit2017
		GROUP BY TeamID;
	QUIT;
*	Notice that results are not summarized, but instead are ordered by TeamID   *;


*	Illustration 5 - Diplaying Home Runs by Player   *; RUN;

*	Display the home run leaders (players with 25+ home runs)   *;
PROC SQL NUMBER;
	SELECT	PlayerID, Name, HR
		FROM Source.SrcHit2017
		WHERE HR >= 25
		ORDER BY HR DESCENDING, Name;
	QUIT;
*	Who is 41st on the list?   *;

*	Run the query again, this time sorted by player name, then answer:
	How many home runs were hit by Matt Adams?
	How many home runs were hit by JD Martinez?   *;
PROC SQL NUMBER;
	SELECT	PlayerID, Name, HR, TeamID
		FROM Source.SrcHit2017
		ORDER BY Name;
	QUIT;


* --------------------------- *
|   Comprehension Check 1.5   |
* --------------------------- *
	Task:  Create a report which displays each 1) player and 2) their total number of home runs
			Order the report by:
				1) Home run frequency from greatest home runs to least, and
				2) Alphabetically (A -> Z) when players are tied on home runs
	Instructions:  Replace each instance of 'Aaaaa' etc
					The same value should be placed wherever the same string is seen   *;
PROC SQL NUMBER;
	SELECT	Aaaaa,
			BBBBB AS Ccccc
		FROM Source.SrcHit2017
		GROUP BY Aaaaa
		ORDER BY Ccccc DDDDD, Aaaaa;
	QUIT;

*	For the 2nd time, how many home runs were hit by JD Martinez?
	Q:  Will this code summarize accurately if 2+ players have the same name?
	A:  No!  See Additional Material, Illustration 5 for how to handle this   *;




*  SECTION 1.6 - THE HAVING CLAUSE   *; RUN;

*	The HAVING clause subsets grouped data based on specified criteria
	It restricts the groups that are displayed based on the specifications
		(similar to how the WHERE clause restricts individual rows)
		The WHERE clause filters individual rows (evaluated as the data are read)
		The HAVING clause filters grouped rows (evaluated AFTER the summary/aggregation)

	If a HAVING clause is used without a GROUP BY clause, then the entire table is
		treated as a single group
	The output would therefore either return all or none of the rows

	Recall:  Summary functions are restricted to the SELECT and HAVING clauses
				So they can't be used in the WHERE clause   *;


*	Illustration 1 - Using the HAVING Clause to Filter Grouped Results   *; RUN;

*	Task:  Create a report limited to only teams whose players hit 200+ home runs   *;

TITLE1 "Teams with 200+ Home Runs in 2017";
PROC SQL NUMBER;
	SELECT	TeamID,
			SUM(HR)	AS TotHR LABEL = 'Total Team Home Runs'
		FROM Source.SrcHit2017
		GROUP BY TeamID
		HAVING TotHR >= 200
		ORDER BY TotHR DESCENDING;
	QUIT;
TITLE;
*	Note 1:  An alias was used to reference the summary statistic in the HAVING clause
	Note 2:  The CALCULATED keyword was NOT needed in the HAVING clause because that
				clause is evaluated after the summary/aggregation

	Summary functions may be put in the HAVING clause (see below)
	However, it isn't as efficient because SQL processes the function twice   *;
TITLE1 "Teams with 200+ Home Runs in 2017";
PROC SQL NUMBER;
	SELECT	TeamID,
			SUM(HR) LABEL = 'Total Team Home Runs'
		FROM Source.SrcHit2017
		GROUP BY TeamID
		HAVING SUM(HR) >= 200
		ORDER BY 2 DESCENDING;
	QUIT;
TITLE;


*	Illustration 2 - Using the HAVING Clause to Filter Grouped Results (Again)   *; RUN;

*	Recall:  Typically, group-summarized data and detail data aren't displayed together
				However, occasionally that is desired

	Comprehension Check 1.5 will not produce accurate results if multiple players
		have the same name
	Task:  Display any players who have the same name as another player   *;
PROC SQL NUMBER;
	SELECT	Name,
			COUNT(*) AS NameCnt LABEL = 'Frequency of Name', /* This is summary data */
			PlayerID /* This is detail data */
		FROM	Source.PlayerInfo
		GROUP BY	Name
		HAVING	NameCnt > 1
		ORDER BY	2 DESCENDING, Name, PlayerID;
	QUIT;

*	With multiple players having the same name, summaries will need to be created based
		on PlayerID, not Name   *;


* --------------------------- *
|   Comprehension Check 1.6   |
* --------------------------- *
	Task:  Create a report based on the 'Source.SrcField2017' table which displays
			1) Player ID (PlayerID)
			2) Player name (Name)
			3) Total Assists (based on the 'A' column)
			Filter the report to display only players from the Chicago Cubs (TeamID = '112')
				who had at least 100 total assists
			Order the report by descending number of total assists
	Instructions:  Replace each instance of 'Aaaaa' or [expression] etc
					The same value should be placed wherever the same string is seen   *;
PROC SQL NUMBER;
	SELECT	DISTINCT PlayerID, Name, [function] AS Aaaaa 'Total Assists'
		FROM Source.SrcField2017
		WHERE TeamID = '112'
		GROUP BY Bbbbb
		HAVING Aaaaa >= 100
		ORDER BY Aaaaa CCCCC;
	QUIT;




*	SECTION 1.7 - ADDITIONAL MATERIAL   *; RUN;


*	Illustration 1 - Function Extras   *; RUN;

*	Generally, SQL functions are applied vertically (on a column), and
		SAS functions are applied horizontally (on a row)

	However, many functions are both SQL and SAS functions (e.g. SUM, MIN, MAX, etc)
	So when a single argument is used, it is ambiguous if it's meant for vertical
		or horiontal processing.

	In this circumstance, SAS assumes it is meant for vertical processing
		(sensible, as it is unusual to take, say, a SUM of a single value)   *;
PROC SQL;
	SELECT	SUM(HR) LABEL = 'Sum of HR'
		FROM Source.SrcHit2017;
	QUIT;

*	If a SAS function is not also a PROC SQL function, then it would operate horizontally
	For example, the LOG10 function returns the logarithm (base 10) of the argument
		This is a SAS function, and is not a SQL function, so it will operate on the rows   *;
PROC SQL;
	SELECT	LOG10(RBI) LABEL = 'log10 of RBI'
		FROM Source.SrcHit2017;
	QUIT;

*	A few functions perform the same operation but have different SAS and SQL names
	SQL Function	SAS Function
	------------	------------
	AVG				MEAN
	COUNT			FREQ

	The SQL name is designed for vertical processing and will thus only
		accept 1 argument, and will return a summary of the column
	The SAS name will process horizontally if there are 2+ arguments
		and will process vertically if there is a single argument   *;


*	Illustration 2 - Improving the Efficiency of a Query   *; RUN;

*	Processing is typically more efficient when the columns are restricted using the
		DATA step KEEP= option compared with reading from the entire table   *;
PROC SQL STIMER;

	* This statement reads from the entire table *;
	SELECT Name
		FROM Source.SrcHit2016;

	* This statement only brings in the 'Name' column from the source table *;
	SELECT *
		FROM Source.SrcHit2016 (KEEP = Name);

	QUIT;


*   Illustration 3 - Conditional Operators   *; RUN;

*	The following conditional operators may also be used in the WHERE clause:

	Conditional Operator	Tests For
	---------------------	-------------------------------------------------------------
	BETWEEN-AND				Values that occur within an inclusive range
	CONTAINS (or ?)			Values that contain a specified string
	IN						Values that match 1 of a list of values
	IS MISSING or IS NULL	Missing values
	LIKE (with %, _)		Values that match a specified pattern
	=*						Values that sound like a specified value
	ANY						Whether any value from a subquery meets a specified condition 
	ALL						Whether all values from a subquery meet a specified condition
	EXISTS					The existence of values returned by a subquery

	To create a negative condition, precede the operator with 'NOT' (except for ANY and ALL)

	Task:  Create a report containing all players whose birthday is between 5/15/1991 and 6/15/1991
	BETWEEN-AND limits are inclusive, and the smaller value doesn't need to come first   *;
PROC SQL NUMBER;
	SELECT Name, BirthDt
		FROM Source.PlayerInfo
		WHERE BirthDt BETWEEN '15MAY1991'D AND '15JUN1991'D
		ORDER BY BirthDt;
	QUIT;

*	Task:  Create a report containing all players whose name contains a letter Q   *;
PROC SQL NUMBER;
	SELECT Name, BirthDt
		FROM Source.PlayerInfo
		WHERE UPCASE(Name) ? 'Q'; * The keyword CONTAINS could have been used instead of ? *;
	QUIT;

*	Task:  Create a report containing all players whose last name has capital M at the 3rd letter
	SQL compares each value in a column to the pattern specified, where
		_ represents a single character and % represents any number of characters
		(_ and % are sometimes referred to as wildcard characters)
	To specify a pattern, combine one or both of _ and % with any characters you want to match   *;
PROC SQL NUMBER;
	SELECT Name
		FROM Source.PlayerInfo
		WHERE Name LIKE '__M%';
	QUIT;

*	Task:  Create a report of all unique player first names which sound like "John"
	The sounds-like (=*) operator uses the SOUNDEX algorithm to compare each value of a column
		with the specification
	The SOUNDEX algorithm is English-based and is less useful for other languages   *;
PROC SQL NUMBER;
	SELECT DISTINCT SCAN(Name, 2, ',') 'Unique Names'
		FROM Source.PlayerInfo
		WHERE SCAN(Name, 2, ',') =* 'John';
	QUIT;


*   Illustration 4 - Understanding Remerging   *; RUN;

*	In Section 1.5, Illustration 3 the concept of remerging data was introduced

	Sometimes, when a summary function is in a SELECT or HAVING clause, PROC SQL
		must remerge the data

	In some situations you can modify the query to avoid remerging, so understanding
		how and when remerging occurs will increase your ability to program efficiently

	Remerging occurs when:
	1)	Values returned by a summary function are used in a calculation
	2)	The SELECT clause has both summarized columns and non-summarized columns which are
			NOT in the GROUP BY clause (Section 1.5, Illustration 3)
	3)	The HAVING clause specifies 1 or more columns that are NOT included in a
			subquery or a GROUP BY clause

	SQL makes 2 passes through the data which takes additional processing time
	Pass 1)	SQL calculates and returns the value of summary functions
				and also groups data per the GROUP BY clause
	Pass 2)	SQL retrieves any additional columns needed for display, and uses the summary
				result to calculate any expression which has the summary function

	Task:  Create a report showing each players number of stolen bases and the percent
			of the leader's stolen bases   *;
PROC SQL NUMBER OUTOBS=10;
	SELECT PlayerID, Name, SB,
			SB/MAX(SB) AS Pct LABEL = '% of SB Leader' FORMAT = PERCENT7.1
		FROM Source.SrcHit2017
		ORDER BY SB DESCENDING;
	QUIT;
*	See the remerging note in the log

	Pass 1)  SQL calculated and returned the value of MAX(SB)
	Pass 2)  SQL retrieves each column and uses the result from MAX(SB) to calulate
				the Pct column values

	Some implementations of SQL do not support remerging and would return an error for
		this task
	This result could be obtained using a subquery   *;


*	Illustration 5 - Creating Tables with Data Grouped by PlayerID   *; RUN;

*	Task:  Create a table containing 1 row per player for each year's hitting data
	The importance of this task should be clear after Section 1.5 (GROUP BY)

	Note:  DISTINCT is needed in order to produce single rows for players who played
			on multiple teams b/c Name & TeamID are neither summarized nor in the GROUP BY clause.
			If TeamID was included in the GROUP BY clause then we wouldn't be summarizing
				over the player
			If I didn't want TeamID in the results, I could include Name in the GROUP BY clause
				and then not need the DISTINCT keyword   *;
*	2017 hitting data   *;
PROC SQL;
	CREATE TABLE WORK.Hitting2017 AS
		SELECT	DISTINCT
				PlayerID,
				Name,
				CASE WHEN COUNT(*) = 1 THEN TeamID
					 ELSE PUT(COUNT(TeamID), 1.) || ' Teams'
					 END AS TeamID,
				SUM(PA)  AS PA,
				SUM(G)   AS G,
				SUM(AB)  AS AB,
				SUM(H)   AS H,
				SUM(DBL) AS DBL,
				SUM(TPL) AS TPL,
				SUM(HR)  AS HR,
				SUM(R)   AS R,
				SUM(RBI) AS RBI,
				SUM(HBP) AS HBP,
				SUM(BB)  AS BB,
				SUM(K)   AS K,
				SUM(SB)  AS SB,
				SUM(CS)  AS CS
			FROM Source.SrcHit2017
			GROUP BY PlayerID
			ORDER BY PlayerID;
	QUIT;




;*	SECTION 1.8 - SOLUTIONS   *; RUN;


* --------------------------- *
|   Comprehension Check 1.1   |
* --------------------------- *
	Task:  Create a report which displays all columns from the table containing
			the 2017 fielding data ('Source.SrcField2017')
	Instructions:  Replace each instance of 'Aaaaa' or [keyword] etc   *;
PROC SQL;
	SELECT	*
		FROM Source.SrcField2017;
	QUIT;


* --------------------------- *
|   Comprehension Check 1.2   |
* --------------------------- *
	Task:  Create a report which displays
			1) Player name (Name)
			2) At Bats (AB)
			3) Strikeouts (K)
			4) A newly created column with header 'AB Per K', defined as
				at-bats per strikeout (AB / K), displayed with 1 decimal place
	Instructions:  Replace each instance of 'Aaaaa' etc
					The same value should be placed wherever the same string is seen   *;
PROC SQL NUMBER OUTOBS=10;
	SELECT	Name, AB, K,
			AB / K LABEL = 'AB Per K' FORMAT = 5.1
		FROM Source.SrcHit2017;
	QUIT;


* --------------------------- *
|   Comprehension Check 1.3   |
* --------------------------- *
	Task:  Create a report based on the 'Source.SrcField2017' table which displays
			1) Player name (Name)
			2) Position (POS)
			3) A new column 'Total Chances' (TC), defined a TC = PO+A+E
			Filter the report to display only outfielders (LF, CF, or RF)
				who had at least 300 total chances
	Instructions:  Replace each instance of 'Aaaaa' or [expression] etc
					The same value should be placed wherever the same string is seen   *;
PROC SQL NUMBER;
	SELECT	Name, POS, 
			PO+A+E AS TC LABEL = 'Total Chances'
		FROM Source.SrcField2017
		WHERE	POS IN('LF', 'CF', 'RF') AND
				CALCULATED TC >= 300;
	QUIT;


* --------------------------- *
|   Comprehension Check 1.4   |
* --------------------------- *
	Task:  Create a report based on the 'Source.SrcField2017' table which displays
			1) Player name (Name)
			2) Position (POS)
			3) Double Plays (DP)
			Filter the report to display only infielders (1B, 2B, 3B, and SS)
				who had at least 100 games played (G)
			Order the report by descending double-plays within each position
	Instructions:  Replace each instance of 'Aaaaa' or [expression] etc
					The same value should be placed wherever the same string is seen   *;
PROC SQL NUMBER;
	SELECT	Name, POS, DP
		FROM	Source.SrcField2017
		WHERE	POS IN ('1B', '2B', '3B', 'SS')	AND
				G >= 100
		ORDER BY POS, DP DESCENDING;
	QUIT;


* --------------------------- *
|   Comprehension Check 1.5   |
* --------------------------- *
	Task:  Create a report which displays each 1) player and 2) their total number of home runs
			Order the report by:
				1) Home run frequency from greatest home runs to least, and
				2) Alphabetically (A -> Z) when players are tied on home runs   *;
PROC SQL NUMBER;
	SELECT	Name,
			SUM(HR) AS TotHR
		FROM Source.SrcHit2017
		GROUP BY Name
		ORDER BY TotHR DESCENDING, Name;
	QUIT;


* --------------------------- *
|   Comprehension Check 1.6   |
* --------------------------- *
	Task:  Create a report based on the 'Source.SrcField2017' table which displays
			1) Player ID (PlayerID)
			2) Player name (Name)
			3) Total Assists (based on the 'A' column)
			Filter the report to display only players from the Chicago Cubs (TeamID = '112')
				who had at least 100 total assists
			Order the report by descending number of total assists
	Instructions:  Replace each instance of 'Aaaaa' or [expression] etc
					The same value should be placed wherever the same string is seen   *;
PROC SQL NUMBER;
	SELECT	DISTINCT PlayerID, Name, SUM(A) AS TotA 'Total Assists'
		FROM Source.SrcField2017
		WHERE TeamID = '112'
		GROUP BY PlayerID
		HAVING TotA >= 100
		ORDER BY TotA DESCENDING;
	QUIT;




;   *'; *"; */; QUIT;   RUN;
*   End of Program   *; RUN;

