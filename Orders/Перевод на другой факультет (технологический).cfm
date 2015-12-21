uses
  'confirm.cfm';

var
  SL: TStringList;

begin
  ShowTitle('����������� (������������)');

  SL := TStringList.Create;
  try
    SL.Add('Date=?FromDate');

    if Params.Item('Department_Changed').Value then
    begin
      ShowInfo('ϳ������ = ''' + Params.Item('NewDepartment_DEPARTMENT').Value + '''');
      AddReason(13010);
      SL.Add('DepartmentID=?NewDepartment_DEPARTMENTID');
    end;

    if Params.Item('Speciality_Changed').Value then
    begin
      ShowInfo('������������ = ''' +Params.Item('NewSpeciality_SPECIALITY').Value + '''');
      AddReason(13020);
      SL.Add('SpecialityID=?NewSpeciality_SPECIALITYID');
    end;

    if Params.Item('EduTerm_Changed').Value then
    begin
      ShowInfo('����� �������� = ''' +  Params.Item('NewEduTerm_EDUTERMNAME').Value + '''');
      AddReason(13030);
      SL.Add('EduTerm=?NewEduTerm_EDUTERM');
    end;

    PartConfirm(SL.Text);
  finally
    SL.Free;
  end;
end.
