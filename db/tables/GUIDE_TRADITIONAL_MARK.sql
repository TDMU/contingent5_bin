/******************************************************************************/
/*                 Generated by IBExpert 07.02.2021 18:56:52                  */
/******************************************************************************/

/******************************************************************************/
/*        Following SET SQL DIALECT is just for the Database Comparer         */
/******************************************************************************/
SET SQL DIALECT 3;



/******************************************************************************/
/*                                   Tables                                   */
/******************************************************************************/



CREATE TABLE GUIDE_TRADITIONAL_MARK (
    TRADITIONAL_MARKID    D$SMALLINT NOT NULL /* D$SMALLINT = SMALLINT */,
    TRADITIONAL_MARK      D$VARCHAR20 /* D$VARCHAR20 = VARCHAR(20) */,
    CREDITS_MIN           D$NUMERIC_5_2 /* D$NUMERIC_5_2 = NUMERIC(5,2) */,
    MARKSTR               D$VARCHAR20 /* D$VARCHAR20 = VARCHAR(20) */,
    MARKSTR_ENG           D$VARCHAR20 /* D$VARCHAR20 = VARCHAR(20) */,
    MARKSTR_RUS           D$VARCHAR20 /* D$VARCHAR20 = VARCHAR(20) */,
    TRADITIONAL_MARK_RUS  D$VARCHAR20 /* D$VARCHAR20 = VARCHAR(20) */,
    MARKSTR_C             D$VARCHAR20 /* D$VARCHAR20 = VARCHAR(20) */,
    MARKSTR_ENG_C         D$VARCHAR20 /* D$VARCHAR20 = VARCHAR(20) */
);




/******************************************************************************/
/*                                Primary keys                                */
/******************************************************************************/

ALTER TABLE GUIDE_TRADITIONAL_MARK ADD CONSTRAINT PK_GUIDE_TRADITIONAL_MARK PRIMARY KEY (TRADITIONAL_MARKID);


/******************************************************************************/
/*                                 Privileges                                 */
/******************************************************************************/


/* Privileges of users */
GRANT SELECT ON GUIDE_TRADITIONAL_MARK TO LIBRARY;
GRANT SELECT ON GUIDE_TRADITIONAL_MARK TO MILENIUM;

/* Privileges of roles */
GRANT SELECT, UPDATE ON GUIDE_TRADITIONAL_MARK TO CONTINGENT_OPERATOR;
GRANT ALL ON GUIDE_TRADITIONAL_MARK TO CONTINGENT_REPLICATOR;
GRANT SELECT ON GUIDE_TRADITIONAL_MARK TO CONTINGENT_WEB;