
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Состояние(НСтр("ru = 'Формирование состава уровня доступа'"),, НСтр("ru = '
                                                                         |Выполняется...'"), БиблиотекаКартинок.Информация2_32);
		СформироватьУровеньДоступа(ПараметрКоманды);
	
	Состояние(НСтр("ru = 'Формирование состава уровня доступа'"),, НСтр("ru = '
                                                                         |Выполнено.'"), БиблиотекаКартинок.Информация2_32);
КонецПроцедуры

&НаСервере
Процедура СформироватьУровеньДоступа(ПараметрКоманды)
	вогУправлениеДоступом.СформироватьУровеньДоступа(ПараметрКоманды);
КонецПроцедуры // СформироватьУровеньДоступа()
