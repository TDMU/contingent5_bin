uses
  'confirm.cfm';

begin
  ShowTitle('Зміненя громадянства');

  ShowInfo('Громадянство = ''' + Params.Item('NewCountry_COUNTRYNAME').Value + '''');
  ShowInfo(#13#10);

  AddReason(11016);

  PartConfirm('Date=?OrderDate'#13#10 +
              'CountryID=?NewCountry_COUNTRYID');
end.
