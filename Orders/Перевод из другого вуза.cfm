uses
  'confirm.cfm';

begin
  ShowTitle('Переведення з іншого ВНЗ');

  ShowInfo('Статус = ''Студент''');
  ShowInfo('Спеціальність = ''' + Params.Item('Speciality_SPECIALITY').Value + '''');
  ShowInfo('Підрозділ = ''' + Params.Item('Department_DEPARTMENT').Value + '''');
  ShowInfo('Форма навчання = ''' + Params.Item('EduForm_EDUFORM').Value + '''');
  ShowInfo('Форма фінансування = ''' + Params.Item('EduBasis_EDUBASIS').Value + '''');
  ShowInfo('Семестр = ''' + VarToStr(Params.Item('Semester_SEMESTER').Value) + '''');
  ShowInfo('Навчальний рік = ''' + Params.Item('EduYear_EDUYEARSTR').Value + '''');
  ShowInfo('Строк навчання = ''' + Params.Item('EduTerm_EDUTERMNAME').Value + '''');
  ShowInfo('Група = ''' + Params.Item('GroupNum').Value + '''');
  ShowInfo(#13#10);

  AddReason(3);

  PartConfirm('Date=?EnterDate'#13#10 +
              'SpecialityID=?Speciality_SPECIALITYID'#13#10 +
              'DepartmentID=?Department_DEPARTMENTID'#13#10 +
              'EduBasis=?EduBasis_EDUBASISID'#13#10 +
              'EduForm=?EduForm_EDUFORMID'#13#10 +
              'EduTerm=?EduTerm_EDUTERM'#13#10 +
              'Semester=?Semester_SEMESTER'#13#10 +
              'EduYear=?EduYear_EDUYEAR'#13#10 +
              'Status=''С'''#13#10 +
              'GroupNum=?GroupNum');
end.
