begin
  /* Procedure Text */
  CS1 = 0;
  CS2 = 0;
  CS3 = 0;
  CS4 = 0;
  CS5 = 0;
  CS6 = 0;
  CS7 = 0;
  CIN1 = 0;
  CIN2 = 0;
  CIN3 = 0;
  CIN4 = 0;
  CIN5 = 0;
  CIN6 = 0;
  CIN7 = 0;
  COUT1 = 0;
  COUT2 = 0;
  COUT3 = 0;
  COUT4 = 0;
  COUT5 = 0;
  COUT6 = 0;
  COUT7 = 0;
  FIRSTREC = 1;
  for
      select NUM, EDUFORMID, EDUBASISID, COUNTRYID, COUNTRYTYPE, DEPARTMENTID, SPECIALITYID,
             COURSE, COURSE_STATUS
      from SP_EXP_MOZ(:D1, :D2, :NEW_MOVING_ONLY, :MOVING_ONLY, :GOLD_ONLY)
      order by EDUFORMID, EDUBASISID, COUNTRYTYPE, DEPARTMENTID, SPECIALITYID
      into :NUM, :NEW_EDUFORMID, :NEW_EDUBASISID,:NEW_COUNTRYID, :NEW_COUNTRYTYPE,
           :NEW_DEPARTMENTID, :NEW_SPECIALITYID, :COURSE, :COURSE_STATUS
  do
  begin
     if (not((NEW_EDUFORMID is null)
             or(NEW_EDUBASISID is null)
             or(NEW_COUNTRYID is null)
             or(NEW_COUNTRYTYPE is null)
             or(NEW_DEPARTMENTID is null)
             or(NEW_SPECIALITYID is null)
            )
        ) then
     begin
         if (FIRSTREC = 1) then
         begin
            FIRSTREC = 0;
            EDUFORMID = NEW_EDUFORMID;
            EDUBASISID = NEW_EDUBASISID;
            COUNTRYID = NEW_COUNTRYID;
            COUNTRYTYPE = NEW_COUNTRYTYPE;
            DEPARTMENTID = NEW_DEPARTMENTID;
            SPECIALITYID = NEW_SPECIALITYID;
         end
         else
         begin
           if ((EDUFORMID <> NEW_EDUFORMID) or
               (EDUBASISID <> NEW_EDUBASISID) or
               (COUNTRYID <> NEW_COUNTRYID) or
               (COUNTRYTYPE <> NEW_COUNTRYTYPE) or
               (DEPARTMENTID <> NEW_DEPARTMENTID) or
               (SPECIALITYID <> NEW_SPECIALITYID)) then
           begin
                suspend;
                CS1 = 0;
                CS2 = 0;
                CS3 = 0;
                CS4 = 0;
                CS5 = 0;
                CS6 = 0;
                CS7 = 0;
                CIN1 = 0;
                CIN2 = 0;
                CIN3 = 0;
                CIN4 = 0;
                CIN5 = 0;
                CIN6 = 0;
                CIN7 = 0;
                COUT1 = 0;
                COUT2 = 0;
                COUT3 = 0;
                COUT4 = 0;
                COUT5 = 0;
                COUT6 = 0;
                COUT7 = 0;
                EDUFORMID = NEW_EDUFORMID;
                EDUBASISID = NEW_EDUBASISID;
                COUNTRYID = NEW_COUNTRYID;
                COUNTRYTYPE = NEW_COUNTRYTYPE;
                DEPARTMENTID = NEW_DEPARTMENTID;
                SPECIALITYID = NEW_SPECIALITYID;
           end -- any change in keyfields
         end
         -- if (NUM is null) then NUM = 0;
         if (COURSE_STATUS = 0) then
         begin
            if (COURSE = 1)      then CS1 = CS1 + NUM;
            else if (COURSE = 2) then CS2 = CS2 + NUM;
            else if (COURSE = 3) then CS3 = CS3 + NUM;
            else if (COURSE = 4) then CS4 = CS4 + NUM;
            else if (COURSE = 5) then CS5 = CS5 + NUM;
            else if (COURSE = 6) then CS6 = CS6 + NUM;
            else if (COURSE = 7) then CS7 = CS7 + NUM;
         end
         else
         if (COURSE_STATUS = 1) then
         begin
            if (COURSE = 1)      then CIN1 = CIN1 + NUM;
            else if (COURSE = 2) then CIN2 = CIN2 + NUM;
            else if (COURSE = 3) then CIN3 = CIN3 + NUM;
            else if (COURSE = 4) then CIN4 = CIN4 + NUM;
            else if (COURSE = 5) then CIN5 = CIN5 + NUM;
            else if (COURSE = 6) then CIN6 = CIN6 + NUM;
            else if (COURSE = 7) then CIN7 = CIN7 + NUM;
         end
         else
         if (COURSE_STATUS = 2) then
         begin
            if (COURSE = 1)      then COUT1 = COUT1 + NUM;
            else if (COURSE = 2) then COUT2 = COUT2 + NUM;
            else if (COURSE = 3) then COUT3 = COUT3 + NUM;
            else if (COURSE = 4) then COUT4 = COUT4 + NUM;
            else if (COURSE = 5) then COUT5 = COUT5 + NUM;
            else if (COURSE = 6) then COUT6 = COUT6 + NUM;
            else if (COURSE = 7) then COUT7 = COUT7 + NUM;
         end
     end -- not null
  end -- main

  if (not((NEW_EDUFORMID is null)
          or(NEW_EDUBASISID is null)
          or(NEW_COUNTRYID is null)
          or(NEW_COUNTRYTYPE is null)
          or(NEW_DEPARTMENTID is null)
          or(NEW_SPECIALITYID is null)
         )
     ) then
  begin
     suspend;
  end
end