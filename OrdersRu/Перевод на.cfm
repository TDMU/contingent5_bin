uses
  'confirm.cfm';

var
  SL: TStringList;

begin
  ShowTitle('Перевод');
  
  SL := TStringList.Create;
  try
    SL.Add('Date=?FromDate');

    if Params.Item('Department_Changed').Value then
    begin
      ShowInfo('Подразделение = ''' + Params.Item('NewDepartment_DEPARTMENT').Value + '''');
      AddReason(2001);
      SL.Add('DepartmentID=?NewDepartment_DEPARTMENTID');
    end;

    if Params.Item('Speciality_Changed').Value then
    begin
      ShowInfo('Специальность = ''' + Params.Item('NewSpeciality_SPECIALITY').Value + '''');
      AddReason(2002);
      SL.Add('SpecialityID=?NewSpeciality_SPECIALITYID');
    end;

    if Params.Item('EduBasis_Changed').Value then
    begin
      ShowInfo('Форма финансирования = ''' + Params.Item('NewEduBasis_EDUBASIS').Value + '''');

      if Params.Item('NewEduBasis_EDUBASISID').Value = 'Б' then
        AddReason(2101)
      else
        AddReason(2102);

      SL.Add('EduBasis=?NewEduBasis_EDUBASISID');
    end;

    if Params.Item('EduForm_Changed').Value then
    begin
      ShowInfo('Форма обучения = ''' + Params.Item('NewEduForm_EDUFORM').Value + '''');
      AddReason(2004);
      SL.Add('EduForm=?NewEduForm_EDUFORMID');
    end;

    if Params.Item('EduTerm_Changed').Value then
    begin
      ShowInfo('Срок обучения = ''' + Params.Item('NewEduTerm_EDUTERMNAME').Value + '''');
      AddReason(2005);
      SL.Add('EduTerm=?NewEduTerm_EDUTERM');
    end;

    if Params.Item('Semester_Changed').Value then
    begin
      ShowInfo('Семестр = ''' + VarToStr(Params.Item('NewSemester_SEMESTER').Value) + '''');
      SL.Add('Semester=?NewSemester_SEMESTER');
    end;

    if Params.Item('NewGroupNum').Value <> '' then
    begin
      ShowInfo('Группа = ''' + Params.Item('NewGroupNum').Value + '''');
      SL.Add('GroupNum=?NewGroupNum');
    end;

    PartConfirm(SL.Text);
  finally
    SL.Free;
  end;
end.
