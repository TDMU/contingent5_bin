SET TERM ^ ;

create or alter procedure sp_rp_diplom_state_b (
    studentid bigint,
    exclude_1k varchar(5),
    exclude_pzso varchar(5))
returns (
    markstr varchar(20),
    discipline varchar(150),
    ects varchar(10),
    eduyear smallint,
    end_semester smallint,
    end_eduyear smallint,
    semester smallint,
    discipline_eng varchar(150),
    credits_avg numeric(5,2),
    credits numeric(5,2),
    hours smallint)
as
declare variable disciplineid integer;
declare variable maxweight smallint;
begin
  /* Procedure Text */
  CREDITS = null;
  for
    select SM.SEMESTER,
           SM.DISCIPLINEID,
           SM.EDUYEAR,
           SM.SEMESTER,
           SM.EDUYEAR,
           GD.DISCIPLINE,
           GD.DISCIPLINE_ENG,
           sum(SM.ALLHOURS),
           max(FR.WEIGHT)
      from V_LASTSESSIONMARKS SM
      inner join V_GUIDE_DISCIPLINE GD
        on (GD.DISCIPLINEID = SM.DISCIPLINEID)
      inner join V_GUIDE_FORMREPORT FR
        on (FR.FORMREPORT = SM.FORMREPORT)
      left join STUDENT2VARIANT SV
      on SV.STUDENTID = SM.STUDENTID
         and SV.DISCIPLINEID = SM.DISCIPLINEID
      where SM.STUDENTID = :STUDENTID
        and SM.FORMREPORT = 'де'
        and SM.MARKID <> 10020 /* Освобождён */
        and (
          ('False' = :EXCLUDE_1K)
          or (not SM.SEMESTER in (1, 2))
            )
        and (
          ('True' <> :EXCLUDE_PZSO)
          or (not exists(
            select 1 from DISCIPLINE_EDULEVEL D_EL
            where D_EL.DISCIPLINEID = SM.DISCIPLINEID
              and D_EL.STUDENTID = :STUDENTID
              and D_EL.PLANID = SM.PLANID)
             )
            )
        and SV.VARIANTID is Null
      group by SM.SEMESTER, SM.DISCIPLINEID, GD.DISCIPLINE, GD.DISCIPLINE_ENG, SM.EDUYEAR,
              SM.SEMESTER, SM.EDUYEAR
      order by SM.SEMESTER, GD.DISCIPLINE
      into :SEMESTER, :DISCIPLINEID, :DISCIPLINE, :DISCIPLINE_ENG, :EDUYEAR, :END_SEMESTER,
           :END_EDUYEAR, :HOURS, :MAXWEIGHT do
  begin
    MARKSTR = null;
    CREDITS_AVG = null;
    ECTS = null;

    select first 1 GM.MARKSTR
    from V_LASTSESSIONMARKS SM
    inner join V_GUIDE_FORMREPORT FR
      on (FR.FORMREPORT = SM.FORMREPORT)
    inner join V_GUIDE_MARKTYPE GM
      on (GM.MARKID = SM.MARKID)

    where SM.STUDENTID = :STUDENTID
      and SM.DISCIPLINEID = :DISCIPLINEID
      and SM.FORMREPORT = 'де'
      and SM.MARKID <> 10020 /* Освобождён */
      and FR.WEIGHT = :MAXWEIGHT
      and (
        ('False' = :EXCLUDE_1K)
        or (not SM.SEMESTER in (1, 2))
      )
    order by SM.SEMESTER desc, GM.MARKNUM desc
    into :MARKSTR;

    suspend;
  end

  for
    select LP.DISCIPLINEID,
           GD.DISCIPLINE,
           GD.DISCIPLINE_ENG, 
           LP.SEMESTER,
           LP.EDUYEAR,
           LP.END_SEMESTER,
           LP.END_EDUYEAR,

           (select sum(VM.HOURS_ALL)
           from V_STUDENT_DISCIPLINES_LAST STL
           inner join B_VARIANT_ITEMS VI
           on VI.PARENTVARIANTID = STL.VARIANTID
           inner join B_VARIANT_MODULE VM
           on VM.VARIANTID = VI.VARIANTID
           where STL.DISCIPLINEID = LP.DISCIPLINEID
                 and STL.STUDENTID = :STUDENTID) as HOURS,

           (select sum(VM.CREDITS)
           from V_STUDENT_DISCIPLINES_LAST STL
           inner join B_VARIANT_ITEMS VI
           on VI.PARENTVARIANTID = STL.VARIANTID
           inner join B_VARIANT_MODULE VM
           on VM.VARIANTID = VI.VARIANTID
           where STL.DISCIPLINEID = LP.DISCIPLINEID
                 and STL.STUDENTID = :STUDENTID) as CREDITS

      from V_STUDENT_DISCIPLINES_LAST LP
      inner join V_GUIDE_DISCIPLINE GD
        on (GD.DISCIPLINEID = LP.DISCIPLINEID)
      inner join B_VARIANT_DISCIPLINE BVD
      on BVD.VARIANTID = LP.VARIANTID
      inner join V_GUIDE_FORMREPORT_B FR
        on (FR.FORMREPORT = BVD.FORMREPORT)
      where LP.STUDENTID = :STUDENTID
        and LP.DISCIPLINETYPE <> 'П'
        and (FR.FORMREPORT = 'да' or FR.FORMREPORT = 'де')
        and (
          ('True' <> :EXCLUDE_1K)
          or (not LP.SEMESTER in (1, 2))
        )
      into :DISCIPLINEID, :DISCIPLINE, :DISCIPLINE_ENG, :SEMESTER, :EDUYEAR, :END_SEMESTER,
           :END_EDUYEAR, :HOURS, :CREDITS do
  begin
    MARKSTR = null;
    CREDITS_AVG = null;
    ECTS = null;

    select first 1 GM.MARKSTR, S2P.CREDITS_AVG, S2p.ECTS
    from RANKING_PROTOCOLS RP
    inner join STUDENT2PROTOCOL S2P
    on RP.PROTOCOLID = S2P.PROTOCOLID
    left join V_GUIDE_TRADITIONAL_MARK GM
      on (GM.TRADITIONAL_MARKID = S2P.TRADITIONALMARK)
    where S2P.STUDENTID = :STUDENTID
          and RP.DISCIPLINEID = :DISCIPLINEID
          and not RP.PROTOCOLDATE is null
    order by RP.PROTOCOLDATE desc
    into :MARKSTR, :CREDITS_AVG, :ECTS;

    if (ECTS = 'S') then
    begin
      ECTS = 'склав';
      MARKSTR = 'склав';
    end
    if (ECTS = 'NS') then
    begin
      ECTS = 'не склав';
      MARKSTR = 'не склав';
    end
    suspend;
  end
end^

SET TERM ; ^

/* Following GRANT statements are generated automatically */

GRANT SELECT ON V_LASTSESSIONMARKS TO PROCEDURE SP_RP_DIPLOM_STATE_B;
GRANT SELECT ON V_GUIDE_DISCIPLINE TO PROCEDURE SP_RP_DIPLOM_STATE_B;
GRANT SELECT ON V_GUIDE_FORMREPORT TO PROCEDURE SP_RP_DIPLOM_STATE_B;
GRANT SELECT ON STUDENT2VARIANT TO PROCEDURE SP_RP_DIPLOM_STATE_B;
GRANT SELECT ON DISCIPLINE_EDULEVEL TO PROCEDURE SP_RP_DIPLOM_STATE_B;
GRANT SELECT ON V_GUIDE_MARKTYPE TO PROCEDURE SP_RP_DIPLOM_STATE_B;
GRANT SELECT ON V_STUDENT_DISCIPLINES_LAST TO PROCEDURE SP_RP_DIPLOM_STATE_B;
GRANT SELECT ON B_VARIANT_ITEMS TO PROCEDURE SP_RP_DIPLOM_STATE_B;
GRANT SELECT ON B_VARIANT_MODULE TO PROCEDURE SP_RP_DIPLOM_STATE_B;
GRANT SELECT ON B_VARIANT_DISCIPLINE TO PROCEDURE SP_RP_DIPLOM_STATE_B;
GRANT SELECT ON V_GUIDE_FORMREPORT_B TO PROCEDURE SP_RP_DIPLOM_STATE_B;
GRANT SELECT ON RANKING_PROTOCOLS TO PROCEDURE SP_RP_DIPLOM_STATE_B;
GRANT SELECT ON STUDENT2PROTOCOL TO PROCEDURE SP_RP_DIPLOM_STATE_B;
GRANT SELECT ON V_GUIDE_TRADITIONAL_MARK TO PROCEDURE SP_RP_DIPLOM_STATE_B;

/* Existing privileges on this procedure */

GRANT EXECUTE ON PROCEDURE SP_RP_DIPLOM_STATE_B TO SYSDBA;
GRANT EXECUTE ON PROCEDURE SP_RP_DIPLOM_STATE_B TO CONTINGENT_OPERATOR;
GRANT EXECUTE ON PROCEDURE SP_RP_DIPLOM_STATE_B TO CONTINGENT_REPLICATOR;