uses
  'confirm.cfm';

begin
  ShowTitle('������ �� ��������');

  if Params.Item('AccessReason_KEY').Value <> 3 then  // �� ������� �� ������� ����
  begin
    ShowInfo('������ = ''�������''');
    ShowInfo('������� = ''' + VarToStr(Params.Item('NewSemester_SEMESTER').Value) + '''');
    ShowInfo('���������� �� = ''' + Params.Item('NewEduYear_EDUYEARSTR').Value + '''');
    ShowInfo('����� = ''' + Params.Item('NewGroupNum').Value + '''');
    ShowInfo(#13#10);

    AddReason(Params.Item('AccessReason_KEY').Value);
  
    PartConfirm('Date=?FromDate'#13#10 +
                'Semester=?NewSemester_SEMESTER'#13#10 +
                'EduYear=?NewEduYear_EDUYEAR'#13#10 +
                'Status=''�'''#13#10 +
                'GroupNum=?NewGroupNum');
  end
  else
  begin
    ShowNotChangeInfo;
    
    AddReason(Params.Item('AccessReason_KEY').Value);

  end;
  
end.
