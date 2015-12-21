uses
  'confirm.cfm';
  
var
  s: string;

begin
  ShowTitle('Поновлення на навчання');

  ShowInfo('Статус = ''Студент''');
  ShowInfo('Спеціальність = ''' + Params.Item('NewSpeciality_SPECIALITY').Value + '''');
  ShowInfo('Підрозділ = ''' + Params.Item('Department_DEPARTMENT').Value + '''');
  ShowInfo('Форма навчання = ''' + Params.Item('EduForm_EDUFORM').Value + '''');
  ShowInfo('Форма фінансування = ''' + Params.Item('NewEduBasis_EDUBASIS').Value + '''');
  ShowInfo('Семестр = ''' + VarToStr(Params.Item('NewSemester_SEMESTER').Value) + '''');
  ShowInfo('Навчальний рік = ''' + Params.Item('NewEduYear_EDUYEARSTR').Value + '''');
  ShowInfo('Термін навчання = ''' + Params.Item('NewEduTerm_EDUTERMNAME').Value + '''');
  if Params.Item('NewGroupNum').Value <> '' then
    ShowInfo('Група = ''' + Params.Item('NewGroupNum').Value + '''');
  ShowInfo(#13#10);

  if Params.Item('FromVuz_Enabled').Value then
    AddReason(4)
  else
    AddReason(2);

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
              'Status=''С''');

end.
