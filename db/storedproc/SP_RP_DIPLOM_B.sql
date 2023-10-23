SET TERM ^ ;

create or alter procedure sp_rp_diplom_b (
    studentid bigint,
    exclude_1k varchar(5),
    exclude_pzso varchar(5))
returns (
    hours smallint,
    markstr varchar(20),
    discipline varchar(150),
    credits_avg numeric(5,2),
    ects varchar(2),
    credits numeric(5,2),
    eduyear smallint,
    semester smallint,
    end_semester smallint,
    end_eduyear smallint,
    discipline_eng varchar(150),
    markstr_eng varchar(20),
    markstr_c varchar(20),
    markstr_eng_c varchar(20),
    disciplinetype char(1))
as
declare variable disciplineid integer;
declare variable maxweight smallint;
begin
  /* Procedure Text */
  CREDITS = null;
  for
    select SM.DISCIPLINEID,
           SM.DISCIPLINETYPE,
           GD.DISCIPLINE,
           GD.DISCIPLINE_ENG,
           SM.SEMESTER,
           SM.EDUYEAR,
           SM.SEMESTER,
           SM.EDUYEAR,
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
        and  (not(SM.DISCIPLINETYPE in ('П', 'Ц')))
        and not SM.FORMREPORT in ('де','дд','дк','дп','дм')
        and SM.MARKID <> 10020 /* Освобождён */
        and (
          ('True' <> :EXCLUDE_1K)
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
      group by SM.DISCIPLINETYPE, SM.DISCIPLINEID, GD.DISCIPLINE, GD.DISCIPLINE_ENG, SM.SEMESTER, SM.EDUYEAR,
              SM.SEMESTER, SM.EDUYEAR
      order by 2
      into :DISCIPLINETYPE, :DISCIPLINEID, :DISCIPLINE, :DISCIPLINE_ENG, :SEMESTER, :EDUYEAR, :END_SEMESTER,
           :END_EDUYEAR, :HOURS, :MAXWEIGHT do
  begin
    MARKSTR = null;
    MARKSTR_C = null;
    MARKSTR_ENG = null;
    MARKSTR_ENG_C = null;
    CREDITS_AVG = null;
    ECTS = null;

    select first 1 GM.MARKSTR, GM.MARKSTR_ENG, GM.MARKSTR AS MARKSTR_C, GM.MARKSTR_ENG AS MARKSTR_ENG_C
    from V_LASTSESSIONMARKS SM
    inner join V_GUIDE_FORMREPORT FR
      on (FR.FORMREPORT = SM.FORMREPORT)
    inner join V_GUIDE_MARKTYPE GM
      on (GM.MARKID = SM.MARKID)

    where SM.STUDENTID = :STUDENTID
      and SM.DISCIPLINEID = :DISCIPLINEID
      and (not(SM.DISCIPLINETYPE in ('П', 'Ц')))
      and SM.MARKID <> 10020 /* Освобождён */
      and FR.WEIGHT = :MAXWEIGHT
      and (
        ('False' = :EXCLUDE_1K)
        or (not SM.SEMESTER in (1, 2))
      )
    order by SM.SEMESTER desc, GM.MARKNUM desc
    into :MARKSTR, :MARKSTR_ENG, :MARKSTR_C, :MARKSTR_ENG_C;

    suspend;
  end

  for
    select LP.DISCIPLINETYPE,
           LP.DISCIPLINEID,
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
        and not FR.FORMREPORT = 'да'
        and not FR.FORMREPORT = 'де'
        and (
          ('True' <> :EXCLUDE_1K)
          or (not LP.SEMESTER in (1, 2))
        )
      group by LP.DISCIPLINETYPE, LP.DISCIPLINEID, GD.DISCIPLINE, GD.DISCIPLINE_ENG, LP.SEMESTER, LP.EDUYEAR,
              LP.END_SEMESTER, LP.END_EDUYEAR
      into :DISCIPLINETYPE, :DISCIPLINEID, :DISCIPLINE, :DISCIPLINE_ENG, :SEMESTER, :EDUYEAR, :END_SEMESTER,
           :END_EDUYEAR, :HOURS, :CREDITS do
  begin
    MARKSTR = null;
    MARKSTR_C = null;
    MARKSTR_ENG = null;
    MARKSTR_ENG_C = null;
    CREDITS_AVG = null;
    ECTS = null;

    select first 1 GM.MARKSTR, GM.MARKSTR_ENG, S2P.CREDITS_AVG, S2p.ECTS, GM.MARKSTR_C, GM.MARKSTR_ENG_C
    from RANKING_PROTOCOLS RP
    inner join STUDENT2PROTOCOL S2P
    on RP.PROTOCOLID = S2P.PROTOCOLID
    left join V_GUIDE_TRADITIONAL_MARK GM
      on (GM.TRADITIONAL_MARKID = S2P.TRADITIONALMARK)

    where S2P.STUDENTID = :STUDENTID
          and RP.DISCIPLINEID = :DISCIPLINEID
          and not RP.PROTOCOLDATE is null
    order by RP.CREATEDATE desc
    into :MARKSTR, :MARKSTR_ENG, :CREDITS_AVG, :ECTS, :MARKSTR_C, :MARKSTR_ENG_C;

    suspend;
  end
end^

SET TERM ; ^

/* Following GRANT statements are generated automatically */

GRANT SELECT ON V_LASTSESSIONMARKS TO PROCEDURE SP_RP_DIPLOM_B;
GRANT SELECT ON V_GUIDE_DISCIPLINE TO PROCEDURE SP_RP_DIPLOM_B;
GRANT SELECT ON V_GUIDE_FORMREPORT TO PROCEDURE SP_RP_DIPLOM_B;
GRANT SELECT ON STUDENT2VARIANT TO PROCEDURE SP_RP_DIPLOM_B;
GRANT SELECT ON DISCIPLINE_EDULEVEL TO PROCEDURE SP_RP_DIPLOM_B;
GRANT SELECT ON V_GUIDE_MARKTYPE TO PROCEDURE SP_RP_DIPLOM_B;
GRANT SELECT ON V_STUDENT_DISCIPLINES_LAST TO PROCEDURE SP_RP_DIPLOM_B;
GRANT SELECT ON B_VARIANT_ITEMS TO PROCEDURE SP_RP_DIPLOM_B;
GRANT SELECT ON B_VARIANT_MODULE TO PROCEDURE SP_RP_DIPLOM_B;
GRANT SELECT ON B_VARIANT_DISCIPLINE TO PROCEDURE SP_RP_DIPLOM_B;
GRANT SELECT ON V_GUIDE_FORMREPORT_B TO PROCEDURE SP_RP_DIPLOM_B;
GRANT SELECT ON RANKING_PROTOCOLS TO PROCEDURE SP_RP_DIPLOM_B;
GRANT SELECT ON STUDENT2PROTOCOL TO PROCEDURE SP_RP_DIPLOM_B;
GRANT SELECT ON V_GUIDE_TRADITIONAL_MARK TO PROCEDURE SP_RP_DIPLOM_B;

/* Existing privileges on this procedure */

GRANT EXECUTE ON PROCEDURE SP_RP_DIPLOM_B TO SYSDBA;
GRANT EXECUTE ON PROCEDURE SP_RP_DIPLOM_B TO CONTINGENT_OPERATOR;
GRANT EXECUTE ON PROCEDURE SP_RP_DIPLOM_B TO CONTINGENT_REPLICATOR;