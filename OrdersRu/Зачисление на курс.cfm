uses
  'confirm.cfm';

begin
  if Params.Item('Edu2').Value then
    ShowTitle('���������� �� ���� (������ ������ �����������)')
  else
    ShowTitle('���������� �� ����');

  ShowInfo('������ = ''�������''');
  ShowInfo('������������� = ''' + Params.Item('Speciality_SPECIALITY').Value + '''');
  ShowInfo('������������� = ''' + Params.Item('Department_DEPARTMENT').Value + '''');
  ShowInfo('����� �������� = ''' + Params.Item('EduForm_EDUFORM').Value + '''');
  ShowInfo('����� �������������� = ''' + Params.Item('EduBasis_EDUBASIS').Value + '''');
  ShowInfo('������� = ''' + VarToStr(Params.Item('Semester_SEMESTER').Value) + '''');
  ShowInfo('������� ��� = ''' + Params.Item('EduYear_EDUYEARSTR').Value + '''');
  ShowInfo('���� �������� = ''' + Params.Item('EduTerm_EDUTERMNAME').Value + '''');
  ShowInfo(#13#10);

  if Params.Item('Edu2').Value then
    AddReason(5) // ������ ������
  else
    AddReason(1);


  PartConfirm('Date=?EnterDate'#13#10 +
              'SpecialityID=?Speciality_SPECIALITYID'#13#10 +
              'DepartmentID=?Department_DEPARTMENTID'#13#10 +
              'EduBasis=?EduBasis_EDUBASISID'#13#10 +
              'EduForm=?EduForm_EDUFORMID'#13#10 +
              'EduTerm=?EduTerm_EDUTERM'#13#10 +
              'Semester=?Semester_SEMESTER'#13#10 +
              'EduYear=?EduYear_EDUYEAR'#13#10 +
              'Status=''�''');
              
  Utils.ExecSQL('update STUDENTS set ENTERDATE = ?EnterDate ' +
                'where STUDENTID in ( ' +
                'select STUDENTID ' +
                'from PARTITIONSTOSTUDENTS ' +
                'where PARTITIONID = ?PARTITIONID)');

end.
