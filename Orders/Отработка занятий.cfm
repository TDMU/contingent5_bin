uses
  'confirm.cfm';

begin
  ShowTitle('³�������������� ������ ' + Params.Item('Reason_REASON').Value);

  ShowNotChangeInfo;

  AddReason(Params.Item('Reason_REASONID').Value);
end.
