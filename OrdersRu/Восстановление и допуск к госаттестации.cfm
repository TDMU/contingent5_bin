uses
  'confirm.cfm';
  
var
  s: string;

begin
  ShowTitle('�������������� �� �������� � ������ �� ����������');

  ShowInfo('������ = ''�������''');
  ShowInfo('������������� = ''' + Params.Item('NewSpeciality_SPECIALITY').Value + '''');
  ShowInfo('������������� = ''' + Params.Item('Department_DEPARTMENT').Value + '''');
  ShowInfo('����� �������� = ''' + Params.Item('EduForm_EDUFORM').Value + '''');
  ShowInfo('����� �������������� = ''' + Params.Item('NewEduBasis_EDUBASIS').Value + '''');
  ShowInfo('������� = ''' + VarToStr(Params.Item('NewSemester_SEMESTER').Value) + '''');
  ShowInfo('������� ��� = ''' + Params.Item('NewEduYear_EDUYEARSTR').Value + '''');
  ShowInfo('���� �������� = ''' + Params.Item('NewEduTerm_EDUTERMNAME').Value + '''');
  if Params.Item('NewGroupNum').Value <> '' then
    ShowInfo('������ = ''' + Params.Item('NewGroupNum').Value + '''');
  ShowInfo(#13#10);

  if Params.Item('FromVuz_Enabled').Value then
	begin
    case (Params.Item('AccessType_KEY').Value) of
		 0: AddReason(11);
		 1: AddReason(14);
		 2: AddReason(15);
		end;
	end	
  else
	begin
    case (Params.Item('AccessType_KEY').Value) of
		 0: AddReason(10);
		 1: AddReason(12);
		 2: AddReason(13);
		end;
	end;	

  if Params.Item('EnterDate_Enabled').Value then
    s := 'Date=?EnterDate'#13#10
  else
    s := 'Date=?OrderDate'#13#10;

  if Params.Item('NewGroupNum').Value <> '' then
    s := s + 'GroupNum=?NewGroupNum'#13#10;

  PartConfirm(s +
              'SpecialityID=?NewSpeciality_SPECIALITYID'#13#10 +
              'DepartmentID=?Department_DEPARTMENTID'#13#10 +
              'EduBasis=?NewEduBasis_EDUBASISID'#13#10 +
              'EduForm=?EduForm_EDUFORMID'#13#10 +
              'EduTerm=?NewEduTerm_EDUTERM'#13#10 +
              'Semester=?NewSemester_SEMESTER'#13#10 +
              'EduYear=?NewEduYear_EDUYEAR'#13#10 +
              'Status=''�''');

end.
