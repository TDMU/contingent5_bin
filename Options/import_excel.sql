/*
*       Импорт студентов из Excel
*       Firebird 2.5
*       ранее использовалась SP_IMP_STUDENTS
*/
execute block (
    ORDERID bigint = :ORDERID,
    ENTERDATE date = :ENTERDATE,
    FIO varchar(70) = :FIO,
    SEX char(1) = :SEX,
    BIRTHDATE date = :BIRTHDATE,
    CITIZENSHIP varchar(100) = :CITIZENSHIP,
    REGION varchar(100) = :REGION,
    ADDRESS blob sub_type 1 segment size 80 = :ADDRESS,
    SPECIALITYCODE varchar(10) = :SPECIALITYCODE,
    EDUFORMID char(2) = :EDUFORMID,
    EDUBASISID char(1) = :EDUBASISID,
    SEMESTER smallint = :SEMESTER,
    EDUTERM float = :EDUTERM,
    PHOTO blob sub_type 0 segment size 80 = :PHOTO,
    IDCODE char(10) = :IDCODE,
    FAMILYSTATUS char(1) = :FAMILYSTATUS,
    PREVIOUSEDUCATION varchar(2) = :PREVIOUSEDUCATION,
    PREVIOUSDOCUMENT varchar(2) = :PREVIOUSDOCUMENT,
    PREVIOUSDOCUMENTNUM varchar(15) = :PREVIOUSDOCUMENTNUM,
    PRIVILEGEID integer = :PRIVILEGEID,
    PASSPORTNUM varchar(15) = :PASSPORTNUM,
    PASSPORTGIVEDATE date = :PASSPORTGIVEDATE,
    PASSPORTGIVEPLACE blob sub_type 1 segment size 80 = :PASSPORTGIVEPLACE,
    ADDRESSOFPARENTS blob sub_type 1 segment size 80 = :ADDRESSOFPARENTS,
    USERNAME varchar(31) = :USERNAME,
    NOTE blob sub_type 1 segment size 100 = :NOTE,
    EDUCATIONALINSTITUTION blob sub_type 0 segment size 80 = :EDUCATIONALINSTITUTION,
    PRIVATEAFFAIRNUM varchar(15) = :PRIVATEAFFAIRNUM,
    EDBO_IDPERSON integer = :EDBO_IDPERSON,
    EDBO_KOATUUCODE varchar(10) = :EDBO_KOATUUCODE,
    EDBO_CITY varchar(150) = :EDBO_CITY,
    EDBO_STREET varchar(150) = :EDBO_STREET,
    EDBO_HOUSE varchar(100) = :EDBO_HOUSE,
    EDBO_BUILDING varchar(100) = :EDBO_BUILDING,
    EDBO_FLAT varchar(100) = :EDBO_FLAT
)
as
declare variable REGIONID smallint;
declare variable SPECIALITYID smallint;
declare variable DEPARTMENTID smallint;
declare variable COUNTRYID smallint;
declare variable STUDENTID bigint;
declare variable STATUS char(1);
declare variable EDBO_KOATUUADDRESS varchar(500);
begin
  if (not (Exists(
    select 1
    from SEC_USERS_HISTORY U
    where U.USERNAME = :USERNAME
  ))) then
    USERNAME = null;


  if (not (REGION is null or REGION = '')) then
  begin
    select GR.REGIONID
    from V_GUIDE_REGION GR
    where GR.REGIONNAME = :REGION
    into REGIONID;

    if (REGIONID is null) then
      exception E_CUSTOMEXCEPTION 'Область не знайдено в довіднику: ' || coalesce(REGION, '');
  end
  else
    REGIONID = null;

  select GC.COUNTRYID
  from V_GUIDE_COUNTRY GC
  where (GC.COUNTRYNAME = :CITIZENSHIP)
    or (cast(GC.COUNTRYID as varchar(50)) = :CITIZENSHIP)
  into COUNTRYID;

  if (COUNTRYID is null) then
    exception E_CUSTOMEXCEPTION 'Країну не знайдено в довіднику: ' || coalesce(CITIZENSHIP, '');

  if (FAMILYSTATUS = '') then FAMILYSTATUS = null;
  if (
    not (FAMILYSTATUS is null) and
    not exists(select 1 from V_GUIDE_FAMILYSTATUS where FAMILYSTATUS = :FAMILYSTATUS)
  )
  then
    exception E_CUSTOMEXCEPTION 'Сімейний стан не знайдено в довіднику: ' || coalesce(:FAMILYSTATUS, '');

  if (
    not (PRIVILEGEID is null) and
    not exists(select 1 from GUIDE_PRIVILEGE where PRIVILEGEID = :PRIVILEGEID)
  ) then
    exception E_CUSTOMEXCEPTION 'Пільги при вступі не знайдено в довіднику: ' || coalesce(:PRIVILEGEID, '');

  if (ORDERID is not null) then
  begin
    select O.DEPARTMENTID
    from ORDERS O
    where O.ORDERID = :ORDERID
    into :DEPARTMENTID;

    select GSP.SPECIALITYID
    from GUIDE_SPECIALITY GSP
    where GSP.CODE = :SPECIALITYCODE
    into SPECIALITYID;

    if (SPECIALITYID is null) then
      exception E_CUSTOMEXCEPTION 'Спеціальність не знайдено в довіднику: ' || coalesce(SPECIALITYCODE, '');

    if (not Exists (select * from V_GUIDE_EDUBASIS where EDUBASISID = :EDUBASISID)) then
      exception E_CUSTOMEXCEPTION 'Форму фінансування не знайдено в довіднику: ' || coalesce(EDUBASISID, '');

    if (not Exists (select * from V_GUIDE_EDUFORM where EDUFORMID = :EDUFORMID)) then
      exception E_CUSTOMEXCEPTION 'Форму навчання не знайдено в довіднику: ' || coalesce(EDUFORMID, '');

    STATUS = 'С';
  end
  else
  begin
    DEPARTMENTID = null;
    SPECIALITYID = null;
    EDUBASISID = null;
    EDUFORMID = null;
    SEMESTER = null;
    ENTERDATE = null;
    STATUS = null;
  end

  select ID from SP_GEN_UID into :STUDENTID;

  EDBO_KOATUUCODE = trim(EDBO_KOATUUCODE);
  if (EDBO_KOATUUCODE = '') then 
    EDBO_KOATUUCODE = null;
  else  
    EDBO_KOATUUCODE = lpad(EDBO_KOATUUCODE, 10, '0');

  EDBO_CITY = trim(EDBO_CITY);
  if (EDBO_CITY = '') then EDBO_CITY = null;

  if (not (EDBO_KOATUUCODE = null)) then
  begin
    EDBO_KOATUUADDRESS =
      cast (
          (select list(GT.TITLE, ', ')
           from GUIDE_KOATUU GT
           where GT.KOATUUCODE in (
             rpad(left(:EDBO_KOATUUCODE, 2), 10, '0'),
             rpad(left(:EDBO_KOATUUCODE, 5), 10, '0'),
             rpad(left(:EDBO_KOATUUCODE, 8), 10, '0'),
                       :EDBO_KOATUUCODE)
           and GT.USE = 1
          ) as varchar(500) );
    if (EDBO_CITY = null) then
    begin
      EDBO_CITY = 
        (select first 1 GT.TITLE
         from GUIDE_KOATUU GT
         where GT.KOATUUCODE in (
             rpad(left(:EDBO_KOATUUCODE, 2), 10, '0'),
             rpad(left(:EDBO_KOATUUCODE, 5), 10, '0'),
             rpad(left(:EDBO_KOATUUCODE, 8), 10, '0'),
                       :EDBO_KOATUUCODE)
           and GT.USE = 1
           and GT.TYPEKOATUU in ('Т','Щ','М','С')
         order by GT.KOATUUCODE desc);
    end
  end

  EDBO_STREET = trim(EDBO_STREET);
  if (EDBO_STREET = '') then EDBO_STREET = null;
  EDBO_HOUSE = trim(EDBO_HOUSE);
  if (EDBO_HOUSE = '') then EDBO_HOUSE = null;
  EDBO_BUILDING = trim(EDBO_BUILDING);
  if (EDBO_BUILDING = '') then EDBO_BUILDING = null;
  EDBO_FLAT = trim(EDBO_FLAT);
  if (EDBO_FLAT = '') then EDBO_FLAT = null;

  insert into STUDENTS (STUDENTID, FIO, SEX, BIRTHDATE, REGIONID, ADDRESSBEFORE,
    ENTERDATE, SPECIALITYID, DEPARTMENTID, EDUFORMID, EDUBASISID, SEMESTER,
    EDUYEAR, STATUS, EDUTERM, PHOTO, IDCODE, FAMILYSTATUS, PREVIOUSEDUCATION,
    PREVIOUSDOCUMENT, PREVIOUSDOCUMENTNUM, EDUCATIONALINSTITUTION, PRIVATEAFFAIRNUM,
    PRIVILEGEID, PASSPORTNUM,
    PASSPORTGIVEDATE, PASSPORTGIVEPLACE, ADDRESSOFPARENTS, OWNER, NOTE,
    EDBO_IDPERSON, EDBO_KOATUUCODE, EDBO_KOATUUADDRESS, EDBO_CITY, EDBO_STREET, EDBO_HOUSE,
    EDBO_BUILDING, EDBO_FLAT)
  values (:STUDENTID, :FIO, :SEX, :BIRTHDATE, :REGIONID, :ADDRESS, :ENTERDATE,
    :SPECIALITYID, :DEPARTMENTID, :EDUFORMID, :EDUBASISID, :SEMESTER,
    Extract(Year from :ENTERDATE), :STATUS, :EDUTERM, :PHOTO, :IDCODE, :FAMILYSTATUS,
    :PREVIOUSEDUCATION, :PREVIOUSDOCUMENT, :PREVIOUSDOCUMENTNUM, :EDUCATIONALINSTITUTION,
    :PRIVATEAFFAIRNUM, :PRIVILEGEID,
    :PASSPORTNUM, :PASSPORTGIVEDATE, :PASSPORTGIVEPLACE, :ADDRESSOFPARENTS, :USERNAME, :NOTE,
    :EDBO_IDPERSON, :EDBO_KOATUUCODE, :EDBO_KOATUUADDRESS, :EDBO_CITY, :EDBO_STREET, :EDBO_HOUSE,
    :EDBO_BUILDING, :EDBO_FLAT);

  insert into HS_COUNTRY (STUDENTID, BEGINDATE, COUNTRYID)
  values (:STUDENTID, '01/01/1900', :COUNTRYID);

  if (ORDERID is not null) then
  begin
    insert into HS_MOVEMENT(STUDENTID, ORDERID, BEGINDATE, SPECIALITYID,
      DEPARTMENTID, EDUBASISID, EDUFORMID, EDUTERM, SEMESTER, EDUYEAR, STATUS)
    values (:STUDENTID, :ORDERID, :ENTERDATE, :SPECIALITYID, :DEPARTMENTID,
      :EDUBASISID, :EDUFORMID, :EDUTERM, :SEMESTER, Extract(Year from :ENTERDATE), 'С');
  
    insert into STUDENTTOORDER (STUDENTID, ORDERID, REASONID)
    values (:STUDENTID, :ORDERID, 1);
  
    execute procedure SP_STUDENTMOVEMENT_CALC(:STUDENTID);
  end
end