SET TERM ^ ;

create or alter procedure SP_GETRESULTSTODATE (
    STUDENTID bigint,
    DISCIPLINEID smallint,
    TODATE date,
    EDUPLANID integer,
    MAXMODULENUM smallint,
    ON_FIRST_TESTLIST smallint)
returns (
    TESTLISTS varchar(500),
    SCLAV integer,
    ONLY_E integer,
    DISCIPLINEEXISTS smallint,
    CREDITS_AVG numeric(5,2),
    FX_CREDITS smallint,
    NOT_RANGE smallint,
    F_CREDITS smallint,
    STIMULATIONMARKS smallint,
    EMPTY_CREDITS_EXISTS smallint,
    DISCIPLINE_FINISHED smallint,
    FORMREPORT char(2))
as
declare variable FCREDITS smallint;
declare variable FEMPTY_CREDITS_EXISTS smallint;
declare variable FSUMCREDITS smallint;
declare variable FF_CREDITS smallint;
declare variable FFX_CREDITS smallint;
declare variable MIN_CREDITS_VALUE smallint;
declare variable FTESTLISTID varchar(20);
declare variable FSCLAV smallint;
declare variable FNOT_RANGE smallint;
declare variable FCOUNT smallint;
declare variable FONLY_E smallint;
declare variable VARIANTID bigint;
begin
  select SD.VARIANTID, SD.STIMULATIONMARKS, SD.FORMREPORT
  from V_STUDENT_DISCIPLINES SD
  where SD.STUDENTID = :STUDENTID
  and SD.DISCIPLINEID = :DISCIPLINEID
  and SD.EDUPLANID = :EDUPLANID
  into :VARIANTID, :STIMULATIONMARKS, :FORMREPORT;

  select E.PARAMETERVALUE
  from EDUPARAMETERS E
  where E.PARAMETERID = 5
  into :MIN_CREDITS_VALUE;

  if (not VARIANTID is null) then
  begin
    DISCIPLINEEXISTS = 1;
    CREDITS_AVG = null;
    FCOUNT = 0;
    FX_CREDITS = 0;
    FSUMCREDITS = 0;
    F_CREDITS = 0;
    NOT_RANGE = 0;
    ONLY_E = 0;
    TESTLISTS = '';
    SCLAV = 0;
    EMPTY_CREDITS_EXISTS = null; /* счетчик значений изм:11.04.2013 было 0 */
    DISCIPLINE_FINISHED = 1;
     for select
       (S2T.CREDITS_ALL ) as CREDITS_AVG,
       (case when ((((:FORMREPORT = 'мк') or (:FORMREPORT = 'дз') or (:FORMREPORT = 'іс') )  and (coalesce(S2T.CREDITS_TEST, 0) < :MIN_CREDITS_VALUE)) or (S2T.TESTRESULTID in (-1, -2, -4, -6))) then 1 else 0 end) as FX_CREDITS,
       (case when S2T.TESTRESULTID = -3 then 1 else 0 end) as F_CREDITS,
       (case when (S2T.TESTRESULTID is null) and (S2T.CREDITS_ALL = 0) then 1 else 0 end) as EMPTY_CREDITS_EXISTS,
       (case when S2T.ONLY_E = 1 then 1 else 0 end) as ONLY_E,
       (case when (S2T.TESTRESULTID = -9) then 1 else 0 end) as SCLAV,
       (case when (S2T.TESTRESULTID in (-1, -2, -7, -8)) then 1 else 0 end) as NOT_RANGE,
       cast(TL.TESTLISTID as varchar(20)) as TESTLISTID
      from V_STUDENT_DISCIPLINES SD
      inner join STUDENT2TESTLIST S2T
      on (S2T.STUDENTID = SD.STUDENTID)
      inner join B_VARIANT_ITEMS VI
      on (VI.PARENTVARIANTID = SD.VARIANTID)
      left join B_TESTLIST TL
      on (TL.TESTLISTID = S2T.TESTLISTID)
      and (TL.VARIANTID = VI.VARIANTID)
      and TL.TESTLISTID = (case when :ON_FIRST_TESTLIST = 0 then
        (select first 1 TL1.TESTLISTID
        from STUDENT2TESTLIST S2T1
        inner join B_TESTLIST TL1
        on (TL1.TESTLISTID = S2T1.TESTLISTID)
        where S2T1.STUDENTID = S2T.STUDENTID
        and TL1.VARIANTID = TL.VARIANTID
        and ((TL1.TESTDATE <= :TODATE) or (TL1.TESTDATE is null))
        order by TL1.TESTDATE desc, TL1.TESTLISTID desc)
        else
          (select first 1 TL1.TESTLISTID
        from STUDENT2TESTLIST S2T1
        inner join B_TESTLIST TL1
        on (TL1.TESTLISTID = S2T1.TESTLISTID)
        where S2T1.STUDENTID = S2T.STUDENTID
        and TL1.VARIANTID = TL.VARIANTID
        and ((TL1.TESTDATE <= :TODATE) or (TL1.TESTDATE is null))
        order by TL1.EDUYEAR desc, TL1.SEMESTER desc, TL1.TESTDATE , TL1.TESTLISTID)
      end
      )
      inner join B_VARIANT_MODULE VM
      on (VM.VARIANTID = TL.VARIANTID)
      where SD.STUDENTID = :STUDENTID
      and SD.DISCIPLINEID = :DISCIPLINEID
      and SD.EDUPLANID = :EDUPLANID
      and VM.MODULENUM <= :MAXMODULENUM
      into :FCREDITS, :FFX_CREDITS, :FF_CREDITS, :FEMPTY_CREDITS_EXISTS, :FONLY_E, :FSCLAV, :FNOT_RANGE, :FTESTLISTID
      do
      begin
        FSUMCREDITS = FSUMCREDITS + FCREDITS;
        FX_CREDITS = FX_CREDITS + FFX_CREDITS;
        NOT_RANGE = NOT_RANGE + FNOT_RANGE;
        F_CREDITS = F_CREDITS + FF_CREDITS;
        EMPTY_CREDITS_EXISTS = coalesce(EMPTY_CREDITS_EXISTS, 0) + FEMPTY_CREDITS_EXISTS;
        ONLY_E = ONLY_E + FONLY_E;
        SCLAV = SCLAV + FSCLAV;
        FCOUNT = FCOUNT + 1;
        if (TESTLISTS = '') then TESTLISTS = FTESTLISTID;
        else TESTLISTS = TESTLISTS|| ', ' || FTESTLISTID;
      end
     if (FCOUNT > 0) then
     CREDITS_AVG =  cast(cast(FSUMCREDITS as numeric(5,2)) /cast(FCOUNT as numeric(5,2)) as numeric(5,2));
    select first 1 0
    from STUDENT2VARIANT S2V
    inner join B_VARIANT_ITEMS VI
    on (VI.PARENTVARIANTID = S2V.VARIANTID)
    where S2V.VARIANTID = :VARIANTID
    and S2V.EDUPLANID = :EDUPLANID
    and not exists (
      select *
      from STUDENT2TESTLIST S2T
      inner join B_TESTLIST TL
      on (TL.TESTLISTID = S2T.TESTLISTID)
      inner join B_VARIANT_MODULE VM
      on (VM.VARIANTID = TL.VARIANTID)
      where S2T.STUDENTID = :STUDENTID
      and TL.VARIANTID = VI.VARIANTID
      and TL.TESTDATE <= :TODATE
      and VM.MODULENUM <= :MAXMODULENUM
    )
    into :DISCIPLINE_FINISHED;
  end
  else
  begin
    DISCIPLINEEXISTS = 0;
  end

  suspend;
end^

SET TERM ; ^

/* Following GRANT statetements are generated automatically */

GRANT SELECT ON V_STUDENT_DISCIPLINES TO PROCEDURE SP_GETRESULTSTODATE;
GRANT SELECT ON EDUPARAMETERS TO PROCEDURE SP_GETRESULTSTODATE;
GRANT SELECT ON STUDENT2TESTLIST TO PROCEDURE SP_GETRESULTSTODATE;
GRANT SELECT ON B_VARIANT_ITEMS TO PROCEDURE SP_GETRESULTSTODATE;
GRANT SELECT ON B_TESTLIST TO PROCEDURE SP_GETRESULTSTODATE;
GRANT SELECT ON B_VARIANT_MODULE TO PROCEDURE SP_GETRESULTSTODATE;
GRANT SELECT ON STUDENT2VARIANT TO PROCEDURE SP_GETRESULTSTODATE;

/* Existing privileges on this procedure */

GRANT EXECUTE ON PROCEDURE SP_GETRESULTSTODATE TO SYSDBA;
GRANT EXECUTE ON PROCEDURE SP_GETRESULTSTODATE TO CONTINGENT_OPERATOR;
GRANT EXECUTE ON PROCEDURE SP_GETRESULTSTODATE TO CONTINGENT_WEB;