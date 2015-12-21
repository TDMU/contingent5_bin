uses
  'confirm.cfm';

begin
  ShowTitle('������� �� ������ �������');

  ShowInfo('������� = ''' + VarToStr(Params.Item('NewSemester_SEMESTER').Value) + '''');
  ShowInfo('������� ��� = ''' + Params.Item('NewEduYear_EDUYEARSTR').Value + '''');
  ShowInfo(#13#10);

  AddReason(4000 + Params.Item('NewSemester_SEMESTER').Value - 1);

  PartConfirm('Date=?OrderDate'#13#10 +
              'Semester=?NewSemester_SEMESTER'#13#10 +
              'EduYear=?NewEduYear_EDUYEAR');
end.
