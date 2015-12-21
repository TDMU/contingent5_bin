uses
  'confirm.cfm';

begin
  ShowTitle('Непереведення на інший семестр');

  ShowNotChangeInfo;
  ShowInfo(#13#10);

  AddReason(5000 + Params.Item('NewSemester').Value - 1);
end.
