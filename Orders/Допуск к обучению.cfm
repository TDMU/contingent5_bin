uses
  'confirm.cfm';

begin
  ShowTitle('Допуск до навчання');

  if Params.Item('AccessReason_KEY').Value <> 3 then  // Не перевод из другого вуза
  begin
    ShowInfo('Статус = ''Студент''');
    ShowInfo('Семестр = ''' + VarToStr(Params.Item('NewSemester_SEMESTER').Value) + '''');
    ShowInfo('Навчальний рік = ''' + Params.Item('NewEduYear_EDUYEARSTR').Value + '''');
    ShowInfo('Група = ''' + Params.Item('NewGroupNum').Value + '''');
    ShowInfo(#13#10);

    AddReason(Params.Item('AccessReason_KEY').Value);
  
    PartConfirm('Date=?FromDate'#13#10 +
                'Semester=?NewSemester_SEMESTER'#13#10 +
                'EduYear=?NewEduYear_EDUYEAR'#13#10 +
                'Status=''С'''#13#10 +
                'GroupNum=?NewGroupNum');
  end
  else
  begin
    ShowNotChangeInfo;
    
    AddReason(Params.Item('AccessReason_KEY').Value);

  end;
  
end.
